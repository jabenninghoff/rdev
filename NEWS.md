# rdev 0.1.2

* minor updates to package and site (https://jabenninghoff.github.io/rdev/)

# rdev 0.1.1

Maintenance release

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
