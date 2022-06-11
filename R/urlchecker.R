#' Functions re-exported from the urlchecker package
#'
#' These functions are re-exported from the urlchecker package.
#'
#' Follow the links below to see the urlchecker documentation.
#'
#' [urlchecker::url_check()]
#'
#' [urlchecker::url_update()]
#'
#' @name urlchecker-reexports
#' @inheritParams urlchecker::url_check
#' @export
url_check <- urlchecker::url_check

#' @rdname urlchecker-reexports
#' @inheritParams urlchecker::url_update
#' @export
url_update <- urlchecker::url_update

#' Check URLs in HTML files
#'
#' Runs [urlchecker::url_check()] with a database created using the `url_db_from_HTML_files`
#'   function in the tools package.
#'
#' @inheritParams urlchecker::url_check
#' @param path Path to the directory of HTML files
#'
#' @return A `url_checker_db` object (invisibly). This is a `check_url_db` object with an added
#'   class with a custom print method.
#' @export
html_url_check <- function(path = "docs", parallel = TRUE, pool = curl::new_pool(),
                           progress = TRUE) {
  url_db_from_HTML_files <- "tools" %:::% "url_db_from_HTML_files" # nolint: object_name_linter

  urlchecker::url_check(
    path = path, db = url_db_from_HTML_files(normalizePath(path), recursive = TRUE),
    parallel = parallel, pool = pool, progress = progress
  )
}
