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
