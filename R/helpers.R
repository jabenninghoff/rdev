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
#' @param type type of package to create, one of "usethis" - [usethis::create_package()],
#'   "rdev" - [use_rdev_package()], or "analysis" - [use_analysis_package()].
#' @param env Environment passed to [withr::defer()], defaults to [parent.frame()].
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
local_temppkg <- function(dir = fs::file_temp(), type = "usethis", env = parent.frame()) {
  if (!(type %in% c("usethis", "rdev", "analysis"))) {
    stop("unrecognized package type, '", type, "'")
  }

  # capture current github remote
  git_remote <- gert::git_remote_list()[[1, "url"]]

  # capture the current project - use try() since proj_get() will error within rcmdcheck()
  old_project <- NULL
  try(old_project <- usethis::proj_get(), silent = TRUE)

  # create usethis package
  usethis::create_package(dir, open = FALSE)
  withr::defer(fs::dir_delete(dir), envir = env)

  # nolint start: undesirable_function_linter.
  old_dir <- getwd()
  setwd(dir)
  withr::defer(setwd(old_dir), envir = env)
  # nolint end

  usethis::proj_set(dir)
  if (!is.null(old_project)) {
    if (rlang::is_interactive()) {
      withr::defer(usethis::proj_set(old_project, force = TRUE), envir = env)
    } else {
      withr::defer(usethis::ui_silence(usethis::proj_set(old_project, force = TRUE)), envir = env)
    }
  }

  # create rdev package
  if (type %in% c("rdev", "analysis")) {
    gh_repo <- list(username = "example", repo = "tpkg")
    gh_pages <- list(html_url = "https://example.github.io/tpkg/")
    mockery::stub(use_rdev_package, "get_github_repo", gh_repo)
    mockery::stub(use_rdev_package, "usethis::use_github_pages", gh_pages)
    mockery::stub(use_rdev_package, "gh::gh", NULL)
    mockery::stub(use_rdev_package, "remotes::install_github", NULL)
    mockery::stub(use_rdev_package, "renv::init", NULL)

    # nolint start: line_length_linter.
    # stub all devtools functions as they introduce problems into the R session when run here (restarting session fixes)
    #
    # example 1: devtools::document causes the "?" help lookup operator to break after running local_temppkg
    # > ?suppressMessages
    # Error in `pkg_path()`:
    # ! Could not find a root 'DESCRIPTION' file that starts with '^Package' in '/private/var/folders/4v/k12n8ksn77l4_bcsvc6kfgk00000gn/T/RtmpLH9A2O/fileaa31781656b1'. Are you in your project directory, and does your project have a 'DESCRIPTION' file?
    # Run `rlang::last_error()` to see where the error occurred.
    # Warning message:
    # In normalizePath(path) :
    #   path[1]="/private/var/folders/4v/k12n8ksn77l4_bcsvc6kfgk00000gn/T/RtmpLH9A2O/fileaa31781656b1": No such file or directory
    #
    # example 2: devtools::build_readme breaks covr::codecov() test-coverage.yaml workflow
    # nolint end
    mockery::stub(use_rdev_package, "devtools::document", NULL)
    mockery::stub(use_rdev_package, "devtools::build_readme", NULL)

    usethis::use_git()
    # usethis::use_github_action() now requires a valid local and remote github repository
    gert::git_add(".")
    gert::git_commit_all("Initial commit")
    gert::git_remote_add(git_remote)
    use_rdev_package()
  }

  # create analysis package
  if (type == "analysis") {
    mockery::stub(use_analysis_package, "get_github_repo", gh_repo)
    mockery::stub(use_analysis_package, "renv::install", NULL)
    mockery::stub(use_analysis_package, "usethis::use_package", NULL)
    mockery::stub(use_analysis_package, "renv::snapshot", NULL)

    use_analysis_package()
  }

  dir
}
