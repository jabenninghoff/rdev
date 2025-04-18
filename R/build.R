#' Build rdev Site
#'
#' `build_rdev_site()` is a wrapper for [pkgdown::build_site_github_pages()] optimized for rdev
#'   workflow that updates `README.md` and performs a clean GitHub pages build using `pkgdown`.
#'
#' When run, `build_rdev_site()` calls:
#' 1. [devtools::build_readme()]
#' 1. [pkgdown::build_site_github_pages()] with `install = TRUE` and `new_process = TRUE`
#'
#' @section Continuous Integration:
#' Both [build_rdev_site()] and [build_analysis_site()] are meant to be used as part of a CI/CD
#'   workflow, and temporarily set the environment variable `CI == "TRUE"` so that the build will
#'   fail when non-internal topics are not included on the reference index page per
#'   [pkgdown::build_reference()].
#'
#' @param pkg Path to package. Currently, only `pkg = "."` is supported.
#' @param ... additional arguments passed to [pkgdown::build_site_github_pages()] (not implemented)
#'
#' @export
build_rdev_site <- function(pkg = ".", ...) {
  if (pkg != ".") {
    stop('currently only build_rdev_site(pkg = ".") is supported', call. = FALSE)
  }
  writeLines("devtools::build_readme()")
  devtools::build_readme()
  writeLines("\npkgdown::build_site_github_pages(install = TRUE, new_process = TRUE)")
  withr::with_envvar(
    c(CI = "TRUE"),
    pkgdown::build_site_github_pages(install = TRUE, new_process = TRUE)
  )
}

#' Unfreeze Quarto site
#'
#' Delete the Quarto `_freeze` directory to fully re-render the site when [quarto::quarto_render()]
#'   is called.
#'
#' @export
unfreeze <- function() {
  if (!fs::file_exists("_quarto.yml")) {
    stop("_quarto.yml does not exist", call. = FALSE)
  }
  fs::dir_delete("_freeze")
}

#' Build Quarto Site
#'
#' `build_quarto_site()` is a wrapper for [quarto::quarto_render()] that also updates `README.md`
#'   and optionally deletes the Quarto `_freeze` directory to fully re-render the site.
#'
#' When run, `build_quarto_site()` calls:
#' 1. [devtools::build_readme()]
#' 1. [unfreeze()] (if `unfreeze = TRUE`)
#' 1. [quarto::quarto_render()]
#'
#' @section Supported File Types:
#' While [build_quarto_site()] supports both R Markdown (`.Rmd`) and Quarto (`.qmd`) notebooks in
#'   the `analysis` directory interchangeably, [build_analysis_site()] supports `.Rmd` files only.
#'
#' @param unfreeze If `TRUE`, delete the Quarto `_freeze` directory to fully re-render the site.
#' @param ... Arguments passed to [quarto::quarto_render()].
#' @inheritParams quarto::quarto_render
#'
#' @export
build_quarto_site <- function(input = NULL, as_job = FALSE, unfreeze = FALSE, ...) {
  checkmate::assert_flag(unfreeze)
  if (!fs::file_exists("README.Rmd")) {
    stop("README.Rmd does not exist", call. = FALSE)
  }
  if (!fs::dir_exists("analysis")) {
    stop("no analysis directory found", call. = FALSE)
  }
  if (length(fs::dir_ls("analysis", regexp = "[.][Rq]md$")) == 0) {
    stop("no *.Rmd or *.qmd files in analysis directory", call. = FALSE)
  }
  if (!fs::file_exists("_quarto.yml")) {
    stop("_quarto.yml does not exist", call. = FALSE)
  }
  writeLines("devtools::build_readme()")
  devtools::build_readme()
  if (unfreeze) {
    writeLines("\nunfreeze()")
    unfreeze()
  }
  writeLines("\nquarto::quarto_render()")
  quarto::quarto_render(input = input, as_job = as_job, ...)
}

