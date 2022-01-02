# declare variables for lintr, R CMD check
utils::globalVariables(c("pattern", "create", "gitignore", "rbuildignore"))

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
#' @importFrom magrittr `%>%`
#' @export
#'
#' @examples
#' \dontrun{
#' use_analysis_package()
#' }
use_analysis_package <- function() {
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

  analysis_dirs <- analysis_layout %>%
    dplyr::filter(create) %>%
    dplyr::pull(pattern)

  analysis_gitignore <- analysis_layout %>%
    dplyr::filter(gitignore) %>%
    dplyr::pull(pattern)

  analysis_rbuildignore <- analysis_layout %>%
    dplyr::filter(rbuildignore) %>%
    dplyr::mutate(pattern = gsub("\\.", "\\\\.", pattern)) %>%
    dplyr::mutate(pattern = gsub("/$", "", pattern)) %>%
    dplyr::mutate(pattern = gsub("\\*", ".\\*", pattern)) %>%
    dplyr::mutate(pattern = paste0("^", pattern, "$")) %>%
    dplyr::pull(pattern)

  fs::dir_create(analysis_dirs)

  usethis::use_git_ignore(c(
    "# analysis package generated files",
    "# see: https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html"
  ))
  usethis::use_git_ignore(analysis_gitignore)

  usethis::use_build_ignore(analysis_rbuildignore, escape = FALSE)
  sort_rbuildignore()
}
