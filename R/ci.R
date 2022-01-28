#' Check renv
#'
#' Checks [`renv`][renv::renv-package] [`status()`][renv::status()], [`clean()`][renv::clean()], and
#'   optionally [`update()`][renv::update()]
#'
#' @param update run [renv::update()]
#'
#' @examples
#' \dontrun{
#' check_renv()
#' check_renv(update = FALSE)
#' }
#' @export
check_renv <- function(update = TRUE) {
  writeLines("renv::status()")
  renv::status()

  writeLines("\nrenv::clean()")
  renv::clean()

  if (update) {
    writeLines("\nrenv::update()")
    renv::update()
  }
}

#' Style all files
#'
#' Style all files in a project. Implemented as a wrapper for [styler::style_dir()] that styles
#'   `.R`, `.Rprofile`, `.Rmd`, and `.Rnw` files by default.
#'
#' @inheritParams styler::style_dir
#' @inheritDotParams styler::style_dir
#'
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
#' Lint all files in a project. Implemented as a wrapper for [lintr::lint_dir()].
#'
#' @inheritParams lintr::lint_dir
#' @inheritDotParams lintr::lint_dir
#'
#' @return A list of lint objects.
#'
#' @examples
#' \dontrun{
#' lint_all()
#' lint_all("analysis")
#' }
#' @export
# add tests using local_create_package() per https://testthat.r-lib.org/articles/test-fixtures.html
lint_all <- function(path = ".", ...) {
  lintr::lint_dir(path = path, ...)
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
#'
#' @examples
#' \dontrun{
#' ci()
#' ci(styler = TRUE)
#' ci(styler = TRUE, lintr = TRUE, rcmdcheck = FALSE)
#' }
#' @export
# add tests using local_create_package() per https://testthat.r-lib.org/articles/test-fixtures.html
# test styler and lintr, don't test rcmdcheck
ci <- function(styler = FALSE, lintr = FALSE, document = TRUE, rcmdcheck = TRUE) {
  # TODO: styler should be set to automatically run if there are no uncommitted changes
  if (styler) {
    writeLines("style_all()")
    style_all()
    if (any(lintr, document, rcmdcheck)) writeLines("")
  }

  # TODO: lintr should stop execution and open RStudio markers if any lints are found
  if (lintr) {
    writeLines("lint_all()")
    lint_all()
    if (any(document, rcmdcheck)) writeLines("")
  }

  if (document) {
    writeLines("devtools::document()")
    devtools::document()
    if (rcmdcheck) writeLines("")
  }

  if (rcmdcheck) {
    writeLines('rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")')
    rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")
  }
}
