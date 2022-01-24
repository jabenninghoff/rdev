#' Sort file
#'
#' Sorts a file using R [sort()].
#'
#' @param name file to be sorted
#'
#' @seealso [sort_rbuildignore()]
#'
#' @examples
#' \dontrun{
#' sort_file(".Rbuildignore")
#' }
#' @export
sort_file <- function(name) {
  writeLines(sort(readLines(name)), name)
}

#' Sort .Rbuildignore file
#'
#' Sorts the .Rbuildignore file using [sort_file()].
#'
#' @export
sort_rbuildignore <- function() {
  sort_file(".Rbuildignore")
}

#' Write and evaluate an expression
#'
#' `write_eval(string)` is a simple wrapper that prints `string` to the console using
#'   [`writeLines()`][base::writeLines], then executes the expression using [`parse()`][base::parse]
#'   and [`eval()`][base::eval].
#'
#' @param string An expression to be printed to the console and evaluated
#'
#' @return The return value from the evaluated expression
#'
#' @examples
#' write_eval("pi")
#'
#' write_eval("exp(1)")
#' @export
write_eval <- function(string) {
  if (!is.character(string)) stop("not a character vector")
  if (string == "") stop("nothing to evaluate")
  writeLines(string)
  eval(parse(text = string))
}
