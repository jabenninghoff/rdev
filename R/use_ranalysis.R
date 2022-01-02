#' Use Analysis Package Layout
#'
# nolint start: line_length_linter
#' Add the [Analysis Package Layout](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)
# nolint end
#'   to the current package.
#'
#' When run, `use_analysis_package()` creates analysis package directories and updates both
#'   .gitignore and .Rbuildignore.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_analysis_package()
#' }
use_analysis_package <- function() {
  # workaround for lintr, R CMD check
  pattern <- create <- gitignore <- rbuildignore <- NULL

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

  analysis_dirs <- subset(analysis_layout, create, pattern)

  analysis_gitignore <- subset(analysis_layout, gitignore, pattern)

  analysis_rbuildignore <- subset(analysis_layout, rbuildignore, pattern)
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
}
