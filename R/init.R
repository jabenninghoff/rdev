#' rdev Quick Start
#'
#' Quick start guide to creating a new rdev or analysis package.
#'
#' To quickly create and configure a new rdev or analysis package, use the following commands:
#'
#' 1. With no project open, run [create_github_repo()] to initialize the GitHub R repository
#' 1. Without committing to git, run [init()] in the newly created project
#' 1. Manually update the Title and Description fields in the `DESCRIPTION` file without committing
#' 1. Run [setup_analysis()] or [setup_rdev()] to configure the package as an analysis package or
#'    rdev package respectively.
#' 1. Manually update `.gitignore`: remove the `docs/` exclusion and add line breaks
#'
#' After this, the package configuration is complete and ready for development.
#' @name quickstart
NULL

#' Initialize rdev package
#'
#' Initialize a rdev package within a newly created [create_github_repo()] project by creating a
#'   new git branch, committing all changes, and running [use_rdev_package()].
#'
#' `init()` will stop if [rlang::is_interactive()] is `FALSE`.
#'
#' After running `init()`, update the Title and Description fields in the `DESCRIPTION` file without
#'   committing and run either [setup_analysis()] or [setup_rdev()] per the [quickstart].
#'
#' @seealso [quickstart]
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
#' Set up an analysis package within an rdev package newly initialized with [init()], after updating
#'   Title and Description in `DESCRIPTION`, by committing changes and running
#'   [use_analysis_package()], [use_spelling()], and [ci()].
#'
#' `setup_analysis()` will stop if [rlang::is_interactive()] is `FALSE`, and will run [open_files()]
#'   if running in RStudio.
#'
#' @inheritParams use_analysis_package
#' @seealso [quickstart]
#'
#' @export
setup_analysis <- function(use_quarto = TRUE) {
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

  # update documentation since quickstart directs user to manually update Title and Description
  devtools::document()

  if (use_quarto) {
    use_msg <- "use_analysis_package()"
  } else {
    use_msg <- "use_analysis_package(use_quarto = FALSE)"
  }

  writeLines(paste0(use_msg, "..."))
  use_analysis_package(use_quarto = use_quarto)

  writeLines("Committing...")
  gert::git_add(".")
  gert::git_commit(paste0("rdev::", use_msg))

  writeLines("use_spelling()...")
  use_spelling()

  writeLines("Committing...")
  fs::file_delete("tests/testthat/test-package.R")
  gert::git_add(".")
  gert::git_commit("rdev::use_spelling()")

  if (rstudioapi::isAvailable()) open_files()

  writeLines("ci()...")
  ci()
}

#' Set up rdev package
#'
#' Set up an rdev package for traditional package development after running [init()] and updating
#'   Title and Description in `DESCRIPTION`, by committing changes and running [use_rdev_pkgdown()],
#'   [use_spelling()], [use_codecov()], and [ci()].
#'
#' `setup_rdev()` will stop if [rlang::is_interactive()] is `FALSE`, and will run [open_files()]
#'   if running in RStudio.
#'
#' @seealso [quickstart]
#'
#' @export
setup_rdev <- function() {
  if (!rlang::is_interactive()) stop("setup_rdev() must be run interactively")

  continue <- utils::askYesNo(
    "Set up rdev package (run after init)?",
    default = FALSE
  )
  if (is.na(continue) || !continue) {
    writeLines("Exiting...")
    return(invisible())
  }

  writeLines("Committing...")
  gert::git_add(".")
  gert::git_commit("rdev::use_rdev_package()")

  # update documentation since quickstart directs user to manually update Title and Description
  devtools::document()

  writeLines("use_rdev_pkgdown()...")
  use_rdev_pkgdown()

  writeLines("Committing...")
  gert::git_add(".")
  gert::git_commit("rdev::use_rdev_pkgdown()")

  writeLines("use_spelling()...")
  use_spelling()

  writeLines("Committing...")
  fs::file_delete("tests/testthat/test-package.R")
  gert::git_add(".")
  gert::git_commit("rdev::use_spelling()")

  writeLines("use_codecov()...")
  use_codecov()

  writeLines("Committing...")
  gert::git_add(".")
  gert::git_commit("rdev::use_codecov()")

  if (rstudioapi::isAvailable()) open_files()

  writeLines("ci()...")
  ci()
}
