#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Migrate the markdown task plan under plan/tasks/todo/ into the dotbot
    task store under .bot/workspace/tasks/todo/.

.DESCRIPTION
    Parses every *.md task file, maps the frontmatter and body sections
    into a dotbot task payload, topologically sorts by depends_on, then
    invokes dotbot's Invoke-TaskCreateBulk + Invoke-PlanCreate by dot-
    sourcing the underlying tool scripts (no MCP/stdio round-trip).

    Idempotent: tasks already present (matched by custom 'slug') are
    skipped on re-run.

.PARAMETER DryRun
    Parse and map but do not write to the dotbot store. Prints a summary.

.PARAMETER Limit
    Process at most N tasks. Useful for smoke tests.

.PARAMETER SkipPlans
    Skip the plan_create pass (only create tasks).
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [int]$Limit = 0,
    [switch]$SkipPlans
)

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Paths and globals
# ---------------------------------------------------------------------------

$RepoRoot   = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$DotbotRoot = Join-Path $RepoRoot '.bot'
$TasksDir   = Join-Path $RepoRoot 'plan\tasks\todo'

if (-not (Test-Path $DotbotRoot)) {
    throw "Dotbot root not found: $DotbotRoot. Run 'dotbot init' first."
}
if (-not (Test-Path $TasksDir)) {
    throw "Markdown task source not found: $TasksDir."
}

$global:DotbotProjectRoot = $RepoRoot

Write-Host "Repo root:    $RepoRoot"
Write-Host "Dotbot root:  $DotbotRoot"
Write-Host "Markdown src: $TasksDir"
Write-Host ""

# ---------------------------------------------------------------------------
# Load dotbot tool functions and supporting module
# ---------------------------------------------------------------------------

$toolsRoot = Join-Path $DotbotRoot 'systems\mcp\tools'
foreach ($tool in @('task-create-bulk', 'plan-create', 'task-list')) {
    $script = Join-Path $toolsRoot "$tool\script.ps1"
    if (-not (Test-Path $script)) {
        throw "Required dotbot tool script missing: $script"
    }
    . $script
}

$taskIndexModule = Join-Path $DotbotRoot 'systems\mcp\modules\TaskIndexCache.psm1'
if (Test-Path $taskIndexModule) {
    Import-Module $taskIndexModule -Force
}

Import-Module powershell-yaml -ErrorAction Stop

# ---------------------------------------------------------------------------
# Mapping helpers (from plan: Field mapping section)
# ---------------------------------------------------------------------------

$VersionBase = @{
    'n/a'  = 0
    'v0.1' = 10
    'v0.2' = 30
    'v0.3' = 50
    'v0.4' = 70
    'v1.0' = 85
    'all'  = 10  # cross-cutting docs default to v0.1 base
}

$CategoryByGroup = @{
    'foundation'    = 'infrastructure'
    'config'        = 'infrastructure'
    'config2'       = 'infrastructure'
    'context'       = 'core'
    'model'         = 'core'
    'safety'        = 'core'
    'execution'     = 'core'
    'setup'         = 'infrastructure'
    'ux'            = 'ui-ux'
    'ui'            = 'ui-ux'
    'ui2'           = 'ui-ux'
    'publish'       = 'infrastructure'
    'release'       = 'infrastructure'
    'gate'          = 'core'
    'tool-runtime'  = 'feature'
    'local-tools'   = 'feature'
    'business'      = 'feature'
    'mature-agent'  = 'feature'
    'docs'          = 'infrastructure'
}

$EffortLarge  = @('rel-04','rel-05')
$EffortMedium = @('set-05','tr-06','tr-08','lt-06','biz-01','ma-01','ma-04','ma-05')

function Get-DotbotCategory([string]$group) {
    if ($CategoryByGroup.ContainsKey($group)) { return $CategoryByGroup[$group] }
    return 'feature'
}

function Get-DotbotPriority([string]$version, [int]$sequence, [string]$slug) {
    $base = if ($VersionBase.ContainsKey($version)) { $VersionBase[$version] } else { 50 }
    if ($slug -like 'doc-*') { $base = $base + 80 }     # docs sort last in their version
    [Math]::Min($base + $sequence, 100)
}

function Get-DotbotEffort([string]$slug) {
    if ($slug -in $EffortLarge)  { return 'L' }
    if ($slug -in $EffortMedium) { return 'M' }
    if ($slug -like 'gate-*' -or $slug -like 'doc-*') { return 'XS' }
    return 'S'
}

