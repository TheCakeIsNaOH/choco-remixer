# choco-remixer test suite (Pester v5)

## Running

Baseline run (excludes tests that assert not-yet-implemented fixes):

```
pwsh -NoProfile -File tests\run-tests.ps1
```

Full suite (after the fixes have landed):

```
pwsh -NoProfile -File tests\run-tests.ps1 -IncludePendingFixes
```

## Tagging scheme

Tests tagged `Fix` assert behavior that lands in a later remediation phase.
They are excluded from the baseline run (`-ExcludeTag Fix`) so the baseline
stays green against unmodified code. As each fix lands, its `Fix` tag is
removed and the test joins the main suite. The final gate is the full suite:

```
pwsh -NoProfile -Command "Import-Module Pester -RequiredVersion 5.7.1; Invoke-Pester -Path tests"
```

Pester is pinned to v5 (5.7.1) by `run-tests.ps1`; Pester 6 may be installed
side-by-side on this machine but these tests target v5.

## Scope notes

- Tests import the module via `choco-remixer.psm1`; config-dependent functions
  are tested with `InModuleScope` plus `Mock` (the module's dot-sourced config
  variables are injected directly in test scope).
- `TestHelpers.ps1` builds real `.nupkg` zips in Pester's `TestDrive:` for the
  `Expand-Nupkg` / `Read-*` tests; nothing is written inside the repo.
- `New-TestNupkg` mirrors the entry layout of a nupkg produced by `choco pack`
  (chocolatey 2.x), including its OPC metadata files
  (`[Content_Types].xml`, `_rels/.rels`, `package/services/metadata/core-properties/*.psmdcp`).
  `FixtureValidity.Tests.ps1` guards this by packing the fixture's own nuspec
  with the locally installed `choco` and comparing metadata entry categories
  (skipped when `choco` is unavailable).
- `Invoke-RepoMove` tests mock all network/process activity; no Nexus server
  or `choco`/`sleet` binary is required.