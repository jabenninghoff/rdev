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
check_renv <- function(update = rlang::is_interactive()) {
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
lint_all <- function(path = ".", ...) {
  lintr::lint_dir(path = path, ...)
}

#' Local CI
#'
#' Run continuous integration tests locally.
#'
#' If `styler` is set to `NULL` (the default), [style_all()] will be run only if there are no
#'   uncommitted changes to git. Setting the value to `TRUE` or `FALSE` overrides this check.
#'
#' If [lint_all()] finds any lints, `ci()` will stop and open the RStudio markers pane.
#'
#' @param styler style all files using [style_all()], see details
#' @param lintr lint all files using [lint_all()]
#' @param document run [devtools::document()]
#' @param rcmdcheck run \code{R CMD check} using:
#'   [`rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")`][rcmdcheck::rcmdcheck]
#'
#' @examples
#' \dontrun{
#' ci()
#' ci(styler = TRUE)
#' ci(styler = FALSE, rcmdcheck = FALSE)
#' }
#' @export
ci <- function(styler = NULL, lintr = TRUE, document = TRUE, rcmdcheck = TRUE) {
  if (is.null(styler)) {
    styler <- length(gert::git_diff_patch()) == 0
  }

  if (styler) {
    writeLines("style_all()")
    style_all()
    if (any(lintr, document, rcmdcheck)) writeLines("")
  }

  if (lintr) {
    writeLines("lint_all()")
    lints <- lint_all()
    if (length(lints) > 0) {
      return(lints)
    }
    if (any(document, rcmdcheck)) writeLines("")
  }

  if (document) {
    writeLines("devtools::document()")
    devtools::document()
    if (rcmdcheck) writeLines("")
  }

  if (rcmdcheck) {
    writeLines('Setting env vars: NOT_CRAN="true", CI="true"')
    writeLines('rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")')
    withr::with_envvar(
      new = c("NOT_CRAN" = "true", "CI" = "true"),
      rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")
    )
  }
}
