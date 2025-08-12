#' Convert R Notebook to `html_document`
#'
#' Copies a file using [fs::file_copy()] and changes the output type in the yaml front matter from
#'   `html_notebook` to `html_document`, removing all other output types.
#'
#' @param file_path Path to the source file
#' @param new_path Path to copy the converted file using [fs::file_copy()]
#' @param overwrite Overwrite file if it exists, passed to [fs::file_copy()]
#'
#' @return Path to new file
#'
#' @seealso [build_analysis_site()]
#' @examples
#' \dontrun{
#' to_document("notebook.Rmd", "document.Rmd")
#' to_document("notebooks_dir/notebook.Rmd", "documents_dir")
#' }
#' @export
to_document <- function(file_path, new_path, overwrite = FALSE) {
  checkmate::assert_string(file_path, min.chars = 1)
  checkmate::assert_string(new_path, min.chars = 1)
  checkmate::assert_flag(overwrite)

  if (!(fs::path_ext(file_path) %in% c("Rmd", "rmd"))) {
    stop("'", file_path, "' is not an R Markdown (*.Rmd) file", call. = FALSE)
  }

  notebook <- readLines(file_path)
  header <- grep("^---$", notebook)
  yaml <- rmarkdown::yaml_front_matter(file_path)
  if (length(header) < 2 || length(yaml) < 1) {
    stop("'", file_path, "' is not a valid R Notebook", call. = FALSE)
  }

  if (is.character(yaml$output)) {
    if (yaml$output != "html_notebook") {
      stop("'", file_path, "' does not contain `output: html_notebook`", call. = FALSE)
    }
    yaml$output <- "html_document"
  } else if (is.list(yaml$output)) {
    if (is.null(yaml$output$html_notebook)) {
      stop("'", file_path, "' does not contain `output: html_notebook`", call. = FALSE)
    }
    yaml$output <- list(html_document = yaml$output$html_notebook)
  } else {
    stop("unexpected output object type '", typeof(yaml$output), "'", call. = FALSE)
  }

  body_start <- header[2] + 1
  body_end <- length(notebook)
  nb_body <- notebook[body_start:body_end]

  notebook <- c(
    "---",
    gsub("\\n$", "", yaml::as.yaml(yaml)),
    "---",
    nb_body
  )

  new_file <- fs::file_copy(file_path, new_path, overwrite = overwrite)
  writeLines(notebook, new_file)
  return(new_file)
}

#' Get analysis notebook metadata
#'
#' Extract the YAML front matter and 'description' line from an
#'  [analysis notebook](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html),
#'   and construct a URL to the notebook's location on GitHub pages.
#'
#' The 'description' line is the the first non-blank line in the body of an R notebook that serves
#'   as a brief description of the work.
#'
#' For quarto packages, `rmd_metadata()` will extract the YAML front matter and description from
#'   Quarto format (`.qmd`) notebooks.
#'
#' @param file_path Path to analysis notebook
#'
#' @return Named list containing analysis notebook title, URL, date, and description
#' @export
rmd_metadata <- function(file_path) { # nolint: cyclocomp_linter.
  checkmate::assert_string(file_path, min.chars = 1)

  quarto <- package_type(strict = TRUE) == "quarto"
  notebook_ext <- fs::path_ext(file_path)

  if (quarto) {
    if (!(notebook_ext %in% c("Rmd", "rmd", "qmd"))) {
      stop("'", file_path, "' is not an R Markdown (*.Rmd) or Quarto (*.qmd) file", call. = FALSE)
    }
    invalid_file_msg <- "is not a valid R Notebook or Quarto file"
  } else {
    if (!(notebook_ext %in% c("Rmd", "rmd"))) {
      stop("'", file_path, "' is not an R Markdown (*.Rmd) file", call. = FALSE)
    }
    invalid_file_msg <- "is not a valid R Notebook"
  }

  notebook <- readLines(file_path)
  header <- grep("^---$", notebook)
  yaml <- rmarkdown::yaml_front_matter(file_path)
  if (length(header) < 2 || length(yaml) < 1) {
    stop("'", file_path, "' ", invalid_file_msg, call. = FALSE)
  }

  if (notebook_ext == "qmd") {
    # qmd files require format: html
    if (is.null(yaml$format)) {
      stop("'", file_path, "' does not contain `format: html`", call. = FALSE)
    } else if (is.character(yaml$format)) {
      if (yaml$format != "html") {
        stop("'", file_path, "' does not contain `format: html`", call. = FALSE)
      }
    } else if (is.list(yaml$format)) {
      if (is.null(yaml$format$html)) {
        stop("'", file_path, "' does not contain `format: html`", call. = FALSE)
      }
    } else {
      stop("unexpected output object type '", typeof(yaml$format), "'", call. = FALSE)
    }
  } else {
    # Rmd files require output: html_notebook
    if (is.null(yaml$output)) { # nolint: unnecessary_nesting_linter. kept for clarity.
      stop("'", file_path, "' does not contain `output: html_notebook`", call. = FALSE)
    } else if (is.character(yaml$output)) {
      if (yaml$output != "html_notebook") {
        stop("'", file_path, "' does not contain `output: html_notebook`", call. = FALSE)
      }
    } else if (is.list(yaml$output)) {
      if (is.null(yaml$output$html_notebook)) {
        stop("'", file_path, "' does not contain `output: html_notebook`", call. = FALSE)
      }
    } else {
      stop("unexpected output object type '", typeof(yaml$output), "'", call. = FALSE)
    }
  }

  body_start <- header[2] + 1
  body_end <- length(notebook)
  desc_line <- grep("[:graph:]", notebook[body_start:body_end])[1] + header[2]

  urls <- desc::desc_get_urls()
  if (length(urls) < 1) {
    stop("no URL found in DESCRIPTION", call. = FALSE)
  } else if (length(urls) == 1) {
    # assume urls[1] is repository URL, no GitHub Pages URL
    base_url <- "."
    ext <- ".Rmd"
  } else {
    # assume urls[1] is GitHub Pages URL, urls[2] is repository URL
    base_url <- urls[1]
    ext <- ".html"
  }
  # set separator to "/" only if first URL doesn't end with "/"
  sep <- ifelse(endsWith(base_url, "/"), "", "/")
  # add analysis to path if using Quarto or no GitHub Pages URL
  sep <- ifelse(quarto || length(urls) == 1, paste0(sep, "analysis/"), sep)
  gh_url <- paste0(
    base_url, sep, fs::path_ext_remove(fs::path_file(file_path)), ext
  )

  list(title = yaml$title, url = gh_url, date = yaml$date, description = notebook[desc_line])
}