function Get-ApplicableAgents([string]$slug, [bool]$tddFirst) {
    if ($slug -like 'gate-*')                       { return @('.claude/agents/reviewer.md') }
    if ($slug -like 'doc-*')                        { return @('.claude/agents/planner.md') }
    if ($slug -like 'pub-*' -or $slug -like 'rel-*'){ return @('.claude/agents/reviewer.md') }
    if ($tddFirst)                                  { return @('.claude/agents/tester.md', '.claude/agents/implementer.md') }
    return @('.claude/agents/implementer.md')
}

# ---------------------------------------------------------------------------
# Parse a markdown task file into structured fields
# ---------------------------------------------------------------------------

function ConvertFrom-TaskMarkdown {
    [CmdletBinding()]
    param([string]$Path)

    $raw = Get-Content -Path $Path -Raw -Encoding UTF8

    # Split frontmatter and body
    if ($raw -notmatch '(?s)^---\s*\r?\n(.*?)\r?\n---\s*\r?\n(.*)$') {
        throw "No YAML frontmatter found in $Path"
    }
    $yaml = $Matches[1]
    $body = $Matches[2]

    $fm = ConvertFrom-Yaml $yaml

    # Normalise scalar fields
    $slug          = [string]$fm['id']
    $title         = [string]$fm['title']
    $version       = [string]$fm['version']
    $group         = [string]$fm['group']
    $subgroup      = if ($fm.ContainsKey('subgroup')) { [string]$fm['subgroup'] } else { '' }
    $sequence      = if ($fm.ContainsKey('sequence')) { [int]$fm['sequence'] } else { 50 }
    $status        = if ($fm.ContainsKey('status'))   { [string]$fm['status'] } else { 'todo' }
    $tddFirst      = ($fm.ContainsKey('tdd_first') -and $fm['tdd_first'] -eq $true)
    $deliverables  = @($fm['deliverables']) | Where-Object { $_ }
    $prdRefsFM     = @($fm['prd_refs'])     | Where-Object { $_ }
    $tags          = @($fm['tags'])         | Where-Object { $_ }
    $dependsOn     = @($fm['depends_on'])   | Where-Object { $_ } | ForEach-Object { [string]$_ }

    # Body sections: parse "## Heading" blocks and collect bullets/paragraphs
    $sections = @{}
    $current = $null
    $buffer = New-Object System.Collections.Generic.List[string]
    foreach ($line in $body -split "`r?`n") {
        if ($line -match '^##\s+(.+?)\s*$') {
            if ($current) { $sections[$current] = $buffer.ToArray() }
            $current = $Matches[1].Trim()
            $buffer  = New-Object System.Collections.Generic.List[string]
        } else {
            [void]$buffer.Add($line)
        }
    }
    if ($current) { $sections[$current] = $buffer.ToArray() }

    function _ExtractBullets([string[]]$lines) {
        $out = New-Object System.Collections.Generic.List[string]
        foreach ($line in $lines) {
            if ($line -match '^\s*[-*]\s+(.+?)\s*$') {
                [void]$out.Add($Matches[1])
            } elseif ($line -match '^\s*\d+\.\s+(.+?)\s*$') {
                [void]$out.Add($Matches[1])
            }
        }
        return $out.ToArray()
    }

    function _ExtractParagraph([string[]]$lines) {
        $text = ($lines | Where-Object { $_ -ne '' }) -join ' '
        return ($text -replace '\s+', ' ').Trim()
    }

    # Section keys vary slightly: gate-v01 has "Acceptance criteria (PRD §15.1)".
    function _Find([hashtable]$sections, [string]$prefix) {
        foreach ($k in $sections.Keys) {
            if ($k -like "$prefix*") { return $sections[$k] }
        }
        return @()
    }

    $overview     = _ExtractParagraph (_Find $sections 'Overview')
    $tddList      = _ExtractBullets   (_Find $sections 'TDD test list')
    $implSteps    = _ExtractBullets   (_Find $sections 'Implementation steps')
    $acceptance   = _ExtractBullets   (_Find $sections 'Acceptance criteria')
    $notes        = _ExtractBullets   (_Find $sections 'Notes / risks')
    $prdRefsBody  = _ExtractBullets   (_Find $sections 'PRD references')

    # Combined steps: TDD first (TDD: prefix), then implementation steps.
    $steps = New-Object System.Collections.Generic.List[string]
    foreach ($t in $tddList)   { [void]$steps.Add("TDD: $t") }
    foreach ($s in $implSteps) { [void]$steps.Add($s) }

    # Combined PRD refs: frontmatter list union body bullets, deduplicated.
    $prdRefs = @()
    foreach ($r in @($prdRefsFM) + @($prdRefsBody)) {
        if ($r -and ($prdRefs -notcontains $r)) { $prdRefs += $r }
    }

    return [pscustomobject]@{
        Path            = $Path
        Slug            = $slug
        Title           = $title
        Version         = $version
        Group           = $group
        Subgroup        = $subgroup
        Sequence        = $sequence
        Status          = $status
        TddFirst        = $tddFirst
        Deliverables    = $deliverables
        PrdRefs         = $prdRefs
        Tags            = $tags
        DependsOn       = $dependsOn
        Overview        = $overview
        Steps           = $steps.ToArray()
        Acceptance      = $acceptance
        Notes           = $notes
        BodyMarkdown    = $body.TrimStart()
    }
}

