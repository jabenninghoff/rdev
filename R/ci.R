#' Local CI
#'
#' Run continuous integration tests locally.
#'
#' @param styler style all files: \code{styler::style_dir(".", exclude_dirs = c("renv"))}
#' @param lintr lint all files:
#'   \code{lintr::lint_dir(path = ".", exclusions = list(".git", ".github", "packrat", "renv"))}
#' @param rcmdcheck run \code{R CMD check} using
#'   \code{rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "error")}
#' @export ci
#' @examples
#' \dontrun{
#' ci()
#' ci(styler = TRUE)
#' ci(styler = TRUE, lintr = FALSE, rcmdcheck = FALSE)
#' }
ci <- function(styler = FALSE, lintr = TRUE, rcmdcheck = TRUE) {
  if (styler) {
    styler::style_dir(".", exclude_dirs = c("renv"))
  }

  if (lintr) {
    lintr::lint_dir(path = ".", exclusions = list(".git", ".github", "packrat", "renv"))
  }

  if (rcmdcheck) {
    rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "error")
  }
}
