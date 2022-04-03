#' Sort file
#'
#' Sorts a file using R [sort()].
#'
#' @param filename file to be sorted
#'
#' @seealso [sort_rbuildignore()]
#'
#' @examples
#' \dontrun{
#' sort_file(".Rbuildignore")
#' }
#' @export
sort_file <- function(filename) {
  if (!fs::file_exists(filename)) stop("cannot sort file, '", filename, "': no such file")
  writeLines(sort(readLines(filename)), filename)
}

#' Sort .Rbuildignore file
#'
#' Sorts the .Rbuildignore file using [sort_file()].
#'
#' @export
sort_rbuildignore <- function() {
  sort_file(".Rbuildignore")
}

#' Spell Check Notebooks
#'
#' Perform a spell check on notebooks with [spelling::spell_check_files()].
#'
#' @param use_wordlist ignore words in the package [WORDLIST][spelling::get_wordlist] file.
#' @inheritParams fs::dir_ls
#' @inheritParams spelling::spell_check_files
#'
#' @export
spell_check_notebooks <- function(path = "analysis", glob = "*.Rmd", use_wordlist = TRUE,
                                  lang = "en_US") {
  ignore <- character()
  if (use_wordlist && fs::file_exists("inst/WORDLIST")) {
    ignore <- readLines("inst/WORDLIST")
  }
  if (!fs::dir_exists(path)) {
    stop("'", path, "' directory not found")
  }
  files <- fs::dir_ls(path = path, glob = glob)
  spelling::spell_check_files(files, ignore = ignore, lang = lang)
}
