#' Identify Vulnerable Packages
#'
#' Inspect packages using [renv::vulns()] and pretty-print vulnerable packages using
#'   [yaml::as.yaml()]
#'
#' @inheritParams renv::vulns
#' @param quiet disable output and only return the list of vulnerable packages (invisibly).
#'
#' @returns An \R list of vulnerable packages, invisibly.
#'
#' @export
renv_vulns <- function(packages = NULL, quiet = FALSE) {
  checkmate::assert_flag(quiet)

  results <- renv::vulns(packages = packages, repos = "https://packagemanager.posit.co/cran/latest")
  vulns <- Filter(function(x) length(x$vulns) > 0, results)

  if (!quiet) {
    writeLines(paste0(
      length(results), " packages scanned, ", length(vulns), " vulnerable:\n",
      gsub("\\n$", "", yaml::as.yaml(vulns))
    ))
  }

  invisible(vulns)
}

#' Update Posit Package Manager Snapshot Date
#'
#' Set the renv lockfile CRAN repository URL to a Posit Package Manager (PPM) snapshot date
#'   following PPM set up [instructions](https://packagemanager.posit.co/client/#/repos/cran/setup),
#'   for example, `https://packagemanager.posit.co/cran/2026-08-04`.
#'
#' Using a PPM snapshot offers two key advantages:
#'
#' - Faster restores and greater reproducibility using [renv::restore()], since renv will restore
#'   the PPM archived macOS and Windows binaries from that date, which will not be available at
#'   `https://packagemanager.posit.co/cran/latest` if newer versions have been published.
#' - The snapshot date can be used to implement a CRAN [dependency cooldown](https://cooldowns.dev),
#'   which delays installing the latest version of packages unless they are at least N days old,
#'   (typically 7), providing some protection against supply chain attacks.
#'
#' @param cooldown Number of days ago to set the PPM snapshot date.
#' @param prompt Boolean; prompt the user before updating [renv::lockfiles]?
#'
#' @returns Results of [renv::lockfile_write()], invisibly
#'
#' @export
update_ppm_snapshot <- function(cooldown = 7, prompt = rlang::is_interactive()) {
  checkmate::assert_int(cooldown, lower = 0)
  checkmate::assert_flag(prompt)

  if (prompt) {
    set_url <- utils::askYesNo("Update PPM snapshot date in renv lockfile?")
  } else {
    set_url <- TRUE
  }
  if (!is.na(set_url) && set_url) {
    ppm_url <- paste0("https://packagemanager.posit.co/cran/", Sys.Date() - cooldown)
    writeLines(paste0("Using CRAN = ", ppm_url))
    ret <- renv::lockfile_write(renv::lockfile_modify(repos = c(CRAN = ppm_url)))
    renv::load(quiet = TRUE) # reload renv lockfile
    invisible(ret)
  }
}

#' Check renv
#'
#' Runs [`renv`][renv::renv-package] [`status()`][renv::status()], [`clean()`][renv::clean()],
#'   [`vulns()`][renv::vulns()] (using [renv_vulns()]), and optionally
#'   [`update()`][renv::update()]
#'
#' @inheritParams update_ppm_snapshot cooldown
#' @param update run [renv::update()]
#'
#' @examples
#' \dontrun{
#' check_renv()
#' check_renv(update = FALSE)
#' }
#' @export
check_renv <- function(update = rlang::is_interactive(), cooldown = 7) {
  checkmate::assert_flag(update)

  writeLines("renv::status()")
  renv::status()

  writeLines("\nrenv::clean()")
  renv::clean()

  writeLines('\nrenv::vulns(repos = "https://packagemanager.posit.co/cran/latest")')
  renv_vulns()

  if (update) {
    writeLines("")
    update_ppm_snapshot(cooldown = cooldown)
    writeLines("\nrenv::update()")
    renv::update()
  }
}

#' Style all files
#'
#' Style all files in a project. Implemented as a wrapper for [styler::style_dir()] that defaults
#'   to styling `.R`, `.Rprofile`, `.Rmd`, `.Rmarkdown`, `.Rnw`, and `.qmd` files, excluding
#'   files in `packrat`, `renv`, and `R/RcppExports.R`.
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
                      exclude_dirs = c("packrat", "renv"),
                      exclude_files = "R/RcppExports.R",
                      ...) {
  styler::style_dir(
    path = path, filetype = filetype, exclude_dirs = exclude_dirs,
    exclude_files = exclude_files, ...
  )
}

