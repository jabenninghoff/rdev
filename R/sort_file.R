#' Sort file
#'
#' Sorts a file (like unix \code{sort}) using R \code{sort}.
#'
#' @param name file to be sorted
#' @export sort_file
#' @examples
#' \dontrun{
#' sort_file(".Rbuildignore")
#' }
sort_file <- function(name) {
  con <- file(name)
  v <- sort(readLines(con))
  writeLines(v, con)
  close(con)
}

#' Sort .Rbuildignore file
#'
#' Sorts the .Rbuildignore file using R \code{sort}.
#'
#' @export sort_rbuildignore
#' @examples
#' \dontrun{
#' sort_rbuildignore()
#' }
sort_rbuildignore <- function() {
  sort_file(".Rbuildignore")
}