# ---------------------------------------------------------------------------
# Build dotbot payload from parsed task
# ---------------------------------------------------------------------------

function ConvertTo-DotbotPayload {
    param([Parameter(Mandatory)] $Task)

    # Use [string[]] casts so single-element arrays survive ConvertTo-Json
    # without being auto-unwrapped to scalars by PowerShell.

    $slug = $Task.Slug
    [ordered]@{
        # Dotbot core fields
        name                  = "[$slug] $($Task.Title)"
        description           = if ($Task.Overview) { $Task.Overview } else { $Task.Title }
        category              = Get-DotbotCategory $Task.Group
        priority              = Get-DotbotPriority $Task.Version $Task.Sequence $slug
        effort                = Get-DotbotEffort $slug
        type                  = 'prompt'
        dependencies          = [string[]]@($Task.DependsOn | ForEach-Object { $_.ToLower() })
        acceptance_criteria   = [string[]]@($Task.Acceptance)
        steps                 = [string[]]@($Task.Steps)
        applicable_agents     = [string[]]@(Get-ApplicableAgents $slug $Task.TddFirst)
        applicable_skills     = [string[]]@()
        applicable_standards  = [string[]]@()
        applicable_decisions  = [string[]]@()
        # Custom passthrough fields (preserved by dotbot)
        slug                  = $slug
        version               = $Task.Version
        group                 = $Task.Group
        subgroup              = $Task.Subgroup
        sequence              = $Task.Sequence
        tdd_first             = $Task.TddFirst
        prd_refs              = [string[]]@($Task.PrdRefs)
        deliverables          = [string[]]@($Task.Deliverables)
        tags                  = [string[]]@($Task.Tags)
        notes                 = [string[]]@($Task.Notes)
        source_markdown_path  = (Resolve-Path $Task.Path -Relative).Replace('\','/')
    }
}

# ---------------------------------------------------------------------------
# Topological sort by dependencies (Kahn's algorithm)
# ---------------------------------------------------------------------------

function Sort-TasksTopologically {
    param([object[]]$Tasks)

    $bySlug = @{}
    foreach ($t in $Tasks) { $bySlug[$t.Slug] = $t }

    $remainingDeps = @{}
    foreach ($t in $Tasks) {
        $deps = @()
        foreach ($d in $t.DependsOn) {
            if ($bySlug.ContainsKey($d)) { $deps += $d }   # ignore deps to tasks not in batch
        }
        $remainingDeps[$t.Slug] = [System.Collections.Generic.HashSet[string]]::new([string[]]$deps)
    }

    $sorted = New-Object System.Collections.Generic.List[object]
    $ready  = New-Object System.Collections.Generic.Queue[string]

    foreach ($t in $Tasks) {
        if ($remainingDeps[$t.Slug].Count -eq 0) { $ready.Enqueue($t.Slug) }
    }

    while ($ready.Count -gt 0) {
        $slug = $ready.Dequeue()
        [void]$sorted.Add($bySlug[$slug])
        foreach ($k in @($remainingDeps.Keys)) {
            if ($remainingDeps[$k].Contains($slug)) {
                [void]$remainingDeps[$k].Remove($slug)
                if ($remainingDeps[$k].Count -eq 0 -and -not ($sorted | Where-Object { $_.Slug -eq $k })) {
                    $ready.Enqueue($k)
                }
            }
        }
    }

    if ($sorted.Count -ne $Tasks.Count) {
        $remaining = $Tasks | Where-Object { -not ($sorted | Where-Object { $_.Slug -eq $_.Slug }) } | Select-Object -ExpandProperty Slug
        throw "Cyclic dependency detected. Sorted $($sorted.Count) of $($Tasks.Count). Remaining: $remaining"
    }

    return $sorted.ToArray()
}

# ---------------------------------------------------------------------------
# Read existing dotbot tasks (for idempotency)
# ---------------------------------------------------------------------------

function Get-ExistingDotbotSlugs {
    $dotbotTasksDir = Join-Path $DotbotRoot 'workspace\tasks'
    $slugs = @{}
    foreach ($status in @('todo','analysing','needs-input','analysed','in-progress','done','split','skipped','cancelled')) {
        $dir = Join-Path $dotbotTasksDir $status
        if (-not (Test-Path $dir)) { continue }
        Get-ChildItem -Path $dir -Filter '*.json' -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $obj = Get-Content $_.FullName -Raw | ConvertFrom-Json
                if ($obj.slug) { $slugs[[string]$obj.slug] = $obj.id }
            } catch { }
        }
    }
    return $slugs
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

