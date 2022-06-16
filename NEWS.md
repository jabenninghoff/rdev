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
