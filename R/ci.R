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
#'   `.R`, `.Rprofile`, `.Rmd`, `.Rmarkdown`, `.Rnw`, and `.Qmd` files by default.
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
style_all <- function(path = ".",
                      filetype = c("R", "Rprofile", "Rmd", "Rmarkdown", "Rnw", "Qmd"),
                      ...) {
  styler::style_dir(path = path, filetype = filetype, ...)
}

#' Lint all files
#'
#' Lint all files in a project. Implemented as a wrapper for [lintr::lint_dir()].
#'
#' @param pattern regex pattern for files, by default it will take files with any of the extensions
#' .R, .Rmd, .Rnw, .Rpres, .Rhtml, .Rrst, .Rtex, .Rtxt allowing for lowercase r (.r, ...)
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
lint_all <- function(path = ".", pattern = "\\.[Rr](?:|html|md|nw|pres|rst|tex|txt)$", ...) {
  lintr::lint_dir(path = path, pattern = pattern, ...)
}

print_tbl <- function(df) {
  if (nrow(df) != 0) print(tibble::as_tibble(df))
}

#' Local CI
#'
#' Run continuous integration tests locally.
#'
#' If [renv::status()] is not synchronized, `ci()` will stop.
#'
#' If [missing_deps()] returns any missing dependencies, `ci()` will stop.
#'
#' If `styler` is set to `NULL` (the default), [style_all()] will be run only if there are no
#'   uncommitted changes to git. Setting the value to `TRUE` or `FALSE` overrides this check.
#'
#' If [lint_all()] finds any lints, `ci()` will stop and open the RStudio markers pane.
#'
#' Output from `missing`, `extra`, and `urls` is printed as a [tibble][tibble::tibble()] for
#'   improved readability in the console.
#'
#' @param renv check [renv::status()]
#' @param missing run [missing_deps()]
#' @param styler style all files using [style_all()], see details
#' @param lintr lint all files using [lint_all()]
#' @param document run [devtools::document()]
#' @param normalize run [desc::desc_normalize()]
#' @param extra run [extra_deps()]
#' @param urls validate URLs with [url_check()] and [html_url_check()]
#' @param rcmdcheck run `R CMD check` using:
#'   [`rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")`][rcmdcheck::rcmdcheck]
#'
#' @examples
#' \dontrun{
#' ci()
#' ci(styler = TRUE)
#' ci(styler = FALSE, rcmdcheck = FALSE)
#' }
#' @export
ci <- function(renv = TRUE, missing = TRUE, styler = NULL, lintr = TRUE, # nolint: cyclocomp_linter.
               document = TRUE, normalize = TRUE, extra = TRUE, urls = TRUE, rcmdcheck = TRUE) {
  if (renv) {
    writeLines("renv::status()")
    status <- renv::status()
    if (!status$synchronized) {
      return(invisible(status))
    }
    if (any(missing, is.null(styler), styler, lintr, document, normalize, extra, urls, rcmdcheck)) {
      writeLines("")
    }
  }

  if (missing) {
    writeLines("missing_deps()")
    md <- missing_deps()
    if (nrow(md) != 0) {
      return(tibble::as_tibble(md))
    }
    if (any(is.null(styler), styler, lintr, document, normalize, extra, urls, rcmdcheck)) {
      writeLines("")
    }
  }

  if (is.null(styler)) {
    styler <- nrow(gert::git_status()) == 0
  }

  if (styler) {
    writeLines("style_all()")
    style_all()
    if (any(lintr, document, normalize, extra, urls, rcmdcheck)) writeLines("")
  }

  if (lintr) {
    writeLines("lint_all()")
    lints <- lint_all()
    if (length(lints) > 0) {
      return(lints)
    }
    if (any(document, normalize, extra, urls, rcmdcheck)) writeLines("")
  }

  if (document) {
    writeLines("devtools::document()")
    devtools::document()
    if (any(normalize, extra, urls, rcmdcheck)) writeLines("")
  }

  if (normalize) {
    writeLines("desc::desc_normalize()")
    desc::desc_normalize()
    if (any(extra, urls, rcmdcheck)) writeLines("")
  }

  if (extra) {
    writeLines("extra_deps()")
    print_tbl(extra_deps())
    if (any(urls, rcmdcheck)) writeLines("")
  }

  if (urls) {
    writeLines("url_check()")
    print_tbl(url_check(progress = FALSE))
    writeLines("html_url_check()")
    print_tbl(html_url_check(progress = FALSE))
    if (rcmdcheck) writeLines("")
  }

  # NOTE: run rcmdcheck last to get complete output
  if (rcmdcheck) {
    writeLines('Setting env vars: NOT_CRAN="true", CI="true"')
    writeLines('rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")')
    withr::with_envvar(
      new = c("NOT_CRAN" = "true", "CI" = "true"),
      rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")
    )
  }
}
