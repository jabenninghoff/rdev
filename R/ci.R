#' Local CI
#'
#' Run continuous integration tests locally.
#'
#' @param styler style all files:
#'   [`styler::style_dir(".", exclude_dirs = c("renv"))`][styler::style_dir]
#' @param lintr lint all files:
# nolint start
#'   [`lintr::lint_dir(path = ".", exclusions = list(".git", ".github", "packrat", "renv"))`][lintr::lint_dir]
# nolint end
#' @param rcmdcheck run \code{R CMD check} using:
#'   [`rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")`][rcmdcheck::rcmdcheck]
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
    rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")
  }
}
