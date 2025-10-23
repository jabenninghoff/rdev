# rdev 1.15.0

* Added functions `use_upkeep_issue()` and `upkeep_checklist()`, used to open an issue in the package repository with a checklist of maintenance tasks, based on `usethis::use_upkeep_issue()` and `usethis::use_tidy_upkeep_issue()`

* Updated base GitHub Actions (`R-CMD-check`, `lint`, `missing-deps`) (update `use_rdev_package()`)

* Updated code coverage GitHub Action (`test-coverage`) (update `use_codecov()`)

* Updated Get Started vignette with additional notes on replacing [RStudio](https://posit.co/download/rstudio-desktop/) with [Positron](https://github.com/posit-dev/positron)

# rdev 1.14.1

* Improved checks for `merge_release()`

* Added new quarto .gitignore exclusions (update `use_analysis_package()`)

* Updated Get Started vignette with current usethis advice on storing GitHub credentials

# rdev 1.14.0

* Added utility function `package_type()`: determine rdev package type

* Added an option to update the spelling `WORDLIST` to `ci()` (on by default)

# rdev 1.13.0

* Added function `use_gitattributes()`: Install rdev .gitattributes template using `usethis::use_template()` to set GitHub Linguist [overrides](https://github.com/github-linguist/linguist/blob/main/docs/overrides.md)

# rdev 1.12.3

* `new_branch()` now stashes untracked files

# rdev 1.12.2

* Minor fixes

# rdev 1.12.1

* Updated for R 4.5.0

# rdev 1.12.0

* Updated for `lintr` 3.2.0 (update `use_lintr()`)

# rdev 1.11.6

* Minor updates

# rdev 1.11.5

* rdev now depends on R >= 4.0.0

* `use_analysis_package()` now records dependency on R native pipes (R >= 4.1.0)

# rdev 1.11.4

* Updated "Introduction to rdev" vignette, `vignette("rdev")`

# rdev 1.11.3

* Added support for Visual Studio Code (`languageserver` package) by default

# rdev 1.11.2

* Minor updates

# rdev 1.11.1

* Enabled pkgdown ["light switch"](https://pkgdown.r-lib.org/articles/customise.html#light-switch) by default for packages using `use_rdev_pkgdown()`

# rdev 1.11.0

* Added function `package_downloads()`: A wrapper for `cranlogs::cran_downloads()` that summarizes the number of package downloads from the RStudio CRAN mirror

# rdev 1.10.11

* Minor updates

# rdev 1.10.10

* Bug fixes

# rdev 1.10.9

* Add support for single URL in DESCRIPTION

# rdev 1.10.8

* Added support for private repositories to `use_rdev_package()`

# rdev 1.10.7

* Added support for creating private repositories to `create_github_repo()`

# rdev 1.10.6

* Updated for R 4.4.0

# rdev 1.10.5

* Updated pkgdown templates (update: `use_rdev_pkgdown()` or `use_analysis_package(use_quarto = FALSE)`)

# rdev 1.10.4

* Updated GitHub Actions to work better with renv (update from <https://github.com/jabenninghoff/rdev/tree/main/.github/workflows>)

# rdev 1.10.3

* Updated `R-CMD-check.yaml` GitHub Action (update: `use_rdev_package()`)

# rdev 1.10.2

rdev now supports Quarto Documents (`.qmd`) as analysis notebooks:

* `rmd_metadata()` will extract the YAML front matter and description from Quarto format (`.qmd`) notebooks if `_quarto.yml` is present

* `build_quarto_site()` now supports use of both `Rmd` and/or `qmd` notebooks in `analysis`

* `spell_check_notebooks()` and `update_wordlist_notebooks()` now check both `Rmd` and `qmd` files in the `analysis` directory

* Updated `README.Rmd` template to list all `.Rmd` and `.qmd` notebooks in `analysis`

* Added reference Quarto Document analysis template to `inst/templates/analysis.qmd` (RStudio currently doesn't support [`.qmd` files as document templates](https://github.com/rstudio/rstudio/issues/11316))

* Updated vignettes

# rdev 1.10.1

* Added an `unfreeze` parameter to `stage_release()`, which is passed on to `build_quarto_site()`

# rdev 1.9.11

* Maintenance updates

# rdev 1.9.10

* Updated `build_rdev_site()` and `build_analysis_site()` to use `pkgdown::build_site_github_pages()` instead of `pkgdown::build_site()`, which disables Jekyll rendering and adds a `CNAME` if needed

# rdev 1.9.9

* Updated quarto configuration (update: `use_analysis_package()`)

# rdev 1.9.8

* Added quarto themes (flatly, darkly) (update: `use_analysis_package()`)

* Updated analysis template

# rdev 1.9.7

* Maintenance updates

# rdev 1.9.6

* Add new rdev hex sticker logo from [stickers](https://jabenninghoff.github.io/stickers/) to `man/figures/logo.png` per [roxygen2](https://github.com/r-lib/roxygen2/blob/db4dd9a4de2ce6817c17441d481cf5d03ef220e2/R/object-defaults.R#L43) and to `README.Rmd` per [pkgdown](https://github.com/r-lib/pkgdown/blob/548a9493b72ff93d3ed8392d4ad30b77d8b15fa5/README.Rmd#L15)

* Fixed bugs in `quickstart` functions

# rdev 1.9.5

* Updated TODO

# rdev 1.9.4

* Updated `lintr.yaml` GitHub Action to match `lint_all()` (update: run `use_rdev_package()`)

# rdev 1.9.3

* `lint_all()` and `style_all()` now (properly) exclude `R/RcppExports.R`

# rdev 1.9.2

* Updated manual tests

* Bug fixes

# rdev 1.9.1

* Maintenance updates

# rdev 1.9.0

* Adjusted Quarto margins in `_quarto.yml`

* Added `?quickstart` rdev Quick Start guide to creating a new rdev or analysis package and updated related functions (`create_github_repo()`, `init()`, `setup_analysis()`) and README

* Added function `setup_rdev()`: set up an rdev package for traditional package development

* Added function `open_files()`: open a standard set of files for editing in RStudio

* `setup_analysis()` and `setup_rdev()` now call `open_files()` if running in RStudio

# rdev 1.8.6

* Check function arguments with [checkmate](https://mllg.github.io/checkmate/index.html)

# rdev 1.8.5

* Changed `use_analysis_package()` to store `_freeze` directory in git per Quarto [guide](https://quarto.org/docs/projects/code-execution.html#using-freeze)

# rdev 1.8.4

* Also set GitHub Pages URL in `use_rdev_pkgdown()`

# rdev 1.8.3

* Check if `pandoc` is in `PATH` on launch (update: `use_rprofile()`)

# rdev 1.8.2

* Added rendering fixes to `use_analysis_package()` (update: re-run `use_analysis_package()` and update notebooks from Analysis Notebook template)

* Added function `use_rdev_pkgdown()`: add pkgdown with rdev customizations

# rdev 1.8.1

* Added support for [Visual Studio Code](https://code.visualstudio.com) to `setup-r`

* Quarto bug fixes

# rdev 1.8.0

Added support for [Quarto](https://quarto.org), including:

* New function `build_quarto_site()`: a wrapper for `quarto::quarto_render()` that also updates `README.md` and optionally deletes the Quarto `_freeze` directory to fully re-render the site

* New function `unfreeze()`: delete the Quarto `_freeze` directory to fully re-render the site when `quarto::quarto_render()` is called

* Updated `stage_release()` to run `build_quarto_site()` when using Quarto

* Updated `use_analysis_package()` to use Quarto for publishing by default

* Added "quarto" package type to `local_temppkg()`

Additional changes:

* Updated vignettes

* Added "Introduction to rdev" getting started vignette

* Added a `pkgdown::check_pkgdown()` check to `ci()`

# rdev 1.7.2

* Updated `.lintr` for `lintr` 3.1.1 (update `use_lintr()`)

# rdev 1.7.1

* Updated installation instructions in README and templates to use `remotes` instead of `devtools`

# rdev 1.7.0

* Updated `check_renv()` and `ci()` to use `renv::status(dev = TRUE)`, added in `renv` 1.0.3

# rdev 1.6.9

* Disabled use of Posit package manager in `R-CMD-check.yaml` (update `use_rdev_package()`)

# rdev 1.6.8

* Updated `setup-r` to use `rig` for installing and managing R versions

# rdev 1.6.7

* Maintenance updates

# rdev 1.6.6

* Replaced `check-standard.yaml` with `R-CMD-check.yaml` (update `use_rdev_package()`)

* Updated `.lintr` for `lintr` 3.1.0 (update `use_lintr()`)

* Updated spelling tests (update `use_spelling()`)

# rdev 1.6.5

* Maintenance updates

# rdev 1.6.4

* Added check to install pre-commit git hook if missing (update `use_rprofile()`)

# rdev 1.6.3

* `extra_deps()` no longer reports R as an extra package

# rdev 1.6.2

* `missing_deps()` now excludes base R packages by default

* Added new checks to `ci()`: `missing_deps()`, `desc::desc_normalize()`, `extra_deps()`, `url_check()`, and `html_url_check()`; `ci()` will stop if `missing_deps()` returns one or more rows

* Added `missing-deps.yaml` GitHub Action

# rdev 1.6.1

* `new_branch()` now stashes and restores changes, so that the `Bump version` commit just changes the version number in `DESCRIPTION`

# rdev 1.6.0

* `missing_deps()` and `extra_deps()` now automatically remove the current package and `renv` (in `renv.lock`) from the list of `renv::dependencies()`

# rdev 1.5.9

* Update `build_analysis_site()` and 'Analysis Notebook' R markdown template to use Bootstrap 5 using [`bslib`](https://rstudio.github.io/bslib/)

* Update rdev pkgdown site to use Bootstrap 5

# rdev 1.5.8

* Update options to enable warnings for all partial matches

# rdev 1.5.7

* Add option to warn on partial $ matches

# rdev 1.5.6

* Update `lint_all()` to also check `.Rpres` files

# rdev 1.5.5

* Add option to disable GitHub Pages in `use_rdev_package()` with `options(rdev.github.pages = FALSE)`

* Use proper GitHub Pages URL with trailing "/"

# rdev 1.5.4

* Minor maintenance updates

# rdev 1.5.3

* Maintenance updates

# rdev 1.5.2

* Minor updates to Style Guide

# rdev 1.5.1

* Replace development lintr with CRAN release 3.0.0

* Add Style Guide vignette, describing rdev coding style, [styler](https://styler.r-lib.org) and [lintr](https://lintr.r-lib.org) configuration

# rdev 1.5.0

* Added styler cache options to `.Rprofile` template

* Imported `urlchecker::url_check()`, `urlchecker::url_update()`, and added a new function, `html_url_check()`, to check URLs in `docs/` (replaces `proof-docs` script)

* Replaced scripts in `tools/` for automating package setup with `init()`: run after `create_github_repo()`, and `setup_analysis()`: run after `init()`

* Moved `setup-r` to `inst/bin`

* Increased test coverage

# rdev 1.4.9

* Clean up tests, standardize error messages

# rdev 1.4.8

* Make rdev [data.table aware](https://rdatatable.gitlab.io/data.table/articles/datatable-importing.html#data-table-in-imports-but-nothing-imported)

# rdev 1.4.7

* Added scripts to `tools/` to further automate package setup

# rdev 1.4.6

* Updated lint workflow

# rdev 1.4.5

* Updated for new linters

# rdev 1.4.4

* Enable most linters in `inst/templates/lintr`

# rdev 1.4.3

* Normalize DESCRIPTION file

# rdev 1.4.2

* Remove workaround for resolved upstream issue

# rdev 1.4.1

* Added missing Suggests dependencies in setup functions

# rdev 1.4.0

* Added functions to check dependencies: `missing_deps()` reports `renv::dependencies()` not in DESCRIPTION, `extra_deps()` reports `desc::desc_get_deps()` not found by renv

* Added `renv` check to `ci()`: if `renv::status()` is not synchronized, `ci()` will stop

# rdev 1.3.8

* Fix bugs in tests, `use_analysis_package()`

# rdev 1.3.7

* Fixed bug in lint workflow

# rdev 1.3.6

* Updated `.Rprofile` to load current package at start

* Updated for R version 4.2.0 (2022-04-22) -- "Vigorous Calisthenics"

# rdev 1.3.5

* Updated GitHub workflows

# rdev 1.3.4

* Added new test scripts for new package setup

# rdev 1.3.3

* Fixed `ci()` and `stage_release()` to correctly use `gert::git_status()` to determine if uncommitted changes exist (instead of `gert::git_diff_patch()`)

# rdev 1.3.2

* Fixed `update_wordlist_notebooks()`: removed duplicate words

* Update `use_spelling()` to install test-spelling.R testthat template

# rdev 1.3.1

* Added `update_wordlist_notebooks()`: Update package `inst/WORDLIST` with words from `spell_check_notebooks()`

* Updated `spell_check_notebooks()` to use Language field in `DESCRIPTION` by default

# rdev 1.3.0

Added new options and features to support GitHub Enterprise.

## New Options

Added settings, configured using `options()`

* `rdev.host`: set the default server for `create_github_repo()`, `stage_release()`, `merge_release()` (to support GitHub Enterprise)

* `rdev.codecov`: to disable codecov.io support in `use_codecov()`

* `rdev.dependabot`: to disable support for Dependabot in `create_github_repo()`

* `rdev.license` and `rdev.license.copyright`: specify licenses for `create_github_repo()`, `use_rdev_package()`

* `rdev.github.actions`: to disable support for GitHub Actions in `create_github_repo()`, `use_codecov()`, `use_rdev_package()`

## New Features

* `create_github_repo()` now supports creating repositories within organizations

* Updated `setup-r` script to include pkgdown

# rdev 1.2.6

* Updated `stage_release()` to run `build_rdev_site()` only when `_pkgdown.yml` exists

# rdev 1.2.5

* Updated `ci()` to run spell check tests

# rdev 1.2.4

[//]: # (Workaround for issue https://github.com/r-lib/pkgdown/issues/2122: '#1568' is improperly linking to https://github.com/jabenninghoff/rdev/issues/1568 due to a bug introduced in pkgdown 2.0.4)

* Fix bug in workaround for closed usethis issue #[1568](https://github.com/r-lib/usethis/issues/1568)

# rdev 1.2.3

* Updated `use_codecov()` to use `sort_rbuildignore()`

# rdev 1.2.2

* Implement workaround for closed usethis issue #[1568](https://github.com/r-lib/usethis/issues/1568)

* `use_analysis_package()` now installs [dplyr](https://dplyr.tidyverse.org), used in the `README.Rmd` template

* Documentation updates

# rdev 1.2.1

* `create_github_repo()` now adds branch protection to the default branch

# rdev 1.2.0

* Added `spell_check_notebooks()`: Perform a spell check on notebooks with `spelling::spell_check_files()`.

# rdev 1.1.1

* Fix R-CMD-check for Windows

* `check_renv()` now defaults to running `update` when interactive

# rdev 1.1.0

* Added additional automation to `ci()`:
  * `style_all()` now runs automatically if there are no uncommitted changes
  * `lint_all()` now runs by default and opens RStudio markers pane if any lints are found

# rdev 1.0.1

* Minor updates to analysis README.Rmd template

# rdev 1.0.0

rdev is now stable enough for a 1.0.0 release!

## Major features

rdev provides functions and templates for:

* Release automation: Stage and create GitHub releases, including GitHub pages

* Continuous Integration: Local continuous integration checks and dependency management

* Package Setup: Package setup tasks, typically performed once

## Recent changes

Changes since release 0.8.9:

* Add `use_spelling()` and `use_codecov()`

* Added `local_temppkg()` test helper function

* Minor enhancements to `use_rdev_package()`, `use_analysis_package()`, `build_analysis_site()`, README.Rmd templates

* Updated documentation

* Added manual test script for new package setup, increased test coverage

## TODO

In `ci()`:

* `styler` should be set to automatically run if there are no uncommitted changes

* `lintr` should stop execution and open RStudio markers if any lints are found

* `ci()` should run `styler` and `lintr` by default

# rdev 0.8.9

* Bug fixes for `use_rdev_package()`, `proof-docs`

# rdev 0.8.8

* Added `proof-docs` script to tools, checks docs directory using [htmlproofer](https://github.com/gjtorikian/html-proofer)

# rdev 0.8.7

* Moved `rmd_metadata()` from README-analysis.Rmd to rdev package

* Increased test coverage, reorganized files

# rdev 0.8.6

* Added code coverage using [codecov.io](https://app.codecov.io/gh/jabenninghoff/rdev), new tests for existing code

* Refactored `sort_file()`

# rdev 0.8.5

* Critical bug fix for `to_document()`

# rdev 0.8.4

* Updated `to_document()` to parse yaml front matter and confirm the source file is a valid R Notebook

# rdev 0.8.3

* Updated `use_rdev_package()` to better conform to rdev conventions (README.Rmd, .git/hooks/pre-commit), support committing and error-free `ci()` immediately after it is run

# rdev 0.8.2

* Updated `build_rdev_site()` and `build_analysis_site()` to abort if there are missing topics in the [pkgdown reference section](https://pkgdown.r-lib.org/reference/build_reference.html)

# rdev 0.8.1

* Added `new_branch()`: Create a new feature branch, and (optionally) bump the version in DESCRIPTION

# rdev 0.8.0

Major update adding automation for GitHub releases.

## Release Automation

Added functions to automate workflow for staging and creating releases on GitHub:

* `stage_release()`: Open a GitHub pull request for a new release from NEWS.md

* `get_release()`: Extract release version and release notes from NEWS.md. Called by `stage_release()` and `merge_release()`.

* `merge_release()`: Merge a staged pull request and create a new GitHub release

## Other Changes

* Updated and reorganized pkgdown reference page

# rdev 0.7.3

* Updated `build_analysis_site()` to run `devtools::build_readme()` to regenerate the dynamic list of notebooks (in case new notebooks were added)

* Important update from renv 0.15.0 to [0.15.1](https://rstudio.github.io/renv/news/index.html#renv-0151)

# rdev 0.7.2

* Added info on dynamic notebook list to notebook template and Analysis Package Layout [vignette](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)

# rdev 0.7.1

* Updated `use_analysis_package()`: add dynamic notebook list to `README.Rmd` template

# rdev 0.7.0

Major update adding automation for creating rdev and R analysis packages.

## 'Create Package' Automation

Added functions to automate steps when creating new packages following rdev and optionally analysis package conventions:

* `create_github_repo()`: Create new GitHub repository following rdev conventions in the active user's account and create a basic package

* `use_rdev_package()`: Add rdev templates and settings within the active package. Normally invoked when first setting up a package.

* Install templates using `usethis::use_template()`: `use_rprofile()`, `use_lintr()`, `use_todo()`, `use_package_r()`

* Add functionality to `use_analysis_package()`: also install the analysis package `README.Rmd` template

* Changed both `use_analysis_package()` and `build_analysis_site()` to write `_pkgdown.yml` to the project root and to store in GitHub to make projects [discoverable](https://github.com/search?q=filename%3Apkgdown.yml+path%3A%2F&type=Code) by [pkgdown](https://pkgdown.r-lib.org).

* Updated `setup-r` to install rdev and dependencies in `site_library`

## Other Changes

* Added `build_rdev_site()`, a wrapper for `pkgdown::build_site()` optimized for rdev workflow that updates `README.md` and performs a clean build using pkgdown

* Added 'Analysis Notebook' R markdown template for RStudio (File > New File > Rmarkdown > From Template)

* Migrated ggplot2 themes/styles (`theme_quo()`, `viridis_quo()`) to new package, `jabenninghoff/jbplot`

# rdev 0.6.2

* Add functionality to `use_analysis_package()`: Create `_base.yml` in `pkgdown` from the first `URL` in the package `DESCRIPTION` file.

# rdev 0.6.1

* Critical bugfix for `use_analysis_package()`

# rdev 0.6.0

* Added `use_analysis_package()`: Add the [Analysis Package Layout](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html) to the current package

# rdev 0.5.3

* Add options to `theme_quo()` to disable both `panel.grid.major` and `panel.grid.minor` for `x` and `y`

# rdev 0.5.2

* Disable `lintr` by default in `ci()`, since the normal workflow is `style_all()`, `lint_all()`, then `ci()`

* Documentation fixes

# rdev 0.5.1

* Updated `theme_quo()`: set base theme to `ggplot2::theme_minimal()` and add parameters for disabling grid lines

# rdev 0.5.0

* Added `theme_quo()`: [ggplot2](https://ggplot2.tidyverse.org) theme based on `ggplot2::theme_bw()` and font [Lato](https://www.latofonts.com)

* Added `viridis_quo()`: Sets the default theme to `theme_quo()` and the default color scales to `viridis`

* maintenance

# rdev 0.4.5

* maintenance release, update GitHub Actions

# rdev 0.4.4

* Update `build_analysis_site()` to work with `pkgdown` version 2

# rdev 0.4.3

* maintenance, update TODO with steps for manually setting up an Analysis Package

# rdev 0.4.2

* maintenance release, update README and GitHub Actions

# rdev 0.4.1

* bug fixes, maintenance

# rdev 0.4.0

* Add [`devtools::document()`](https://devtools.r-lib.org/reference/document.html) option to `ci()`, turned on by default

* Add R Analysis Package layout definition, migrated from [rtraining](https://jabenninghoff.github.io/rtraining/)

* Update `ci()` to use `style_all()` and `lint_all()` for consistency

* Add `import` directory to `build_analysis_site()`

* minor updates, improved tests, maintenance

# rdev 0.3.1

* maintenance release, updated for R 4.1.0

# rdev 0.3.0

* `build_analysis_site()`, new function migrated from [rtraining](https://jabenninghoff.github.io/rtraining/): a wrapper for `pkgdown::build_site()` that adds an 'Analysis' menu containing rendered versions of all `.Rmd` files in `analysis/`. It is still considered Experimental, due to lack of test coverage and some features that are not implemented, but should work for projects with limited pkgdown customization. The update also includes a function to convert notebooks to `html_document`, `to_document()`.

# rdev 0.2.2

* minor updates, maintenance

# rdev 0.2.1

* bug fixes

# rdev 0.2.0

* installing rdev will now automatically install preferred development tools as a 'meta-package' (like tidyverse), including: styler, lintr, rcmdcheck, renv, miniUI (for RStudio Addin support), devtools, and rmarkdown

# rdev 0.1.2

* minor updates to package and site (https://jabenninghoff.github.io/rdev/)

# rdev 0.1.1

* maintenance release

## Updates

* `ci()`: updated to match my preferred GitHub workflow: `use_github_action_check_standard()` with `--as-cran` removed

* documentation updates for all functions (style, links)

# rdev 0.1.0

Initial GitHub release

## New Features

* `./tools/setup-r`: shell script to install development packages to site repository on macOS + Homebrew

* `check_renv()`: convenience function that runs `renv` `status()`, `clean()`, and optionally `update()` (on by default).

* `style_all()`: style all `.R` and `.Rmd` files in a project using `styler`

* `lint_all()`: lint all `.R` and `.Rmd` files in a project using `lintr`

* `sort_file()`: sort a file using R `sort()`, similar to the unix `sort` command

* `sort_rbuildignore()`: sort the `.Rbuildignore` file using `sort_file()`, because unsorted is annoying

* `ci()`: run continuous integration tests locally: lint, R CMD check, and style (off by default).
