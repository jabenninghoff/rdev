#' Style all files
#'
#' Style all files in a project. Implemented as a wrapper for [styler::style_dir()] that styles
#'   `.R`, `.Rprofile`, `.Rmd`, and `.Rnw` files by default.
#'
#' @inheritParams styler::style_dir
#' @inheritDotParams styler::style_dir
#' @examples
#' \dontrun{
#' style_all()
#' style_all("analysis", filetype = "Rmd")
#' }
#' @export
# add tests using local_create_package() per https://testthat.r-lib.org/articles/test-fixtures.html
style_all <- function(path = ".", filetype = c("R", "Rprofile", "Rmd", "Rnw"), ...) {
  styler::style_dir(path = path, filetype = filetype, ...)
}

#' Lint all files
#'
#' Lint all files in a project. Implemented as a wrapper for [lintr::lint_dir()] that excludes
#' `.git`, `.github`, `packrat`, and `renv` by default.
#'
#' @param path the path to the base directory, by default,
#'   it will be searched in the parent directories of the current directory.
#' @param exclusions exclusions for [lintr::exclude()], relative to the
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
# add tests using local_create_package() per https://testthat.r-lib.org/articles/test-fixtures.html
lint_all <- function(path = ".", exclusions = list(".git", ".github", "packrat", "renv")) {
  lintr::lint_dir(path = path, exclusions = exclusions)
}

#' Local CI
#'
#' Run continuous integration tests locally.
#'
#' @param styler style all files using [style_all()]
#' @param lintr lint all files using [lint_all()]
#' @param document run [devtools::document()]
#' @param rcmdcheck run \code{R CMD check} using:
#'   [`rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")`][rcmdcheck::rcmdcheck]
#' @export ci
#' @examples
#' \dontrun{
#' ci()
#' ci(styler = TRUE)
#' ci(styler = TRUE, lintr = FALSE, rcmdcheck = FALSE)
#' }
# add tests using local_create_package() per https://testthat.r-lib.org/articles/test-fixtures.html
# test styler and lintr, don't test rcmdcheck
ci <- function(styler = FALSE, lintr = TRUE, document = TRUE, rcmdcheck = TRUE) {
  if (styler) {
    style_all()
  }

  if (lintr) {
    lint_all()
  }

  if (document) {
    devtools::document()
  }

  if (rcmdcheck) {
    rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")
  }
}
