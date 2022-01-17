#' Get release details
#'
#' Extract release version and release notes from `NEWS.md`.
#'
#' `get_release()` assumes that `NEWS.md` contains markdown release notes, with each release header
#'   of the format: `"# <package> <version>"` followed by the release notes, and expects the first
#'   line of `NEWS.md` to be a release header.
#'
#' @param pkg Path to package. Currently, only `pkg = "."` is supported.
#' @param filename name of file containing release notes, defaults to `NEWS.md`.
#'
#' @return list containing the version and release notes from the first release contained in
#'   `NEWS.md`
#' @export
get_release <- function(pkg = ".", filename = "NEWS.md") {
  if (pkg != ".") {
    stop('currently only build_analysis_site(pkg = ".") is supported')
  }
  pkg_obj <- devtools::as.package(pkg)
  if (class(pkg_obj) != "package") {
    stop(pkg, " is not a valid package!")
  }

  header_regex <- paste0(
    "^# ", pkg_obj$package, " ", .standard_regexps()$valid_package_version, "$"
  )
  news_md <- readLines(filename)
  releases <- grep(header_regex, news_md)

  if (length(releases) < 1) {
    stop("no valid releases found in ", filename, "!")
  }
  if (releases[1] != 1) {
    stop("unexpected header in ", filename, "!")
  }

  version <- sub(paste0("^# ", pkg_obj$package, " "), "", news_md[releases[1]])

  # assumes only one leading/trailing blank line at most
  notes_start <- releases[1] + 1
  notes_end <- releases[2] - 1
  if (news_md[notes_start] == "") {
    notes_start <- notes_start + 1
  }
  if (news_md[notes_end] == "") {
    notes_end <- notes_end - 1
  }
  if (notes_end < notes_start) {
    notes <- c("")
  } else {
    notes <- news_md[notes_start:notes_end]
  }

  list(version = version, notes = notes)
}
