# workaround for ::: per https://stat.ethz.ch/pipermail/r-devel/2013-August/067210.html
`%:::%` <- function(pkg, fun) {
  get(fun,
    envir = asNamespace(pkg),
    inherits = FALSE
  )
}

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
  checkmate::assert_string(filename)

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
#' If `lang` is `NULL` (the default), get language from `DESCRIPTION` using
#'   [desc::desc_get_field()].
#'
#' @param use_wordlist ignore words in the package [WORDLIST][spelling::get_wordlist] file.
#' @inheritParams fs::dir_ls
#' @inheritParams spelling::spell_check_files
#'
#' @export
spell_check_notebooks <- function(path = "analysis", glob = "*.Rmd", use_wordlist = TRUE,
                                  lang = NULL) {
  checkmate::assert_string(path)
  checkmate::assert_string(glob)
  checkmate::assert_flag(use_wordlist)
  checkmate::assert_string(lang, null.ok = TRUE)

  if (is.null(lang)) {
    if (!fs::file_exists("DESCRIPTION")) {
      stop("DESCRIPTION not found")
    }
    lang <- desc::desc_get_field("Language")
  }
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

#' Update WORDLIST from notebooks
#'
#' Update package `inst/WORDLIST` with words from [spell_check_notebooks()].
#'
#' `update_wordlist_notebooks` is a customized version of [spelling::update_wordlist()] using
#'   code from [`wordlist.R`](https://github.com/ropensci/spelling/blob/master/R/wordlist.R).
#'
#' @inheritParams spelling::update_wordlist
#' @inheritParams spell_check_notebooks
#'
#' @export
update_wordlist_notebooks <- function(pkg = ".", vignettes = TRUE, path = "analysis",
                                      glob = "*.Rmd", confirm = TRUE) {
  # nocov start
  as_package <- "spelling" %:::% "as_package"
  get_wordfile <- "spelling" %:::% "get_wordfile"
  get_wordlist <- spelling::get_wordlist
  spell_check_package <- spelling::spell_check_package

  pkg <- as_package(pkg)
  wordfile <- get_wordfile(pkg$path)
  old_words <- sort(get_wordlist(pkg$path), method = "radix")
  # build new_words from both package and notebooks
  # this is the only non-whitespace change from spelling::update_wordlist
  new_words <- sort(
    unique(c(
      spell_check_package(pkg$path, vignettes = vignettes, use_wordlist = FALSE)$word,
      spell_check_notebooks(path = path, glob = glob, use_wordlist = FALSE)$word
    )),
    method = "radix"
  )
  # end change
  if (isTRUE(all.equal(old_words, new_words))) {
    cat(sprintf("No changes required to %s\n", wordfile))
  } else {
    words_added <- new_words[is.na(match(new_words, old_words))]
    words_removed <- old_words[is.na(match(old_words, new_words))]
    if (length(words_added)) {
      cat(sprintf(
        "The following words will be added to the wordlist:\n%s\n",
        paste(" -", words_added, collapse = "\n")
      ))
    }
    if (length(words_removed)) {
      cat(sprintf(
        "The following words will be removed from the wordlist:\n%s\n",
        paste(" -", words_removed, collapse = "\n")
      ))
    }
    if (isTRUE(confirm) && length(words_added)) {
      cat("Are you sure you want to update the wordlist?")
      if (utils::menu(c("Yes", "No")) != 1) {
        return(invisible())
      }
    }

    # Save as UTF-8
    dir.create(dirname(wordfile), showWarnings = FALSE)
    writeLines(enc2utf8(new_words), wordfile, useBytes = TRUE)
    cat(sprintf(
      "Added %d and removed %d words in %s\n", length(words_added), length(words_removed), wordfile
    ))
  }
  # nocov end
}

deps_check <- function(type, exclude_base = TRUE) {
  checkmate::assert_choice(type, c("missing", "extra"))
  checkmate::assert_flag(exclude_base)

  base_packages <- rownames(utils::installed.packages(priority = "base"))
  renv_deps <- renv::dependencies()
  renv_deps <- renv_deps[!endsWith(renv_deps$Source, "/DESCRIPTION"), ]
  renv_deps <- renv_deps[!renv_deps$Package == pkgload::pkg_name("."), ]
  renv_deps <-
    renv_deps[!(renv_deps$Package == "renv" & endsWith(renv_deps$Source, "/renv.lock")), ]
  desc_deps <- desc::desc_get_deps()
  # desc_get_deps() will return Depends R which is not a valid package
  desc_deps <- desc_deps[!desc_deps$package == "R", ]
  if (type == "missing") {
    writeLines("renv::dependencies() not in DESCRIPTION:")
    if (exclude_base) {
      return(renv_deps[
        renv_deps$Package %in% setdiff(renv_deps$Package, union(desc_deps$package, base_packages)),
      ])
    } else {
      return(renv_deps[renv_deps$Package %in% setdiff(renv_deps$Package, desc_deps$package), ])
    }
  }
  if (type == "extra") {
    writeLines("desc::desc_get_deps() not found by renv:")
    return(desc_deps[desc_deps$package %in% setdiff(desc_deps$package, renv_deps$Package), ])
  }
}

#' Check dependencies
#'
#' Check dependencies in DESCRIPTION.
#'
#' `missing_deps()` reports [renv::dependencies()] not in DESCRIPTION.
#'
#' `extra_deps()` reports [desc::desc_get_deps()] not found by renv.
#'
#' The current package ([`pkgload::pkg_name(".")`][pkgload::pkg_name()]) and `renv` (in `renv.lock`
#'   only) are automatically removed from [renv::dependencies()], along with 'base' R packages if
#'   `exclude_base` is `TRUE` (`r sort(rownames(installed.packages(priority = "base")))`).
#'
#' @param exclude_base exclude packages installed with R from missing dependencies
#'
#' @return data.frame from either [renv::dependencies()] or [desc::desc_get_deps()].
#'
#' @export
#' @rdname deps_check
missing_deps <- function(exclude_base = TRUE) {
  checkmate::assert_flag(exclude_base)

  deps_check("missing", exclude_base)
}

#' @export
#' @rdname deps_check
extra_deps <- function() {
  deps_check("extra")
}
