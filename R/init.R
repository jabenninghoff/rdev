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
