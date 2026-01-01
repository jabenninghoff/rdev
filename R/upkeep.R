# workaround for ::: per https://stat.ethz.ch/pipermail/r-devel/2013-August/067210.html
`%:::%` <- function(pkg, fun) {
  get(fun,
    envir = asNamespace(pkg),
    inherits = FALSE
  )
}

#' Create an upkeep checklist in a GitHub issue
#'
#' Opens an issue in the package repository with a checklist of tasks for regular maintenance and
#' adherence to rdev package standards. Some tasks are meant to be done only once, and others should
#' be reviewed periodically. Adapted from [usethis::use_upkeep_issue()] and
#' [usethis::use_tidy_upkeep_issue()].
#'
#' @param last_upkeep Year of last upkeep. By default, the `Config/rdev/last-upkeep` field in
#'   `DESCRIPTION` is consulted for this, if it's defined. If there's no information on the last
#'   upkeep, the issue will contain the full checklist.
#'
#' @export
use_upkeep_issue <- function(last_upkeep = last_upkeep_year()) {
  checkmate::assert_integerish(last_upkeep, len = 1, null.ok = TRUE)

  gh_repo <- get_github_repo()
  checklist <- upkeep_checklist(last_upkeep = last_upkeep)
  title_year <- format(Sys.Date(), "%Y")
  project_name <- desc::desc_get_field("Package")

  issue <- gh::gh(
    "POST /repos/{owner}/{repo}/issues",
    owner = gh_repo$username,
    repo = gh_repo$repo,
    title = glue::glue("Upkeep for {project_name} ({title_year})"),
    body = paste0(checklist, "\n", collapse = "")
  )
  Sys.sleep(1)
  view_url(issue$html_url)

  record_upkeep_date(Sys.Date())
}

