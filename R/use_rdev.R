#' Use rdev .Rprofile
#'
#' Update .Rprofile to attach devtools and rdev when in an interactive session.
#'
#' **Warning:** `use_rdev_rprofile()` won't work properly if some (but not all) of the added
#'   lines are already present in .Rprofile
#'
#' @param directory Directory relative to active project to update .Rprofile
#'
#' @export
use_rdev_rprofile <- function(directory = ".") {
  rprofile <- c(
    "",
    "# attach devtools and set options per https://r-pkgs.org/setup.html",
    "if (interactive()) {",
    "  suppressMessages(require(devtools))",
    "  suppressMessages(require(rdev))",
    "}"
  )

  usethis::write_union(usethis::proj_path(directory, ".Rprofile"), rprofile)
}

#' Use rdev .lintr
#'
#' Add .lintr file with 'linters: with_defaults(line_length_linter(100))' to current project
#'
#' @param directory Directory relative to active project to update .lintr
#'
#' @export
use_lintr <- function(directory = ".") {
  lintr <- c("linters: with_defaults(line_length_linter(100))")

  usethis::write_union(usethis::proj_path(directory, ".lintr"), lintr)
  usethis::use_build_ignore(".lintr")
}

#' Use Analysis Package Layout
#'
# nolint start: line_length_linter
#' Add the [Analysis Package Layout](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)
# nolint end
#'   to the current package.
#'
#' When run, `use_analysis_package()` creates analysis package directories, adds exclusions to
#'   .gitignore and .Rbuildignore, and creates `_base.yml` in `pkgdown` from the first `URL` in
#'   `DESCRIPTION`.
#'
#' @export
use_analysis_package <- function() {
  # workaround for lintr, R CMD check
  create <- gitignore <- rbuildignore <- NULL

  analysis_layout <- tibble::tribble(
    ~pattern, ~create, ~gitignore, ~rbuildignore,
    "analysis", TRUE, FALSE, FALSE,
    "analysis/*.docx", FALSE, TRUE, TRUE,
    "analysis/*.html", FALSE, TRUE, TRUE,
    "analysis/*.md", FALSE, TRUE, TRUE,
    "analysis/*.pdf", FALSE, TRUE, TRUE,
    "analysis/*-figure/", FALSE, TRUE, TRUE,
    "analysis/assets", TRUE, FALSE, FALSE,
    "analysis/data", TRUE, FALSE, FALSE,
    "analysis/import", TRUE, TRUE, TRUE,
    "analysis/rendered", TRUE, TRUE, TRUE,
    "docs", TRUE, FALSE, TRUE,
    "pkgdown", TRUE, FALSE, TRUE,
    "pkgdown/_pkgdown.yml", FALSE, TRUE, FALSE,
  )

  analysis_dirs <- subset(analysis_layout, create)$pattern

  analysis_gitignore <- subset(analysis_layout, gitignore)$pattern

  analysis_rbuildignore <- subset(analysis_layout, rbuildignore)$pattern
  analysis_rbuildignore <- gsub("\\.", "\\\\.", analysis_rbuildignore)
  analysis_rbuildignore <- gsub("/$", "", analysis_rbuildignore)
  analysis_rbuildignore <- gsub("\\*", ".\\*", analysis_rbuildignore)
  analysis_rbuildignore <- paste0("^", analysis_rbuildignore, "$")

  fs::dir_create(analysis_dirs)

  usethis::use_git_ignore(c(
    "# analysis package generated files",
    "# see: https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html"
  ))
  usethis::use_git_ignore(analysis_gitignore)

  usethis::use_build_ignore(analysis_rbuildignore, escape = FALSE)
  rdev::sort_rbuildignore()

  urls <- desc::desc_get_urls()
  if (length(urls) >= 1 & !fs::file_exists("pkgdown/_base.yml")) {
    yaml::write_yaml(list(url = urls[1]), "pkgdown/_base.yml")
  }
}
