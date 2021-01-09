#' Sort file
#'
#' Sorts a file using R [sort()].
#'
#' @param name file to be sorted
#' @export sort_file
#' @seealso [sort_rbuildignore()]
#' @examples
#' \dontrun{
#' sort_file(".Rbuildignore")
#' }
# add tests using test fixtures per https://testthat.r-lib.org/articles/test-fixtures.html
sort_file <- function(name) {
  con <- file(name)
  v <- sort(readLines(con))
  writeLines(v, con)
  close(con)
}

#' Sort .Rbuildignore file
#'
#' Sorts the .Rbuildignore file using [sort_file()].
#'
#' @export sort_rbuildignore
#' @examples
#' \dontrun{
#' sort_rbuildignore()
#' }
sort_rbuildignore <- function() {
  sort_file(".Rbuildignore")
}
