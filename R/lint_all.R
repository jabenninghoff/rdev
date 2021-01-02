#' Lint all files
#'
#' Lint all files in a project. Implemented as a wrapper for lintr::lint_dir() that excludes .git,
#'   .github, packrat, and renv by default.
#'
#' @param path the path to the base directory, by default,
#'   it will be searched in the parent directories of the current directory.
#' @param exclusions exclusions for \code{\link[lintr]{exclude}}, relative to the
#'   package path.
#' @return A list of lint objects.
#' @examples
#' \dontrun{
#' lint_all()
#' lint_all("notebooks")
#' lint_all(
#'   path = "./inst",
#'   exclusions = list("inst/example/bad.R")
#' )
#' }
#' @export
lint_all <- function(path = ".", exclusions = list(".git", ".github", "packrat", "renv")) {
  lintr::lint_dir(path = path, exclusions = exclusions)
}