#' Build Analysis Site
#'
#' `build_analysis_site()` is a wrapper for [pkgdown::build_site_github_pages()] that adds an
#'   'Analysis' menu containing rendered versions of all .Rmd files in `analysis/`.
#'
#' When run, `build_analysis_site()`:
#' 1. Reads base [pkgdown] settings from `pkgdown/_base.yml`
#' 1. Writes base settings to `_pkgdown.yml`
#' 1. Creates a template using [pkgdown::template_navbar()] and inserts an `analysis` menu with
#'   links to html versions of each .Rmd file in `analysis/`
#' 1. Writes the template to `_pkgdown.yml`
#' 1. Updates `README.md` by running [devtools::build_readme()] (if `README.Rmd` exists) to update
#'   the list of notebooks
#' 1. Runs [pkgdown::build_site_github_pages()] with `install = TRUE` and `new_process = TRUE`
#' 1. Creates a `_site.yml` file based on the final `_pkgdown.yml` that clones the [pkgdown] navbar
#'   in a temporary build directory
#' 1. Copies the following from `analysis/` into the build directory: `*.Rmd`, `assets/`, `data/`,
#'   `import/`, `rendered/`
#' 1. Changes `*.Rmd` from `html_notebook` to `html_document` using [to_document()]
#' 1. Builds a site using [rmarkdown::render_site()] using modified `html_document` output settings
#'   to render files with the look and feel of `html_notebook`
#' 1. Moves the rendered files to `docs/`: `*.html`, `assets/`, `rendered/`, without overwriting
#'
#' `build_analysis_site()` will fail with an error if there are no files in `analysis/*.Rmd`, or if
#'   `pkgdown/_base.yml` does not exist.
#'
#' @inheritSection build_rdev_site Continuous Integration
#' @inheritSection build_quarto_site Supported File Types
#'
#' @inheritParams build_rdev_site
#'
#' @return rmarkdown _site.yml as yaml, invisibly
#'
#' @export
build_analysis_site <- function(pkg = ".", ...) {
  if (pkg != ".") {
    stop('currently only build_analysis_site(pkg = ".") is supported', call. = FALSE)
  }

  if (!fs::dir_exists("analysis")) {
    stop("no analysis directory found", call. = FALSE)
  }
  notebooks <- fs::dir_ls("analysis", glob = "*.Rmd")
  if (length(notebooks) == 0) {
    stop("no *.Rmd files in analysis directory", call. = FALSE)
  }

  if (!fs::file_exists("pkgdown/_base.yml")) {
    stop("pkgdown/_base.yml does not exist", call. = FALSE)
  }
  writeLines("creating `_pkgdown.yml` from `pkgdown/_base.yml`")
  pkg_yml <- yaml::read_yaml("pkgdown/_base.yml")
  fs::file_copy("pkgdown/_base.yml", "_pkgdown.yml", overwrite = TRUE)

  # create navbar template and insert analysis menu
  pkg_yml <- append(pkg_yml, pkgdown::template_navbar())
  pkg_yml$navbar$structure$left <- append(pkg_yml$navbar$structure$left, "analysis")

  analysis_menu_item <- function(str_file) {
    menu_title <- rmarkdown::yaml_front_matter(str_file)$title
    link <- as.character(fs::path_ext_set(fs::path_file(str_file), ".html"))
    list(text = menu_title, href = link)
  }
  analysis_menu <- unname(purrr::map(notebooks, analysis_menu_item))

  # warning: this assumes that there is only one element on the right, all others on the left
  pkg_yml$navbar$components <- append(
    pkg_yml$navbar$components,
    list(analysis = list(text = "Analysis", menu = analysis_menu)),
    length(pkg_yml$navbar$components) - 1
  )

  yaml::write_yaml(pkg_yml, "_pkgdown.yml")

  if (fs::file_exists("README.Rmd")) {
    writeLines("rebuilding `README.md`")
    devtools::build_readme(pkg)
  }

  writeLines("\npkgdown::build_site_github_pages(install = TRUE, new_process = TRUE)")
  withr::with_envvar(
    c(CI = "TRUE"),
    pkgdown::build_site_github_pages(install = TRUE, new_process = TRUE)
  )

  writeLines("creating `_site.yml` from `_pkgdown.yml` in temporary directory")
  desc <- desc::description$new(pkg)
  menu_title <- paste0(desc$get("Package")[[1]], " notebooks")

  get_component <- function(str_component, list_pkg) {
    list_pkg$navbar$components[[str_component]]
  }

  left_struct <- pkg_yml$navbar$structure$left
  left_nav <- purrr::map(left_struct, get_component, pkg_yml)
  names(left_nav) <- left_struct
  left_nav <- purrr::compact(left_nav)

  right_struct <- pkg_yml$navbar$structure$right
  right_nav <- purrr::map(right_struct, get_component, pkg_yml)
  names(right_nav) <- right_struct
  right_nav <- purrr::compact(right_nav)

  site_yml <- list(
    output_dir = "docs",
    # warning: this assumes at least one element in left_nav and right_nav
    navbar = list(title = menu_title, type = "default", left = left_nav, right = right_nav),
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
  yaml::write_yaml(site_yml, fs::path(tmp_dir, "_site.yml"))

  writeLines("copying files from analysis/ to temporary directory")
  analysis_dirs <- fs::dir_ls("analysis", regexp = "/(assets|data|import|rendered)$")
  dir_check_copy <- function(path, new_path) {
    if (fs::is_dir(path)) {
      fs::dir_copy(path, new_path)
    }
  }
  purrr::walk(analysis_dirs, dir_check_copy, tmp_dir)
  writeLines("converting html_notebook to html_document")
  purrr::walk(notebooks, to_document, tmp_dir)

  writeLines("rmarkdown::render_site()")
  rmarkdown::render_site(tmp_dir, envir = new.env())

  writeLines("moving rendered files to docs/")
  # do not overwrite, skip data/, import/
  dir_check_delete <- function(path) {
    if (fs::dir_exists(path)) {
      fs::dir_delete(path)
    }
  }
  dir_check_delete(fs::path(tmp_dir, "docs/data"))
  dir_check_delete(fs::path(tmp_dir, "docs/import"))
  fs::dir_copy(fs::path(tmp_dir, "docs"), pkg)

  writeLines("build_analysis_site() complete")
  return(invisible(yaml::read_yaml(fs::path(tmp_dir, "_site.yml"))))
}
