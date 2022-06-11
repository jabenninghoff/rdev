#' Initialize rdev package
#'
#' Initialize a rdev package within a newly created [create_github_repo()] project by creating a
#'   new git branch, committing all files, and running [use_rdev_package()].
#'
#' `init()` will stop if [rlang::is_interactive()] is `FALSE`.
#'
#' @export
init <- function() {
  if (!rlang::is_interactive()) stop("init() must be run interactively")

  continue <- utils::askYesNo(
    "Initialize rdev package (run after create_github_repo)?",
    default = FALSE
  )
  if (is.na(continue) || !continue) {
    writeLines("Exiting...")
    return(invisible())
  }

  writeLines("Creating new branch...")
  gert::git_branch_create("package-setup")
  gert::git_add(".")
  gert::git_commit("rdev::create_github_repo()")

  writeLines("use_rdev_package()...")
  use_rdev_package()
}

#' Set up analysis package
#'
#' Set up an analysis package within an rdev package newly initialized with [init()], by committing
#'   and running [use_analysis_package()], [use_spelling()], and [ci()].
#'
#' `setup_analysis()` will stop if [rlang::is_interactive()] is `FALSE`.
#'
#' @export
setup_analysis <- function() {
  if (!rlang::is_interactive()) stop("setup_analysis() must be run interactively")

  continue <- utils::askYesNo(
    "Set up analysis package (run after init)?",
    default = FALSE
  )
  if (is.na(continue) || !continue) {
    writeLines("Exiting...")
    return(invisible())
  }

  writeLines("Committing...")
  gert::git_add(".")
  gert::git_commit("rdev::use_rdev_package()")

  writeLines("use_analysis_package()...")
  use_analysis_package()

  writeLines("Committing...")
  gert::git_add(".")
  gert::git_commit("rdev::use_analysis_package()")

  writeLines("use_spelling()...")
  use_spelling()

  writeLines("Committing...")
  fs::file_delete("tests/testthat/test-package.R")
  gert::git_add(".")
  gert::git_commit("rdev::use_spelling()")

  writeLines("ci()...")
  ci()
}
