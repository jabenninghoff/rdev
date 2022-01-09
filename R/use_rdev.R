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

#' Get GitHub username and repository
#'
#' Retrieve and parse the GitHub remote to identify username and repo name.
#'
#' @return List with members: username, repo, subdir ref, pull, release, some which will be empty.
#'
#' @keywords internal
#' @noRd
get_github_repo <- function() {
  url <- usethis::git_remotes()$origin

  remotes::parse_github_url(url)
}

#' Use rdev package conventions
#'
#' Add rdev templates and settings within the active package. Normally invoked when first setting
#'   up a package.
#'
#' @export
use_rdev_package <- function() {
  # add templates
  use_rprofile()
  use_lintr()
  use_package_r()
  usethis::use_github_action(
    url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/check-standard.yaml"
  )
  usethis::use_github_action(
    url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/lint.yaml"
  )
  use_todo()
  usethis::use_news_md()
  usethis::use_readme_rmd()
  usethis::use_mit_license()

  # activate github pages, add github URLs to DESCRIPTION
  gh_repo <- get_github_repo
  gh_pages <- usethis::use_github_pages(branch = usethis::git_default_branch(), path = "/docs")

  pages_url <- sub("/$", "", gh_pages$html_url)
  gh_url <- paste0("https://github.com/", gh_repo$username, "/", gh_repo$repo)
  gh_issues <- paste0(gh_url, "/issues")

  desc::desc_set_urls(c(pages_url, gh_url))
  desc::desc_set("BugReports", gh_issues)

  # update dependencies, activate renv
  usethis::use_package("devtools", type = "Suggests")
  renv::install("jabenninghoff/rdev")
  usethis::use_dev_package("rdev", type = "Suggests")
  usethis::use_testthat()
  sort_rbuildignore()
  renv::init()
}

#' Use Analysis Package Layout
#'
# nolint start: line_length_linter
#' Add the [Analysis Package Layout](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)
# nolint end
#'   to the current package.
#'
#' When run, `use_analysis_package()` creates analysis package directories, adds exclusions to
#'   .gitignore and .Rbuildignore, creates `_base.yml` in `pkgdown` from the first `URL` in
#'   `DESCRIPTION`, and installs the `README.Rmd` template.
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

  usethis::use_template(
    "README.Rmd",
    package = "rdev",
    data = get_github_repo(),
    ignore = TRUE,
    open = rlang::is_interactive()
  )
}