#' Create upkeep checklist
#'
#' Build an upkeep checklist following the format of [usethis::use_tidy_upkeep_issue()].
#'
#' @param last_upkeep Year when upkeep was last performed.
#'
#' @return Upkeep checklist for current year as a GitHub markdown array.
#'
#' @export
upkeep_checklist <- function(last_upkeep = last_upkeep_year()) { # nolint: cyclocomp_linter.
  lic <- get_license()
  ptype <- package_type()
  uses_ggplot2 <- desc::desc_has_dep("ggplot2")

  bullets <- c(
    "### New branch",
    "",
    todo('`rdev::new_branch("upkeep-{format(Sys.Date(), "%Y-%m")}")`'),
    ""
  )

  if (last_upkeep <= 2021) {
    bullets <- c(
      bullets,
      "### Prehistory",
      "",
      todo("`usethis::use_roxygen_md()`"),
      todo("`usethis::use_github_links()`"),
      todo("`usethis::use_testthat(3)`"),
      ""
    )
  }
  if (last_upkeep <= 2022) {
    bullets <- c(
      bullets,
      "### 2022",
      "",
      todo("`rdev::use_spelling()`"),
      todo("Add `rdev.license.copyright` to `.Rprofile`", lic == "mit"),
      ""
    )
  }
  if (last_upkeep <= 2023) {
    bullets <- c(
      bullets,
      "### 2023",
      "",
      todo("`rdev::use_rprofile()`"),
      todo("`setup-r`"),
      ""
    )
  }
  if (last_upkeep <= 2024 && ptype == "analysis") {
    bullets <- c(
      bullets,
      "### 2024",
      "",
      todo("`rdev::use_analysis_package(use_quarto = FALSE)`", ptype == "analysis"),
      ""
    )
  }
  if (last_upkeep <= 2025) {
    bullets <- c(
      bullets,
      "### 2025",
      "",
      todo("`rdev::use_lintr()`"),
      todo("`rdev::use_gitattributes()`"),
      todo("`rdev::use_analysis_package(use_quarto = TRUE)`", ptype == "quarto"),
      todo("`rdev::use_codecov()`", length(fs::dir_ls("R")) > 1),
      todo("`rdev::use_rdev_pkgdown()`", ptype == "rdev"),
      todo(
        "Update for ggplot2 [version 4](https://tidyverse.org/blog/2025/09/ggplot2-4-0-0/)",
        uses_ggplot2
      ),
      todo("Switch to chunk option YAML [syntax](https://yihui.org/knitr/options/)"),
      "",
      "Update to YAML chunk syntax using:",
      "",
      "```",
      paste0(
        'lapply(list.files(pattern = "\\\\.Rmd$", recursive = TRUE), knitr::convert_chunk_header, ',
        'output = identity, type = "yaml", width = 100)'
      ),
      "```",
      ""
    )
  }

  minimum_r_version <- pkg_minimum_r_version()
  if (is.na(minimum_r_version) || "3.6.3" > minimum_r_version) minimum_r_version <- "3.6.3"
  if (package_type() %in% c("analysis", "quarto") && "4.1.0" > minimum_r_version) {
    minimum_r_version <- "4.1.0"
  }
  deps <- desc::desc_get_deps()
  r_version <- deps[deps$package == "R", "version"]
  r_version <- substr(r_version, 4, nchar(r_version))
  bullets <- c(
    bullets,
    "### Recurring tasks",
    "",
    todo(
      "Consider changing default branch from `master` to `main`",
      usethis::git_default_branch() == "master"
    ),
    todo(
      '`usethis::use_package("R", "Depends", "{minimum_r_version}")`',
      length(r_version) == 0 || minimum_r_version > r_version
    ),
    todo(
      "Check for GitHub Action [updates](https://github.com/r-lib/actions/tree/v2/examples) \\
      since {last_upkeep_date()}",
      desc::desc_get_field("Package") == "rdev"
    ),
    todo("`rdev::use_rdev_package(quiet = FALSE)` (do this **first**)"),
    todo("`build_quarto_site(unfreeze = TRUE)`", ptype == "quarto"),
    todo(
      '`usethis::use_mit_license(copyright_holder = getOption("rdev.license.copyright"))`',
      lic == "mit"
    ),
    todo(
      '`usethis::use_proprietary_license(getOption("rdev.license.copyright"))`',
      lic == "proprietary"
    ),
    todo(
      "Update year in `inst/templates/`",
      fs::dir_exists("inst/templates/") && length(fs::dir_ls("inst/templates/")) >= 1
    ),
    todo(
      "Update year in `inst/rmarkdown/templates`",
      fs::dir_exists("inst/rmarkdown/templates") &&
        length(fs::dir_ls("inst/rmarkdown/templates")) >= 1
    ),
    todo(
      "Add alt-text to pictures, plots, etc; see https://posit.co/blog/knitr-fig-alt/ for \\
      examples and https://pkgdown.r-lib.org/articles/accessibility.html for additional guidance."
    ),
    ""
  )
  c(bullets, checklist_footer())
}

# upkeep helpers

last_upkeep_date <- function() {
  as.Date(
    desc::desc_get_field("Config/rdev/last-upkeep", "2021-01-01"),
    format = "%Y-%m-%d"
  )
}

last_upkeep_year <- function() {
  as.integer(format(last_upkeep_date(), "%Y"))
}

record_upkeep_date <- function(date) {
  desc::desc_set("Config/rdev/last-upkeep", format(date, "%Y-%m-%d"), normalize = TRUE)
}

todo <- function(x, cond = TRUE) {
  x <- glue::glue(x, .envir = parent.frame())
  if (cond) {
    paste0("- [ ] ", x)
  }
}

pkg_minimum_r_version <- "usethis" %:::% "pkg_minimum_r_version"

checklist_footer <- function() {
  glue::glue(
    '<sup>\\
    Created on {Sys.Date()} with `rdev::use_upkeep_issue()`, using \\
    [rdev v{utils::packageVersion("rdev")}](https://jabenninghoff.github.io/rdev/)\\
    </sup>'
  )
}

view_url <- function(url, open = rlang::is_interactive()) {
  if (open) utils::browseURL(url)
  invisible(url)
}