#' Lint all files
#'
#' Lint all files in a project. Implemented as a wrapper for [lintr::lint_dir()].
#'
#' @param pattern regex pattern for files, by default it will take files with any of the extensions
#' .R, .Rmd, .qmd, .Rnw, .Rhtml, .Rpres, .Rrst, .Rtex, .Rtxt, ignoring case.
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
lint_all <- function(pattern = "(?i)[.](r|rmd|qmd|rnw|rhtml|rpres|rrst|rtex|rtxt)$",
                     exclusions = list("renv", "packrat", "R/RcppExports.R"),
                     ...) {
  lintr::lint_dir(pattern = pattern, exclusions = exclusions, ...)
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
#' [pkgdown::check_pkgdown()] will halt `ci()` with an error if `_pkgdown.yml` is invalid.
#'
#' If `styler` is set to `NULL` (the default), [style_all()] will be run only if there are no
#'   uncommitted changes to git. Setting the value to `TRUE` or `FALSE` overrides this check.
#'
#' If [lint_all()] finds any lints, `ci()` will stop and open the RStudio markers pane.
#'
#' Output from `missing`, `extra`, and `urls` is printed as a [tibble][tibble::tibble()] for
#'   improved readability in the console.
#'
#' @param renv check [renv::status()] and report on [renv::vulns()] (as YAML)
#' @param missing run [missing_deps()]
#' @param pkgdown check [pkgdown::check_pkgdown()] if `_pkgdown.yml` exists
#' @param styler style all files using [style_all()], see details
#' @param lintr lint all files using [lint_all()]
#' @param document run [devtools::document()]
#' @param normalize run [desc::desc_normalize()]
#' @param extra run [extra_deps()]
#' @param spelling update spelling [`WORDLIST`][spelling::wordlist]
#' @param urls validate URLs with [url_check()] and [html_url_check()]
#' @param url_check_fail throw an error and stop `ci()` when one or more URLs are flagged by
#'   [url_check()]
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
ci <- function(renv = TRUE, # nolint: cyclocomp_linter.
               missing = TRUE,
               pkgdown = TRUE,
               styler = NULL,
               lintr = TRUE,
               document = TRUE,
               normalize = TRUE,
               extra = TRUE,
               spelling = TRUE,
               urls = TRUE,
               url_check_fail = getOption("rdev.url_check.fail", default = TRUE),
               rcmdcheck = TRUE) {
  checkmate::assert_flag(renv)
  checkmate::assert_flag(missing)
  checkmate::assert_flag(pkgdown)
  checkmate::assert_flag(styler, null.ok = TRUE)
  checkmate::assert_flag(lintr)
  checkmate::assert_flag(document)
  checkmate::assert_flag(normalize)
  checkmate::assert_flag(extra)
  checkmate::assert_flag(spelling)
  checkmate::assert_flag(urls)
  checkmate::assert_flag(url_check_fail)
  checkmate::assert_flag(rcmdcheck)

  if (renv) {
    writeLines("renv::status()")
    status <- renv::status()
    if (!status$synchronized) {
      return(invisible(status))
    }
    writeLines(c("", 'renv::vulns(repos = "https://packagemanager.posit.co/cran/latest")'))
    renv_vulns()
    if (any(
      missing, pkgdown, is.null(styler), styler, lintr, document, normalize, extra, spelling, urls,
      rcmdcheck
    )) {
      writeLines("")
    }
  }

  if (missing) {
    writeLines("missing_deps()")
    md <- missing_deps()
    if (nrow(md) != 0) {
      return(tibble::as_tibble(md))
    }
    if (any(
      pkgdown, is.null(styler), styler, lintr, document, normalize, extra, spelling, urls, rcmdcheck
    )) {
      writeLines("")
    }
  }

  if (pkgdown && fs::file_exists("_pkgdown.yml")) {
    writeLines("pkgdown::check_pkgdown()")
    pkgdown::check_pkgdown()
    if (any(
      is.null(styler), styler, lintr, document, normalize, extra, spelling, urls, rcmdcheck
    )) {
      writeLines("")
    }
  }

  if (is.null(styler)) {
    styler <- nrow(gert::git_status()) == 0
  }

  if (styler) {
    writeLines("style_all()")
    style_all()
    if (any(lintr, document, normalize, extra, spelling, urls, rcmdcheck)) writeLines("")
  }

  if (lintr) {
    writeLines("lint_all()")
    lints <- lint_all()
    if (length(lints) > 0) {
      return(lints)
    }
    if (any(document, normalize, extra, spelling, urls, rcmdcheck)) writeLines("")
  }

  if (document) {
    writeLines("devtools::document()")
    devtools::document()
    if (any(normalize, extra, spelling, urls, rcmdcheck)) writeLines("")
  }

  if (normalize) {
    writeLines("desc::desc_normalize()")
    desc::desc_normalize()
    if (any(extra, spelling, urls, rcmdcheck)) writeLines("")
  }

  if (extra) {
    writeLines("extra_deps()")
    print_tbl(extra_deps())
    if (any(spelling, urls, rcmdcheck)) writeLines("")
  }

  if (spelling) {
    if (package_type() == "rdev") {
      writeLines("spelling::update_wordlist()")
      spelling::update_wordlist()
    } else {
      writeLines("update_wordlist_notebooks()")
      update_wordlist_notebooks()
    }
    if (any(urls, rcmdcheck)) writeLines("")
  }

  if (urls) {
    writeLines("url_check()")
    print_tbl(url_check(progress = FALSE, fail = url_check_fail))
    writeLines("html_url_check()")
    print_tbl(html_url_check(progress = FALSE))
    if (rcmdcheck) writeLines("")
  }

  # NOTE: run rcmdcheck last to get complete output
  if (rcmdcheck) {
    writeLines('Setting env vars: NOT_CRAN="true", CI="true"')
    writeLines('rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")')
    withr::with_envvar(
      new = c(NOT_CRAN = "true", CI = "true"),
      rcmdcheck::rcmdcheck(args = "--no-manual", error_on = "warning")
    )
  }
}
