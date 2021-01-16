#' Build Analysis Site
#'
#' `build_analysis_site()` is a wrapper for [pkgdown::build_site()] that adds an 'Analysis' menu
#'   containing rendered versions of all .Rmd files in `analysis/`.
#'
#' When run, `build_analysis_site()`:
#' 1. Reads base [pkgdown] settings from `pkgdown/_base.yml`
#' 1. Writes base settings to `pkgdown/_pkgdown.yml`
#' 1. Creates a template using [pkgdown::template_navbar()] and inserts an `analysis` menu with
#'   links to html versions of each .Rmd file in `analysis/`
#' 1. Writes the template to `pkgdown/_pkgdown.yml`
#' 1. Runs [pkgdown::clean_site()] and [pkgdown::build_site()]
#' 1. Creates a `_site.yml` file based on the final `_pkgdown.yml` that clones the [pkgdown] navbar
#'   in a temporary build directory
#' 1. Copies the following from `analysis/` into the build directory: `*.Rmd`, `data/`, `assets/`,
#'   `rendered/`
#' 1. Changes `*.Rmd` from `html_notebook` to `html_document` using [to_document()]
#' 1. Builds a site using [rmarkdown::render_site()] using modified `html_document` output settings
#'   to render files with the look and feel of `html_notebook`
#' 1. Moves the rendered files to `docs/`: `*.html`, `data/`, `assets/`, without overwriting
#'
#' `build_analysis_site()` will fail with an error if there are no files in `analysis/*.Rmd`.
#'
#' **Warning:** `build_analysis_site()` is currently considered Experimental. Currently only
#'   `build_analysis_site(pkg = ".")` is supported.
#' @param pkg Path to package.
#' @param ... additional arguments passed to [pkgdown::build_site()]
#'
#' @examples
#' \dontrun{
#' build_analysis_site()
#' }
#' @export
build_analysis_site <- function(pkg = ".", ...) {
  if (pkg != ".") {
    stop('currently only build_analysis_site(pkg = ".") is supported')
  }

  notebooks <- fs::dir_ls("analysis", glob = "*.Rmd")
  if (length(notebooks) == 0) {
    stop("No *.Rmd files in analysis directory")
  }

  # read base settings, write to pkgdown
  pkg_yml <- yaml::read_yaml("pkgdown/_base.yml")
  fs::file_copy("pkgdown/_base.yml", "pkgdown/_pkgdown.yml", overwrite = TRUE)

  # create navbar template and insert analysis menu
  pkg_yml <- append(pkg_yml, pkgdown::template_navbar())
  pkg_yml$navbar$structure$left <- append(pkg_yml$navbar$structure$left, "analysis")

  analysis_menu_item <- function(str_file) {
    title <- rmarkdown::yaml_front_matter(str_file)$title
    link <- as.character(fs::path_ext_set(fs::path_file(str_file), ".html"))
    list(text = title, href = link)
  }
  menu <- unname(purrr::map(notebooks, analysis_menu_item))

  # warning: this assumes that there is only one element on the right, all others on the left
  pkg_yml$navbar$components <- append(
    pkg_yml$navbar$components,
    list(analysis = list(text = "Analysis", menu = menu)),
    length(pkg_yml$navbar$components) - 1
  )

  # write template
  yaml::write_yaml(pkg_yml, "pkgdown/_pkgdown.yml")

  # run clean_site() and build_site()
  pkgdown::clean_site()
  pkgdown::build_site()

  # create _site.yml from _pkgdown.yml in temporary build directory
  # warning: this assumes that there is only one element on the right, all others on the left
  desc <- desc::description$new(pkg)
  title <- paste0(desc$get("Package")[[1]], " notebooks")
  left_nav <- unname(pkg_yml$navbar$components[-length(pkg_yml$navbar$components)])
  right_nav <- unname(pkg_yml$navbar$components[length(pkg_yml$navbar$components)])
  site_yml <- list(
    output_dir = "docs",
    navbar = list(title = title, type = "default", left = left_nav, right = right_nav),
    # simulate html_notebook output
    output = list(html_document = list(
      code_download = TRUE, code_folding = "show", df_print = "paged",
      fig_width = 8, fig_height = 4.5, highlight = "textmate"
    ))
  )
  tmp_dir <- fs::path_temp("build_analysis_site")
  if (fs::dir_exists(tmp_dir)) {
    # default behavior is to clean existing temp directory
    fs::dir_delete(tmp_dir)
  }
  fs::dir_create(tmp_dir)
  yaml::write_yaml(site_yml, paste0(tmp_dir, "/_site.yml"))

  # copy files from analysis/ into build directory, changing html_notebook to html_document
  # warning: assumes assets, data, and rendered are directories
  analysis_dirs <- fs::dir_ls("analysis", regexp = "/(assets|data|rendered)$")
  purrr::walk(analysis_dirs, fs::dir_copy, tmp_dir)
  purrr::walk(notebooks, to_document, tmp_dir)

  # run render_site()
  rmarkdown::render_site(tmp_dir)

  # move rendered files to docs/, do not overwrite, skip data/
  fs::dir_delete(paste0(tmp_dir, "/docs/data"))
  fs::dir_copy(paste0(tmp_dir, "/docs"), pkg)
}

#' Convert R Notebook to `html_document`
#'
#' Copies a file using [fs::file_copy()], and changes the output type in the yaml front matter from
#'   `html_notebook` to `html_document`. If the file is not type `html_notebook`, it is copied
#'   without changing the output type.
#'
#' **Warning:** `to_document()` is currently considered Experimental.
#' @param file_path A string path to the source file
#' @param new_path A string path to copy the converted file using [fs::file_copy()]
#' @param overwrite Overwrite files if they exist, passed to [fs::file_copy()]
#'
#' @examples
#' \dontrun{
#' to_document("notebook.Rmd", "document.Rmd")
#' to_document("notebooks_dir/notebook.Rmd", "documents_dir")
#' }
#' @export
to_document <- function(file_path, new_path, overwrite = FALSE) {
  new_file <- fs::file_copy(file_path, new_path, overwrite = overwrite)
  notebook <- readLines(new_file)

  # warning: assumes the document has valid front matter bounded by ^---$
  header <- grep("^---$", notebook)
  notebook[header[1]:header[2]] <-
    gsub("html_notebook", "html_document", notebook[header[1]:header[2]])
  writeLines(notebook, new_file)
}