Write-Host '=== Phase 1: parse markdown tasks ==='
$mdFiles = Get-ChildItem -Path $TasksDir -Filter '*.md' -File | Sort-Object Name
Write-Host "Found $($mdFiles.Count) markdown task files."

$parsed = New-Object System.Collections.Generic.List[object]
foreach ($f in $mdFiles) {
    try {
        $task = ConvertFrom-TaskMarkdown -Path $f.FullName
        [void]$parsed.Add($task)
    } catch {
        Write-Warning "Failed to parse $($f.Name): $_"
    }
}
Write-Host "Parsed $($parsed.Count) tasks."

# Idempotency: skip slugs already in dotbot store
$existing = Get-ExistingDotbotSlugs
if ($existing.Count -gt 0) {
    Write-Host "Found $($existing.Count) tasks already in dotbot store; skipping."
    $parsed = $parsed | Where-Object { -not $existing.ContainsKey($_.Slug) }
    Write-Host "Remaining to migrate: $($parsed.Count)."
}

if ($parsed.Count -eq 0) {
    Write-Host "Nothing to do." -ForegroundColor Green
    return
}

Write-Host ''
Write-Host '=== Phase 2: topological sort ==='
$sorted = Sort-TasksTopologically -Tasks $parsed.ToArray()
Write-Host "Sort order (first 10): $($sorted | Select-Object -First 10 | ForEach-Object { $_.Slug })"

if ($Limit -gt 0) {
    Write-Host "Limiting to first $Limit tasks (for smoke test)."
    $sorted = $sorted | Select-Object -First $Limit
}

Write-Host ''
Write-Host '=== Phase 3: build payloads ==='
$payloads = $sorted | ForEach-Object { ConvertTo-DotbotPayload -Task $_ }
Write-Host "Built $($payloads.Count) payloads."

if ($DryRun) {
    Write-Host ''
    Write-Host '=== DRY RUN — sample payload ==='
    $payloads | Select-Object -First 1 | ConvertTo-Json -Depth 6
    Write-Host ''
    Write-Host "Categories:" ($payloads | Group-Object category | ForEach-Object { "$($_.Name)=$($_.Count)" } | Sort-Object) -join ', '
    Write-Host "Efforts:   " ($payloads | Group-Object effort   | ForEach-Object { "$($_.Name)=$($_.Count)" } | Sort-Object) -join ', '
    Write-Host "Priority range: $($payloads.priority | Measure-Object -Minimum -Maximum | ForEach-Object { "$($_.Minimum)..$($_.Maximum)" })"
    return
}

# ---------------------------------------------------------------------------
# Repair: PowerShell's ConvertTo-Json on hashtables unwraps single-element
# arrays to scalars, and empty arrays serialise as null. Dotbot's bulk
# script uses hashtable+ConvertTo-Json so the on-disk JSON has the wrong
# shape for array-typed fields. Re-read each affected file, normalise array
# fields, and write back via PSCustomObject (which preserves array-ness).
# ---------------------------------------------------------------------------

$ArrayFields = @(
    'dependencies',
    'acceptance_criteria',
    'steps',
    'applicable_agents',
    'applicable_skills',
    'applicable_standards',
    'applicable_decisions',
    'prd_refs',
    'deliverables',
    'tags',
    'notes'
)

