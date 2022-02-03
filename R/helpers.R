#' Temporary package
#'
#' Temporarily create a rdev or R analysis package, which is automatically removed afterwards.
#'
#' Used internally for testing rdev automation. Based on the
#'   [usethis case study](https://testthat.r-lib.org/articles/test-fixtures.html#case-study-usethis)
#'   from [`testthat`][testthat::testthat-package].
#'
#' @seealso [withr::withr-package]
#'
#' @param dir Path to package directory, created if necessary, defaults to [fs::file_temp()].
#' @param type type of package to create, either "rdev" - [use_rdev_package()] or "analysis" -
#'   [use_analysis_package()]
#' @param env Environment passed to [withr::defer()], defaults to [parent.frame()]
#'
#' @return Path to temporary package directory.
#'
#' @examples
#' \dontrun{
#' test_that("local_temppkg creates a directory", {
#'   dir <- usethis::ui_silence(local_temppkg())
#'   expect_true(fs::dir_exists(dir))
#' })
#' }
#' @export
local_temppkg <- function(dir = fs::file_temp(), type = "rdev", env = parent.frame()) {
  if (!(type %in% c("rdev", "analysis"))) {
    stop("unrecognized package type, '", type, "'")
  }

  # capture the current project - use try() since proj_get() will error within rcmdcheck()
  old_project <- NULL
  try(old_project <- usethis::proj_get(), silent = TRUE)

  # create base package
  usethis::create_package(dir, open = FALSE)
  withr::defer(fs::dir_delete(dir), envir = env)

  old_dir <- getwd()
  setwd(dir)
  withr::defer(setwd(old_dir), envir = env)

  usethis::proj_set(dir)
  if (!is.null(old_project)) {
    if (rlang::is_interactive()) {
      withr::defer(usethis::proj_set(old_project, force = TRUE), envir = env)
    } else {
      withr::defer(usethis::ui_silence(usethis::proj_set(old_project, force = TRUE)), envir = env)
    }
  }

  # stubs for use_rdev_package()
  gh_repo <- list(username = "example", repo = "tpkg")
  gh_pages <- list(html_url = "https://example.github.io/tpkg/")
  mockery::stub(use_rdev_package, "get_github_repo", gh_repo)
  mockery::stub(use_rdev_package, "usethis::use_github_pages", gh_pages)
  mockery::stub(use_rdev_package, "gh::gh", NULL)
  mockery::stub(use_rdev_package, "renv::install", NULL)
  mockery::stub(use_rdev_package, "devtools::document", NULL)
  mockery::stub(use_rdev_package, "devtools::build_readme", NULL)
  mockery::stub(use_rdev_package, "renv::init", NULL)

  # create rdev package
  usethis::use_git()
  use_rdev_package()

  # create analysis package
  mockery::stub(use_analysis_package, "get_github_repo", gh_repo)
  if (type == "analysis") {
    use_analysis_package()
  }

  dir
}
