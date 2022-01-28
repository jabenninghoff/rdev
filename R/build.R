#' Build rdev Site
#'
#' `build_rdev_site()` is a wrapper for [pkgdown::build_site()] optimized for rdev workflow that
#'   updates `README.md` and performs a clean build using `pkgdown`.
#'
#' When run, `build_rdev_site()` calls:
#' 1. [devtools::build_readme()]
#' 1. [pkgdown::clean_site()]
#' 1. [pkgdown::build_site()]
#'
#' Both `build_rdev_site()` and [build_analysis_site()] are meant to be used as part of a CI/CD
#'   workflow, and temporarily set the environment variable `CI == "TRUE"` so that the build will
#'   fail when non-internal topics are not included on the reference index page per
#'   [pkgdown::build_reference()].
#'
#' @param pkg Path to package. Currently, only `pkg = "."` is supported.
#' @param ... additional arguments passed to [pkgdown::build_site()] (not implemented)
#'
#' @export
build_rdev_site <- function(pkg = ".", ...) {
  if (pkg != ".") {
    stop('currently only build_analysis_site(pkg = ".") is supported')
  }
  writeLines("devtools::build_readme()")
  devtools::build_readme()
  writeLines("\npkgdown::clean_site()")
  pkgdown::clean_site()
  writeLines("\npkgdown::build_site()")
  withr::with_envvar(c("CI" = "TRUE"), pkgdown::build_site())
}

#' Build Analysis Site
#'
#' `build_analysis_site()` is a wrapper for [pkgdown::build_site()] that adds an 'Analysis' menu
#'   containing rendered versions of all .Rmd files in `analysis/`.
#'
#' When run, `build_analysis_site()`:
#' 1. Reads base [pkgdown] settings from `pkgdown/_base.yml`
#' 1. Writes base settings to `_pkgdown.yml`
#' 1. Creates a template using [pkgdown::template_navbar()] and inserts an `analysis` menu with
#'   links to html versions of each .Rmd file in `analysis/`
#' 1. Writes the template to `_pkgdown.yml`
#' 1. Updates `README.md` by running [devtools::build_readme()] (if `README.Rmd` exists) to update
#'   the list of notebooks
#' 1. Runs [pkgdown::clean_site()] and [pkgdown::build_site()]
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
#' Both [build_rdev_site()] and `build_analysis_site()` are meant to be used as part of a CI/CD
#'   workflow, and temporarily set the environment variable `CI == "TRUE"` so that the build will
#'   fail when non-internal topics are not included on the reference index page per
#'   [pkgdown::build_reference()].
#'
#' @param pkg Path to package. Currently, only `pkg = "."` is supported.
#' @param ... additional arguments passed to [pkgdown::build_site()] (not implemented)
#'
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
  if (!fs::file_exists("pkgdown/_base.yml")) {
    stop("pkgdown/_base.yml does not exist")
  }
  pkg_yml <- yaml::read_yaml("pkgdown/_base.yml")
  fs::file_copy("pkgdown/_base.yml", "_pkgdown.yml", overwrite = TRUE)

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
  yaml::write_yaml(pkg_yml, "_pkgdown.yml")

  # rebuild REAMDE.md
  if (fs::file_exists("README.Rmd")) {
    devtools::build_readme(pkg)
  }

  # run clean_site() and build_site()
  pkgdown::clean_site()
  withr::with_envvar(c("CI" = "TRUE"), pkgdown::build_site())

  # create _site.yml from _pkgdown.yml in temporary build directory
  desc <- desc::description$new(pkg)
  title <- paste0(desc$get("Package")[[1]], " notebooks")

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
  analysis_dirs <- fs::dir_ls("analysis", regexp = "/(assets|data|import|rendered)$")
  dir_check_copy <- function(path, new_path) {
    if (fs::is_dir(path)) {
      fs::dir_copy(path, new_path)
    }
  }
  purrr::walk(analysis_dirs, dir_check_copy, tmp_dir)
  purrr::walk(notebooks, rdev::to_document, tmp_dir)

  # run render_site()
  rmarkdown::render_site(tmp_dir)

  # move rendered files to docs/, do not overwrite, skip data/, import/
  dir_check_delete <- function(path) {
    if (fs::dir_exists(path)) {
      fs::dir_delete(path)
    }
  }
  dir_check_delete(paste0(tmp_dir, "/docs/data"))
  dir_check_delete(paste0(tmp_dir, "/docs/import"))
  fs::dir_copy(paste0(tmp_dir, "/docs"), pkg)
}
