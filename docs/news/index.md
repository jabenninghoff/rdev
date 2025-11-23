# Changelog

## rdev 1.15.3

- Minor updates

## rdev 1.15.2

- Minor updates to
  [`upkeep_checklist()`](https://jabenninghoff.github.io/rdev/reference/upkeep_checklist.md),
  GitHub Actions (`missing-deps`)

## rdev 1.15.1

- Minor updates to
  [`upkeep_checklist()`](https://jabenninghoff.github.io/rdev/reference/upkeep_checklist.md)

- Initial upkeep using
  [`use_upkeep_issue()`](https://jabenninghoff.github.io/rdev/reference/use_upkeep_issue.md)

- [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md)
  now opens the new repository on both macOS and Windows

## rdev 1.15.0

- Added functions
  [`use_upkeep_issue()`](https://jabenninghoff.github.io/rdev/reference/use_upkeep_issue.md)
  and
  [`upkeep_checklist()`](https://jabenninghoff.github.io/rdev/reference/upkeep_checklist.md),
  used to open an issue in the package repository with a checklist of
  maintenance tasks, based on
  [`usethis::use_upkeep_issue()`](https://usethis.r-lib.org/reference/use_upkeep_issue.html)
  and
  [`usethis::use_tidy_upkeep_issue()`](https://usethis.r-lib.org/reference/tidyverse.html)

- Updated base GitHub Actions (`R-CMD-check`, `lint`, `missing-deps`)
  (update
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md))

- Updated code coverage GitHub Action (`test-coverage`) (update
  [`use_codecov()`](https://jabenninghoff.github.io/rdev/reference/use_codecov.md))

- Updated Get Started vignette with additional notes on replacing
  [RStudio](https://posit.co/download/rstudio-desktop/) with
  [Positron](https://github.com/posit-dev/positron)

## rdev 1.14.1

- Improved checks for
  [`merge_release()`](https://jabenninghoff.github.io/rdev/reference/merge_release.md)

- Added new quarto .gitignore exclusions (update
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md))

- Updated Get Started vignette with current usethis advice on storing
  GitHub credentials

## rdev 1.14.0

- Added utility function
  [`package_type()`](https://jabenninghoff.github.io/rdev/reference/package_type.md):
  determine rdev package type

- Added an option to update the spelling `WORDLIST` to
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md) (on by
  default)

## rdev 1.13.0

- Added function
  [`use_gitattributes()`](https://jabenninghoff.github.io/rdev/reference/use_gitattributes.md):
  Install rdev .gitattributes template using
  [`usethis::use_template()`](https://usethis.r-lib.org/reference/use_template.html)
  to set GitHub Linguist
  [overrides](https://github.com/github-linguist/linguist/blob/main/docs/overrides.md)

## rdev 1.12.3

- [`new_branch()`](https://jabenninghoff.github.io/rdev/reference/new_branch.md)
  now stashes untracked files

## rdev 1.12.2

- Minor fixes

## rdev 1.12.1

- Updated for R 4.5.0

## rdev 1.12.0

- Updated for `lintr` 3.2.0 (update
  [`use_lintr()`](https://jabenninghoff.github.io/rdev/reference/use_lintr.md))

## rdev 1.11.6

- Minor updates

## rdev 1.11.5

- rdev now depends on R \>= 4.0.0

- [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)
  now records dependency on R native pipes (R \>= 4.1.0)

## rdev 1.11.4

- Updated “Introduction to rdev” vignette,
  [`vignette("rdev")`](https://jabenninghoff.github.io/rdev/articles/rdev.md)

## rdev 1.11.3

- Added support for Visual Studio Code (`languageserver` package) by
  default

## rdev 1.11.2

- Minor updates

## rdev 1.11.1

- Enabled pkgdown [“light
  switch”](https://pkgdown.r-lib.org/articles/customise.html#light-switch)
  by default for packages using
  [`use_rdev_pkgdown()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_pkgdown.md)

## rdev 1.11.0

- Added function
  [`package_downloads()`](https://jabenninghoff.github.io/rdev/reference/package_downloads.md):
  A wrapper for
  [`cranlogs::cran_downloads()`](https://r-hub.github.io/cranlogs/reference/cran_downloads.html)
  that summarizes the number of package downloads from the RStudio CRAN
  mirror

## rdev 1.10.11

- Minor updates

## rdev 1.10.10

- Bug fixes

## rdev 1.10.9

- Add support for single URL in DESCRIPTION

## rdev 1.10.8

- Added support for private repositories to
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md)

## rdev 1.10.7

- Added support for creating private repositories to
  [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md)

## rdev 1.10.6

- Updated for R 4.4.0

## rdev 1.10.5

- Updated pkgdown templates (update:
  [`use_rdev_pkgdown()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_pkgdown.md)
  or `use_analysis_package(use_quarto = FALSE)`)

## rdev 1.10.4

- Updated GitHub Actions to work better with renv (update from
  <https://github.com/jabenninghoff/rdev/tree/main/.github/workflows>)

## rdev 1.10.3

- Updated `R-CMD-check.yaml` GitHub Action (update:
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md))

## rdev 1.10.2

rdev now supports Quarto Documents (`.qmd`) as analysis notebooks:

- [`rmd_metadata()`](https://jabenninghoff.github.io/rdev/reference/rmd_metadata.md)
  will extract the YAML front matter and description from Quarto format
  (`.qmd`) notebooks if `_quarto.yml` is present

- [`build_quarto_site()`](https://jabenninghoff.github.io/rdev/reference/build_quarto_site.md)
  now supports use of both `Rmd` and/or `qmd` notebooks in `analysis`

- [`spell_check_notebooks()`](https://jabenninghoff.github.io/rdev/reference/spell_check_notebooks.md)
  and
  [`update_wordlist_notebooks()`](https://jabenninghoff.github.io/rdev/reference/update_wordlist_notebooks.md)
  now check both `Rmd` and `qmd` files in the `analysis` directory

- Updated `README.Rmd` template to list all `.Rmd` and `.qmd` notebooks
  in `analysis`

- Added reference Quarto Document analysis template to
  `inst/templates/analysis.qmd` (RStudio currently doesn’t support
  [`.qmd` files as document
  templates](https://github.com/rstudio/rstudio/issues/11316))

- Updated vignettes

## rdev 1.10.1

- Added an `unfreeze` parameter to
  [`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md),
  which is passed on to
  [`build_quarto_site()`](https://jabenninghoff.github.io/rdev/reference/build_quarto_site.md)

## rdev 1.9.11

- Maintenance updates

## rdev 1.9.10

- Updated
  [`build_rdev_site()`](https://jabenninghoff.github.io/rdev/reference/build_rdev_site.md)
  and
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
  to use
  [`pkgdown::build_site_github_pages()`](https://pkgdown.r-lib.org/reference/build_site_github_pages.html)
  instead of
  [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html),
  which disables Jekyll rendering and adds a `CNAME` if needed

## rdev 1.9.9

- Updated quarto configuration (update:
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md))

## rdev 1.9.8

- Added quarto themes (flatly, darkly) (update:
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md))

- Updated analysis template

## rdev 1.9.7

- Maintenance updates

## rdev 1.9.6

- Add new rdev hex sticker logo from
  [stickers](https://jabenninghoff.github.io/stickers/) to
  `man/figures/logo.png` per
  [roxygen2](https://github.com/r-lib/roxygen2/blob/db4dd9a4de2ce6817c17441d481cf5d03ef220e2/R/object-defaults.R#L43)
  and to `README.Rmd` per
  [pkgdown](https://github.com/r-lib/pkgdown/blob/548a9493b72ff93d3ed8392d4ad30b77d8b15fa5/README.Rmd#L15)

- Fixed bugs in `quickstart` functions

## rdev 1.9.5

- Updated TODO

## rdev 1.9.4

- Updated `lintr.yaml` GitHub Action to match
  [`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md)
  (update: run
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md))

## rdev 1.9.3

- [`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md)
  and
  [`style_all()`](https://jabenninghoff.github.io/rdev/reference/style_all.md)
  now (properly) exclude `R/RcppExports.R`

## rdev 1.9.2

- Updated manual tests

- Bug fixes

## rdev 1.9.1

- Maintenance updates

## rdev 1.9.0

- Adjusted Quarto margins in `_quarto.yml`

- Added
  [`?quickstart`](https://jabenninghoff.github.io/rdev/reference/quickstart.md)
  rdev Quick Start guide to creating a new rdev or analysis package and
  updated related functions
  ([`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md),
  [`init()`](https://jabenninghoff.github.io/rdev/reference/init.md),
  [`setup_analysis()`](https://jabenninghoff.github.io/rdev/reference/setup_analysis.md))
  and README

- Added function
  [`setup_rdev()`](https://jabenninghoff.github.io/rdev/reference/setup_rdev.md):
  set up an rdev package for traditional package development

- Added function
  [`open_files()`](https://jabenninghoff.github.io/rdev/reference/open_files.md):
  open a standard set of files for editing in RStudio

- [`setup_analysis()`](https://jabenninghoff.github.io/rdev/reference/setup_analysis.md)
  and
  [`setup_rdev()`](https://jabenninghoff.github.io/rdev/reference/setup_rdev.md)
  now call
  [`open_files()`](https://jabenninghoff.github.io/rdev/reference/open_files.md)
  if running in RStudio

## rdev 1.8.6

- Check function arguments with
  [checkmate](https://mllg.github.io/checkmate/index.html)

## rdev 1.8.5

- Changed
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)
  to store `_freeze` directory in git per Quarto
  [guide](https://quarto.org/docs/projects/code-execution.html#using-freeze)

## rdev 1.8.4

- Also set GitHub Pages URL in
  [`use_rdev_pkgdown()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_pkgdown.md)

## rdev 1.8.3

- Check if `pandoc` is in `PATH` on launch (update:
  [`use_rprofile()`](https://jabenninghoff.github.io/rdev/reference/use_rprofile.md))

## rdev 1.8.2

- Added rendering fixes to
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)
  (update: re-run
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)
  and update notebooks from Analysis Notebook template)

- Added function
  [`use_rdev_pkgdown()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_pkgdown.md):
  add pkgdown with rdev customizations

## rdev 1.8.1

- Added support for [Visual Studio Code](https://code.visualstudio.com)
  to `setup-r`

- Quarto bug fixes

## rdev 1.8.0

Added support for [Quarto](https://quarto.org), including:

- New function
  [`build_quarto_site()`](https://jabenninghoff.github.io/rdev/reference/build_quarto_site.md):
  a wrapper for
  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
  that also updates `README.md` and optionally deletes the Quarto
  `_freeze` directory to fully re-render the site

- New function
  [`unfreeze()`](https://jabenninghoff.github.io/rdev/reference/unfreeze.md):
  delete the Quarto `_freeze` directory to fully re-render the site when
  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
  is called

- Updated
  [`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md)
  to run
  [`build_quarto_site()`](https://jabenninghoff.github.io/rdev/reference/build_quarto_site.md)
  when using Quarto

- Updated
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)
  to use Quarto for publishing by default

- Added “quarto” package type to
  [`local_temppkg()`](https://jabenninghoff.github.io/rdev/reference/local_temppkg.md)

Additional changes:

- Updated vignettes

- Added “Introduction to rdev” getting started vignette

- Added a
  [`pkgdown::check_pkgdown()`](https://pkgdown.r-lib.org/reference/check_pkgdown.html)
  check to
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md)

## rdev 1.7.2

- Updated `.lintr` for `lintr` 3.1.1 (update
  [`use_lintr()`](https://jabenninghoff.github.io/rdev/reference/use_lintr.md))

## rdev 1.7.1

- Updated installation instructions in README and templates to use
  `remotes` instead of `devtools`

## rdev 1.7.0

- Updated
  [`check_renv()`](https://jabenninghoff.github.io/rdev/reference/check_renv.md)
  and [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md) to
  use `renv::status(dev = TRUE)`, added in `renv` 1.0.3

## rdev 1.6.9

- Disabled use of Posit package manager in `R-CMD-check.yaml` (update
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md))

## rdev 1.6.8

- Updated `setup-r` to use `rig` for installing and managing R versions

## rdev 1.6.7

- Maintenance updates

## rdev 1.6.6

- Replaced `check-standard.yaml` with `R-CMD-check.yaml` (update
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md))

- Updated `.lintr` for `lintr` 3.1.0 (update
  [`use_lintr()`](https://jabenninghoff.github.io/rdev/reference/use_lintr.md))

- Updated spelling tests (update
  [`use_spelling()`](https://jabenninghoff.github.io/rdev/reference/use_spelling.md))

## rdev 1.6.5

- Maintenance updates

## rdev 1.6.4

- Added check to install pre-commit git hook if missing (update
  [`use_rprofile()`](https://jabenninghoff.github.io/rdev/reference/use_rprofile.md))

## rdev 1.6.3

- [`extra_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)
  no longer reports R as an extra package

## rdev 1.6.2

- [`missing_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)
  now excludes base R packages by default

- Added new checks to
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md):
  [`missing_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md),
  [`desc::desc_normalize()`](https://desc.r-lib.org/reference/desc_normalize.html),
  [`extra_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md),
  [`url_check()`](https://jabenninghoff.github.io/rdev/reference/urlchecker-reexports.md),
  and
  [`html_url_check()`](https://jabenninghoff.github.io/rdev/reference/html_url_check.md);
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md) will
  stop if
  [`missing_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)
  returns one or more rows

- Added `missing-deps.yaml` GitHub Action

## rdev 1.6.1

- [`new_branch()`](https://jabenninghoff.github.io/rdev/reference/new_branch.md)
  now stashes and restores changes, so that the `Bump version` commit
  just changes the version number in `DESCRIPTION`

## rdev 1.6.0

- [`missing_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)
  and
  [`extra_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)
  now automatically remove the current package and `renv` (in
  `renv.lock`) from the list of
  [`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html)

## rdev 1.5.9

- Update
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
  and ‘Analysis Notebook’ R markdown template to use Bootstrap 5 using
  [`bslib`](https://rstudio.github.io/bslib/)

- Update rdev pkgdown site to use Bootstrap 5

## rdev 1.5.8

- Update options to enable warnings for all partial matches

## rdev 1.5.7

- Add option to warn on partial \$ matches

## rdev 1.5.6

- Update
  [`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md)
  to also check `.Rpres` files

## rdev 1.5.5

- Add option to disable GitHub Pages in
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md)
  with `options(rdev.github.pages = FALSE)`

- Use proper GitHub Pages URL with trailing “/”

## rdev 1.5.4

- Minor maintenance updates

## rdev 1.5.3

- Maintenance updates

## rdev 1.5.2

- Minor updates to Style Guide

## rdev 1.5.1

- Replace development lintr with CRAN release 3.0.0

- Add Style Guide vignette, describing rdev coding style,
  [styler](https://styler.r-lib.org) and
  [lintr](https://lintr.r-lib.org) configuration

## rdev 1.5.0

- Added styler cache options to `.Rprofile` template

- Imported
  [`urlchecker::url_check()`](https://rdrr.io/pkg/urlchecker/man/url_check.html),
  [`urlchecker::url_update()`](https://rdrr.io/pkg/urlchecker/man/url_update.html),
  and added a new function,
  [`html_url_check()`](https://jabenninghoff.github.io/rdev/reference/html_url_check.md),
  to check URLs in `docs/` (replaces `proof-docs` script)

- Replaced scripts in `tools/` for automating package setup with
  [`init()`](https://jabenninghoff.github.io/rdev/reference/init.md):
  run after
  [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md),
  and
  [`setup_analysis()`](https://jabenninghoff.github.io/rdev/reference/setup_analysis.md):
  run after
  [`init()`](https://jabenninghoff.github.io/rdev/reference/init.md)

- Moved `setup-r` to `inst/bin`

- Increased test coverage

## rdev 1.4.9

- Clean up tests, standardize error messages

## rdev 1.4.8

- Make rdev [data.table
  aware](https://rdatatable.gitlab.io/data.table/articles/datatable-importing.html#data-table-in-imports-but-nothing-imported)

## rdev 1.4.7

- Added scripts to `tools/` to further automate package setup

## rdev 1.4.6

- Updated lint workflow

## rdev 1.4.5

- Updated for new linters

## rdev 1.4.4

- Enable most linters in `inst/templates/lintr`

## rdev 1.4.3

- Normalize DESCRIPTION file

## rdev 1.4.2

- Remove workaround for resolved upstream issue

## rdev 1.4.1

- Added missing Suggests dependencies in setup functions

## rdev 1.4.0

- Added functions to check dependencies:
  [`missing_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)
  reports
  [`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html)
  not in DESCRIPTION,
  [`extra_deps()`](https://jabenninghoff.github.io/rdev/reference/deps_check.md)
  reports
  [`desc::desc_get_deps()`](https://desc.r-lib.org/reference/desc_get_deps.html)
  not found by renv

- Added `renv` check to
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md): if
  [`renv::status()`](https://rstudio.github.io/renv/reference/status.html)
  is not synchronized,
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md) will
  stop

## rdev 1.3.8

- Fix bugs in tests,
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)

## rdev 1.3.7

- Fixed bug in lint workflow

## rdev 1.3.6

- Updated `.Rprofile` to load current package at start

- Updated for R version 4.2.0 (2022-04-22) – “Vigorous Calisthenics”

## rdev 1.3.5

- Updated GitHub workflows

## rdev 1.3.4

- Added new test scripts for new package setup

## rdev 1.3.3

- Fixed [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md)
  and
  [`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md)
  to correctly use
  [`gert::git_status()`](https://docs.ropensci.org/gert/reference/git_commit.html)
  to determine if uncommitted changes exist (instead of
  [`gert::git_diff_patch()`](https://docs.ropensci.org/gert/reference/git_diff.html))

## rdev 1.3.2

- Fixed
  [`update_wordlist_notebooks()`](https://jabenninghoff.github.io/rdev/reference/update_wordlist_notebooks.md):
  removed duplicate words

- Update
  [`use_spelling()`](https://jabenninghoff.github.io/rdev/reference/use_spelling.md)
  to install test-spelling.R testthat template

## rdev 1.3.1

- Added
  [`update_wordlist_notebooks()`](https://jabenninghoff.github.io/rdev/reference/update_wordlist_notebooks.md):
  Update package `inst/WORDLIST` with words from
  [`spell_check_notebooks()`](https://jabenninghoff.github.io/rdev/reference/spell_check_notebooks.md)

- Updated
  [`spell_check_notebooks()`](https://jabenninghoff.github.io/rdev/reference/spell_check_notebooks.md)
  to use Language field in `DESCRIPTION` by default

## rdev 1.3.0

Added new options and features to support GitHub Enterprise.

### New Options

Added settings, configured using
[`options()`](https://rdrr.io/r/base/options.html)

- `rdev.host`: set the default server for
  [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md),
  [`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md),
  [`merge_release()`](https://jabenninghoff.github.io/rdev/reference/merge_release.md)
  (to support GitHub Enterprise)

- `rdev.codecov`: to disable codecov.io support in
  [`use_codecov()`](https://jabenninghoff.github.io/rdev/reference/use_codecov.md)

- `rdev.dependabot`: to disable support for Dependabot in
  [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md)

- `rdev.license` and `rdev.license.copyright`: specify licenses for
  [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md),
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md)

- `rdev.github.actions`: to disable support for GitHub Actions in
  [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md),
  [`use_codecov()`](https://jabenninghoff.github.io/rdev/reference/use_codecov.md),
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md)

### New Features

- [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md)
  now supports creating repositories within organizations

- Updated `setup-r` script to include pkgdown

## rdev 1.2.6

- Updated
  [`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md)
  to run
  [`build_rdev_site()`](https://jabenninghoff.github.io/rdev/reference/build_rdev_site.md)
  only when `_pkgdown.yml` exists

## rdev 1.2.5

- Updated [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md)
  to run spell check tests

## rdev 1.2.4

- Fix bug in workaround for closed usethis issue
  \#[1568](https://github.com/r-lib/usethis/issues/1568)

## rdev 1.2.3

- Updated
  [`use_codecov()`](https://jabenninghoff.github.io/rdev/reference/use_codecov.md)
  to use
  [`sort_rbuildignore()`](https://jabenninghoff.github.io/rdev/reference/sort_rbuildignore.md)

## rdev 1.2.2

- Implement workaround for closed usethis issue
  \#[1568](https://github.com/r-lib/usethis/issues/1568)

- [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)
  now installs [dplyr](https://dplyr.tidyverse.org), used in the
  `README.Rmd` template

- Documentation updates

## rdev 1.2.1

- [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md)
  now adds branch protection to the default branch

## rdev 1.2.0

- Added
  [`spell_check_notebooks()`](https://jabenninghoff.github.io/rdev/reference/spell_check_notebooks.md):
  Perform a spell check on notebooks with
  [`spelling::spell_check_files()`](https://docs.ropensci.org/spelling//reference/spell_check_files.html).

## rdev 1.1.1

- Fix R-CMD-check for Windows

- [`check_renv()`](https://jabenninghoff.github.io/rdev/reference/check_renv.md)
  now defaults to running `update` when interactive

## rdev 1.1.0

- Added additional automation to
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md):
  - [`style_all()`](https://jabenninghoff.github.io/rdev/reference/style_all.md)
    now runs automatically if there are no uncommitted changes
  - [`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md)
    now runs by default and opens RStudio markers pane if any lints are
    found

## rdev 1.0.1

- Minor updates to analysis README.Rmd template

## rdev 1.0.0

rdev is now stable enough for a 1.0.0 release!

### Major features

rdev provides functions and templates for:

- Release automation: Stage and create GitHub releases, including GitHub
  pages

- Continuous Integration: Local continuous integration checks and
  dependency management

- Package Setup: Package setup tasks, typically performed once

### Recent changes

Changes since release 0.8.9:

- Add
  [`use_spelling()`](https://jabenninghoff.github.io/rdev/reference/use_spelling.md)
  and
  [`use_codecov()`](https://jabenninghoff.github.io/rdev/reference/use_codecov.md)

- Added
  [`local_temppkg()`](https://jabenninghoff.github.io/rdev/reference/local_temppkg.md)
  test helper function

- Minor enhancements to
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md),
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md),
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md),
  README.Rmd templates

- Updated documentation

- Added manual test script for new package setup, increased test
  coverage

### TODO

In [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md):

- `styler` should be set to automatically run if there are no
  uncommitted changes

- `lintr` should stop execution and open RStudio markers if any lints
  are found

- [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md) should
  run `styler` and `lintr` by default

## rdev 0.8.9

- Bug fixes for
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md),
  `proof-docs`

## rdev 0.8.8

- Added `proof-docs` script to tools, checks docs directory using
  [htmlproofer](https://github.com/gjtorikian/html-proofer)

## rdev 0.8.7

- Moved
  [`rmd_metadata()`](https://jabenninghoff.github.io/rdev/reference/rmd_metadata.md)
  from README-analysis.Rmd to rdev package

- Increased test coverage, reorganized files

## rdev 0.8.6

- Added code coverage using
  [codecov.io](https://app.codecov.io/gh/jabenninghoff/rdev), new tests
  for existing code

- Refactored
  [`sort_file()`](https://jabenninghoff.github.io/rdev/reference/sort_file.md)

## rdev 0.8.5

- Critical bug fix for
  [`to_document()`](https://jabenninghoff.github.io/rdev/reference/to_document.md)

## rdev 0.8.4

- Updated
  [`to_document()`](https://jabenninghoff.github.io/rdev/reference/to_document.md)
  to parse yaml front matter and confirm the source file is a valid R
  Notebook

## rdev 0.8.3

- Updated
  [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md)
  to better conform to rdev conventions (README.Rmd,
  .git/hooks/pre-commit), support committing and error-free
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md)
  immediately after it is run

## rdev 0.8.2

- Updated
  [`build_rdev_site()`](https://jabenninghoff.github.io/rdev/reference/build_rdev_site.md)
  and
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
  to abort if there are missing topics in the [pkgdown reference
  section](https://pkgdown.r-lib.org/reference/build_reference.html)

## rdev 0.8.1

- Added
  [`new_branch()`](https://jabenninghoff.github.io/rdev/reference/new_branch.md):
  Create a new feature branch, and (optionally) bump the version in
  DESCRIPTION

## rdev 0.8.0

Major update adding automation for GitHub releases.

### Release Automation

Added functions to automate workflow for staging and creating releases
on GitHub:

- [`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md):
  Open a GitHub pull request for a new release from NEWS.md

- [`get_release()`](https://jabenninghoff.github.io/rdev/reference/get_release.md):
  Extract release version and release notes from NEWS.md. Called by
  [`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md)
  and
  [`merge_release()`](https://jabenninghoff.github.io/rdev/reference/merge_release.md).

- [`merge_release()`](https://jabenninghoff.github.io/rdev/reference/merge_release.md):
  Merge a staged pull request and create a new GitHub release

### Other Changes

- Updated and reorganized pkgdown reference page

## rdev 0.7.3

- Updated
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
  to run
  [`devtools::build_readme()`](https://devtools.r-lib.org/reference/build_rmd.html)
  to regenerate the dynamic list of notebooks (in case new notebooks
  were added)

- Important update from renv 0.15.0 to
  [0.15.1](https://rstudio.github.io/renv/news/index.html#renv-0151)

## rdev 0.7.2

- Added info on dynamic notebook list to notebook template and Analysis
  Package Layout
  [vignette](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)

## rdev 0.7.1

- Updated
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md):
  add dynamic notebook list to `README.Rmd` template

## rdev 0.7.0

Major update adding automation for creating rdev and R analysis
packages.

### ‘Create Package’ Automation

Added functions to automate steps when creating new packages following
rdev and optionally analysis package conventions:

- [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md):
  Create new GitHub repository following rdev conventions in the active
  user’s account and create a basic package

- [`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md):
  Add rdev templates and settings within the active package. Normally
  invoked when first setting up a package.

- Install templates using
  [`usethis::use_template()`](https://usethis.r-lib.org/reference/use_template.html):
  [`use_rprofile()`](https://jabenninghoff.github.io/rdev/reference/use_rprofile.md),
  [`use_lintr()`](https://jabenninghoff.github.io/rdev/reference/use_lintr.md),
  [`use_todo()`](https://jabenninghoff.github.io/rdev/reference/use_todo.md),
  [`use_package_r()`](https://jabenninghoff.github.io/rdev/reference/use_package_r.md)

- Add functionality to
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md):
  also install the analysis package `README.Rmd` template

- Changed both
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)
  and
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
  to write `_pkgdown.yml` to the project root and to store in GitHub to
  make projects
  [discoverable](https://github.com/search?q=filename%3Apkgdown.yml+path%3A%2F&type=Code)
  by [pkgdown](https://pkgdown.r-lib.org).

- Updated `setup-r` to install rdev and dependencies in `site_library`

### Other Changes

- Added
  [`build_rdev_site()`](https://jabenninghoff.github.io/rdev/reference/build_rdev_site.md),
  a wrapper for
  [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
  optimized for rdev workflow that updates `README.md` and performs a
  clean build using pkgdown

- Added ‘Analysis Notebook’ R markdown template for RStudio (File \> New
  File \> Rmarkdown \> From Template)

- Migrated ggplot2 themes/styles (`theme_quo()`, `viridis_quo()`) to new
  package, `jabenninghoff/jbplot`

## rdev 0.6.2

- Add functionality to
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md):
  Create `_base.yml` in `pkgdown` from the first `URL` in the package
  `DESCRIPTION` file.

## rdev 0.6.1

- Critical bugfix for
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)

## rdev 0.6.0

- Added
  [`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md):
  Add the [Analysis Package
  Layout](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)
  to the current package

## rdev 0.5.3

- Add options to `theme_quo()` to disable both `panel.grid.major` and
  `panel.grid.minor` for `x` and `y`

## rdev 0.5.2

- Disable `lintr` by default in
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md), since
  the normal workflow is
  [`style_all()`](https://jabenninghoff.github.io/rdev/reference/style_all.md),
  [`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md),
  then [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md)

- Documentation fixes

## rdev 0.5.1

- Updated `theme_quo()`: set base theme to `ggplot2::theme_minimal()`
  and add parameters for disabling grid lines

## rdev 0.5.0

- Added `theme_quo()`: [ggplot2](https://ggplot2.tidyverse.org) theme
  based on `ggplot2::theme_bw()` and font
  [Lato](https://www.latofonts.com)

- Added `viridis_quo()`: Sets the default theme to `theme_quo()` and the
  default color scales to `viridis`

- maintenance

## rdev 0.4.5

- maintenance release, update GitHub Actions

## rdev 0.4.4

- Update
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
  to work with `pkgdown` version 2

## rdev 0.4.3

- maintenance, update TODO with steps for manually setting up an
  Analysis Package

## rdev 0.4.2

- maintenance release, update README and GitHub Actions

## rdev 0.4.1

- bug fixes, maintenance

## rdev 0.4.0

- Add
  [`devtools::document()`](https://devtools.r-lib.org/reference/document.html)
  option to
  [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md), turned
  on by default

- Add R Analysis Package layout definition, migrated from
  [rtraining](https://jabenninghoff.github.io/rtraining/)

- Update [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md)
  to use
  [`style_all()`](https://jabenninghoff.github.io/rdev/reference/style_all.md)
  and
  [`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md)
  for consistency

- Add `import` directory to
  [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)

- minor updates, improved tests, maintenance

## rdev 0.3.1

- maintenance release, updated for R 4.1.0

## rdev 0.3.0

- [`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md),
  new function migrated from
  [rtraining](https://jabenninghoff.github.io/rtraining/): a wrapper for
  [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
  that adds an ‘Analysis’ menu containing rendered versions of all
  `.Rmd` files in `analysis/`. It is still considered Experimental, due
  to lack of test coverage and some features that are not implemented,
  but should work for projects with limited pkgdown customization. The
  update also includes a function to convert notebooks to
  `html_document`,
  [`to_document()`](https://jabenninghoff.github.io/rdev/reference/to_document.md).

## rdev 0.2.2

- minor updates, maintenance

## rdev 0.2.1

- bug fixes

## rdev 0.2.0

- installing rdev will now automatically install preferred development
  tools as a ‘meta-package’ (like tidyverse), including: styler, lintr,
  rcmdcheck, renv, miniUI (for RStudio Addin support), devtools, and
  rmarkdown

## rdev 0.1.2

- minor updates to package and site
  (<https://jabenninghoff.github.io/rdev/>)

## rdev 0.1.1

- maintenance release

### Updates

- [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md):
  updated to match my preferred GitHub workflow:
  `use_github_action_check_standard()` with `--as-cran` removed

- documentation updates for all functions (style, links)

## rdev 0.1.0

Initial GitHub release

### New Features

- `./tools/setup-r`: shell script to install development packages to
  site repository on macOS + Homebrew

- [`check_renv()`](https://jabenninghoff.github.io/rdev/reference/check_renv.md):
  convenience function that runs `renv` `status()`, `clean()`, and
  optionally [`update()`](https://rdrr.io/r/stats/update.html) (on by
  default).

- [`style_all()`](https://jabenninghoff.github.io/rdev/reference/style_all.md):
  style all `.R` and `.Rmd` files in a project using `styler`

- [`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md):
  lint all `.R` and `.Rmd` files in a project using `lintr`

- [`sort_file()`](https://jabenninghoff.github.io/rdev/reference/sort_file.md):
  sort a file using R [`sort()`](https://rdrr.io/r/base/sort.html),
  similar to the unix `sort` command

- [`sort_rbuildignore()`](https://jabenninghoff.github.io/rdev/reference/sort_rbuildignore.md):
  sort the `.Rbuildignore` file using
  [`sort_file()`](https://jabenninghoff.github.io/rdev/reference/sort_file.md),
  because unsorted is annoying

- [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md): run
  continuous integration tests locally: lint, R CMD check, and style
  (off by default).