function Repair-DotbotTaskFile {
    param([string]$Path)

    # ConvertFrom-Json yields a PSCustomObject. Unlike hashtables, ConvertTo-Json
    # on PSCustomObject preserves single-element arrays — so the repair pattern is
    # to make the property value a real array (not a scalar, not $null) and let
    # ConvertTo-Json emit it correctly.

    $obj = Get-Content -Path $Path -Raw -Encoding UTF8 | ConvertFrom-Json

    foreach ($field in $ArrayFields) {
        $current = $obj.PSObject.Properties[$field]
        if (-not $current) {
            $obj | Add-Member -NotePropertyName $field -NotePropertyValue ([object[]]@()) -Force
            continue
        }
        $value = $current.Value
        if ($null -eq $value) {
            $obj.$field = [object[]]@()
            continue
        }
        if ($value -isnot [System.Array] -and $value -isnot [System.Collections.IList]) {
            # scalar — wrap in single-element array
            $obj.$field = [object[]]@($value)
            continue
        }
        # already array — leave alone
    }

    $json = $obj | ConvertTo-Json -Depth 10
    Set-Content -Path $Path -Value $json -Encoding UTF8
}

Write-Host ''
Write-Host '=== Phase 4: bulk create tasks in dotbot ==='
$bulkArgs = @{ tasks = @($payloads | ForEach-Object { [hashtable]$_ }) }
$bulkResult = Invoke-TaskCreateBulk -Arguments $bulkArgs

Write-Host "  created_count: $($bulkResult.created_count)"
Write-Host "  error_count:   $($bulkResult.error_count)"
if ($bulkResult.error_count -gt 0) {
    Write-Host "  errors:" -ForegroundColor Yellow
    foreach ($e in $bulkResult.errors) {
        Write-Host "    [$($e.index)] $($e.name): $($e.error)" -ForegroundColor Yellow
    }
}
Write-Host "  message: $($bulkResult.message)"

# Repair array-shape regressions in the JSON files dotbot just wrote.
Write-Host ''
Write-Host '=== Phase 4b: repair array-typed JSON fields ==='
$repaired = 0
foreach ($ct in $bulkResult.created_tasks) {
    if ($ct.file_path -and (Test-Path $ct.file_path)) {
        Repair-DotbotTaskFile -Path $ct.file_path
        $repaired++
    }
}
Write-Host "  repaired: $repaired files"

if ($SkipPlans) {
    Write-Host ''
    Write-Host 'Skipping plan_create pass (--SkipPlans set).' -ForegroundColor Yellow
    return
}

Write-Host ''
Write-Host '=== Phase 5: attach plan markdown per task ==='
# Map slug -> id for plans
$slugToId = @{}
foreach ($ct in $bulkResult.created_tasks) {
    if ($ct.name -match '^\[(?<slug>[a-z0-9-]+)\]') {
        $slugToId[$Matches['slug']] = $ct.id
    }
}

$planCount = 0
$planErrors = 0
foreach ($t in $sorted) {
    if (-not $slugToId.ContainsKey($t.Slug)) {
        # Could already exist — fall back to lookup
        $existingId = $existing[$t.Slug]
        if (-not $existingId) {
            Write-Warning "Skipping plan for $($t.Slug): no matching dotbot id."
            $planErrors++
            continue
        }
        $taskId = $existingId
    } else {
        $taskId = $slugToId[$t.Slug]
    }

    try {
        Invoke-PlanCreate -Arguments @{
            task_id = $taskId
            content = $t.BodyMarkdown
        } | Out-Null
        $planCount++
    } catch {
        Write-Warning "plan_create failed for $($t.Slug): $_"
        $planErrors++
    }
}
Write-Host "  plans created: $planCount"
Write-Host "  plan errors:   $planErrors"

Write-Host ''
Write-Host '=== Phase 6: verify ==='
# Skip Invoke-TaskList: it depends on the dotbot logging module which is
# only loaded inside the MCP server. Count files on disk instead.
$todoDir = Join-Path $DotbotRoot 'workspace\tasks\todo'
$todoCount = (Get-ChildItem -Path $todoDir -Filter '*.json' -ErrorAction SilentlyContinue).Count
Write-Host "  todo tasks now in dotbot: $todoCount"

$plansDir = Join-Path $DotbotRoot 'workspace\plans'
$planCountOnDisk = (Get-ChildItem -Path $plansDir -Filter '*.md' -ErrorAction SilentlyContinue).Count
Write-Host "  plans on disk:            $planCountOnDisk"

Write-Host ''
Write-Host 'Migration complete.' -ForegroundColor Green
