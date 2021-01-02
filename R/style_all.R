#' Style all files
#'
#' Style all files in a project. Implemented as a wrapper for styler::style_dir() that styles .R and
#'   .Rmd filetypes, and excludes .git, .github, packrat, and renv by default.
#'
#' @param path Path to a directory with files to transform.
#' @param exclude_dirs Character vector with directories to exclude
#'   (recursively).
#' @param filetype Vector of file extensions indicating which file types should
#'   be styled. Case is ignored, and the `.` is optional, e.g.
#'   `c(".R", ".Rmd")`, or `c("r", "rmd")`. Supported values (after
#'   standardization) are: "r", "rprofile", "rmd", "rnw".
#' @examples
#' \dontrun{
#' style_all()
#' style_all("notebooks")
#' style_all(
#'   path = "./inst",
#'   filetype = "r",
#'   exclude_dirs = c("inst/example/bad.R")
#' )
#' }
#' @export
style_all <- function(path = ".", filetype = c("R", "Rprofile", "Rmd"),
                      exclude_dirs = c(".git", ".github", "packrat", "renv")) {
  styler::style_dir(path = path, filetype = filetype, exclude_dirs = exclude_dirs)
}
