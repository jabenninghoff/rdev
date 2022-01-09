#' Use rdev .Rprofile
#'
#' Install rdev .Rprofile template using [usethis::use_template()]
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_rprofile <- function(open = FALSE) {
  usethis::use_template("Rprofile", save_as = ".Rprofile", package = "rdev", open = open)
}

#' Use rdev .lintr
#'
#' Install rdev .lintr template using [usethis::use_template()]
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_lintr <- function(open = FALSE) {
  usethis::use_template("lintr", save_as = ".lintr", package = "rdev", ignore = TRUE, open = open)
}

#' Use rdev TODO.md
#'
#' Install rdev TODO.md template using [usethis::use_template()]
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_todo <- function(open = rlang::is_interactive()) {
  usethis::use_template("TODO.md", package = "rdev", ignore = TRUE, open = open)
}

#' Use rdev package.R
#'
#' Install rdev package.R template using [usethis::use_template()]
#'
#' package.R is saved as "R/*packageName*.R".
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_package_r <- function(open = FALSE) {
  usethis::use_template(
    "package.R",
    save_as = paste0("R/", utils::packageName(), ".R"),
    package = "rdev",
    open = open
  )
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
