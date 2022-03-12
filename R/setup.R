#' Use rdev .Rprofile
#'
#' Install rdev .Rprofile template using [usethis::use_template()]
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_rprofile <- function(open = FALSE) {
  usethis::use_template("Rprofile", save_as = ".Rprofile", package = "rdev", open = open)
}

#' Use rdev .lintr
#'
#' Install rdev .lintr template using [usethis::use_template()]
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_lintr <- function(open = FALSE) {
  usethis::use_template("lintr", save_as = ".lintr", package = "rdev", ignore = TRUE, open = open)
}

#' Use rdev TODO.md
#'
#' Install rdev TODO.md template using [usethis::use_template()]
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_todo <- function(open = rlang::is_interactive()) {
  usethis::use_template("TODO.md", package = "rdev", ignore = TRUE, open = open)
}

#' Use rdev package.R
#'
#' Install rdev package.R template using [usethis::use_template()]
#'
#' package.R is saved as "R/package.R".
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_package_r <- function(open = FALSE) {
  # warning: this assumes use_package_r is called from the package root directory
  if (!fs::dir_exists("R")) {
    fs::dir_create("R")
  }
  usethis::use_template(
    "package.R",
    save_as = "R/package.R",
    package = "rdev",
    open = open
  )
}

#' Use rdev spelling
#'
#' Install [spelling][spelling::spelling] with rdev conventions.
#'
#' Since [spelling::spell_check_setup()] requires user interaction, `use_spelling()` is not run in
#'   [use_rdev_package()].
#'
#' @inheritParams usethis::use_spell_check
#' @inheritParams use_codecov
#'
#' @export
use_spelling <- function(lang = "en-US", prompt = FALSE) {
  renv::install("spelling")
  usethis::use_spell_check(vignettes = TRUE, lang = lang, error = TRUE)
  fs::file_delete("tests/spelling.R")
  usethis::use_template("spelling.R", save_as = "tests/spelling.R", package = "rdev")
  renv::snapshot(prompt = prompt)
}

#' Use rdev codecov
#'
#' Install code coverage with [`usethis::use_coverage(type = "codecov")`][usethis::use_coverage()],
#'   `DT` package for [covr::report()], and rdev GitHub action `test-coverage.yaml`.
#'
#' Because [use_rdev_package()], [use_analysis_package()] and `use_codecov()` all modify README.Rmd,
#'   `use_codecov()` must be run last or its changes will be overwritten. `use_codecov()` is not run
#'   in [use_rdev_package()].
#'
#' @param prompt If TRUE, prompt before writing `renv.lock`, passed to [renv::snapshot()].
#'
#' @export
use_codecov <- function(prompt = FALSE) {
  renv::install("covr")
  usethis::use_coverage(type = "codecov")
  sort_rbuildignore()
  renv::install("DT")
  usethis::use_package("DT", type = "Suggests")
  usethis::use_github_action(
    url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/test-coverage.yaml"
  )
  renv::snapshot(prompt = prompt)
}

#' Get GitHub username and repository
#'
#' Retrieve and parse the GitHub remote to identify username and repo name.
#'
#' @return List with members: username, repo, subdir ref, pull, release, some which will be empty.
#'
#' @keywords internal
#' @noRd
get_github_repo <- function() {
  url <- usethis::git_remotes()$origin

  remotes::parse_github_url(url)
}

#' Fix .gitignore file
#'
#' Workaround for closed issue https://github.com/r-lib/usethis/issues/1568: create_package adds
#'   `.Rproj.user` to `.gitignore` even when `.Rproj.user/` is already present
#'
#' @keywords internal
#' @noRd
fix_gitignore <- function(path = ".") {
  giti_path <- fs::path(path, ".gitignore")
  gitignore <- readLines(giti_path)
  gitignore <- gitignore[!grepl("^\\.Rproj\\.user$", gitignore)]
  writeLines(gitignore, giti_path)
}

#' Create rdev GitHub repository
#'
#' Create, configure, clone, and open a new GitHub R package repository following rdev conventions.
#'
#' When run, `create_github_repo()`:
#'   1. Creates a new GitHub repository in the active user's account using [gh::gh()]
#'   1. Activates Dependabot alerts
#'   1. Activates Dependabot security updates
#'   1. Adds branch protection to the default branch
#'   1. Clones the repository locally with [usethis::create_from_github()]
#'   1. Creates a basic package using [usethis::create_package()]
#'   1. If running interactively on macOS, the repository will automatically be opened in RStudio,
#'      GitHub Desktop, and the default browser
#'
#' @section Host:
#' Set the `rdev.host` option when using a GitHub Enterprise server:
#'   `options(rdev.host = "https://github.example.com/api/v3")`
#'
#' @inheritParams usethis::use_github
#' @param repo_name The name of the GitHub repository to create
#' @param repo_desc The description of the GitHub repository to create
#'
#' @return return value from [gh::gh()] creating the repository, invisibly
#' @export
create_github_repo <- function(repo_name, repo_desc = "", host = getOption("rdev.host")) {
  # workaround for ::: per https://stat.ethz.ch/pipermail/r-devel/2013-August/067210.html
  `%:::%` <- function(pkg, fun) {
    get(fun,
      envir = asNamespace(pkg),
      inherits = FALSE
    )
  }
  conspicuous_place <- "usethis" %:::% "conspicuous_place"
  user_path_prep <- "usethis" %:::% "user_path_prep"

  # determine target dir for create_from_github() and verify it doesn't exist before calling gh
  ut_destdir <- paste0(user_path_prep(conspicuous_place()), "/", repo_name)
  if (fs::dir_exists(ut_destdir)) {
    stop(paste0("create_from_github() target, '", ut_destdir, "' already exists"))
  }

  create <- gh::gh(
    "POST /user/repos",
    name = repo_name,
    description = repo_desc,
    gitignore_template = "R",
    license_template = "mit",
    .api_url = host
  )

  gh::gh(
    "PUT /repos/{owner}/{repo}/vulnerability-alerts",
    owner = create$owner$login,
    repo = create$name,
    .api_url = host
  )

  gh::gh(
    "PUT /repos/{owner}/{repo}/automated-security-fixes",
    owner = create$owner$login,
    repo = create$name,
    .api_url = host
  )

  required_status_checks <- list(
    strict = TRUE,
    checks = list(
      list(context = "lint", app_id = 15368L),
      list(context = "macOS-latest (release)", app_id = 15368L),
      list(context = "windows-latest (release)", app_id = 15368L)
    )
  )
  required_pull_request_reviews <- list(
    dismiss_stale_reviews = FALSE,
    require_code_owner_reviews = FALSE,
    required_approving_review_count = 0L
  )
  gh::gh(
    "PUT /repos/{owner}/{repo}/branches/{branch}/protection",
    owner = create$owner$login,
    repo = create$name,
    branch = create$default_branch,
    required_status_checks = required_status_checks,
    enforce_admins = NA,
    required_pull_request_reviews = required_pull_request_reviews,
    restrictions = NA,
    required_linear_history = TRUE,
    .api_url = host
  )

  # warning: duplicates .Rproj.user in .gitignore
  fs_path <- usethis::create_from_github(
    paste0(create$owner$login, "/", create$name),
    open = FALSE,
    host = host
  )
  # delete the .Rproj file so create_package doesn't prompt to overwrite
  fs::file_delete(paste0(fs_path, "/", create$name, ".Rproj"))

  usethis::create_package(fs_path)
  fix_gitignore(fs_path)

  writeLines(paste0("\n", "Repository created at: ", create$html_url))
  writeLines(paste0("Open the repository by executing: $ github ", fs_path))
  writeLines("Apply rdev conventions within the new project with use_rdev_package(),")
  writeLines("and use either use_analysis_package() or usethis::use_pkgdown() for GitHub Pages.")

  if (Sys.info()["sysname"] == "Darwin" & rlang::is_interactive()) {
    system(paste0("open ", create$html_url, "/settings"))
    system(paste0("github ", fs_path))
  }

  invisible(create)
}

#' Use rdev package conventions
#'
#' Add rdev templates and settings within the active package. Normally invoked when first setting
#'   up a package.
#'
#' @param quiet If TRUE, disable user prompts by setting [rlang::local_interactive()] to FALSE.
#'
#' @export
use_rdev_package <- function(quiet = TRUE) {
  rlang::local_interactive(value = !quiet)

  # add templates
  use_lintr()
  use_package_r()
  usethis::use_github_action(
    url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/check-standard.yaml"
  )
  usethis::use_github_action(
    url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/lint.yaml"
  )
  use_todo()
  usethis::use_news_md()
  usethis::use_readme_rmd()
  usethis::use_mit_license()

  # replace README.Rmd with rdev template
  fs::file_delete("README.Rmd")
  usethis::use_template(
    "README-rdev.Rmd",
    save_as = "README.Rmd",
    package = "rdev",
    data = get_github_repo(),
    ignore = TRUE,
    open = rlang::is_interactive()
  )
  # replace pre-commit hook to allow committing README.md without README.Rmd
  if (fs::file_exists(".git/hooks/pre-commit")) {
    fs::file_delete(".git/hooks/pre-commit")
  }
  usethis::use_git_hook(
    "pre-commit", readLines(fs::path_package("rdev", "templates", "pre-commit"))
  )

  # add macOS/vim gitignores
  usethis::use_git_ignore(c(
    "# macOS, vim",
    ".DS_Store",
    "*.swp",
    "~$*"
  ))

  # activate github pages, add github URLs to DESCRIPTION
  gh_repo <- get_github_repo()
  gh_pages <- usethis::use_github_pages(branch = usethis::git_default_branch(), path = "/docs")

  pages_url <- sub("/$", "", gh_pages$html_url)
  gh_url <- paste0("https://github.com/", gh_repo$username, "/", gh_repo$repo)
  gh_issues <- paste0(gh_url, "/issues")

  desc::desc_set_urls(c(pages_url, gh_url))
  desc::desc_set("BugReports", gh_issues)

  # warning: assumes repo is on github.com
  gh::gh(
    "PATCH /repos/{owner}/{repo}",
    owner = gh_repo$username,
    repo = gh_repo$repo,
    homepage = pages_url
  )

  # update dependencies
  usethis::use_package("devtools", type = "Suggests")
  # use install_github() to prevent renv initialization
  remotes::install_github("jabenninghoff/rdev")
  usethis::use_dev_package("rdev", type = "Suggests", remote = "jabenninghoff/rdev")
  usethis::use_testthat()
  # add a test for package.R so that ci() passes immediately after use_rdev_package() is run
  usethis::use_test("package")

  # run document() to create package .Rd file
  devtools::document()
  # build REAMDE.md so that modified git hook works as expected
  devtools::build_readme()

  # use_rprofile() and sort_rbuildignore() need to run last, right before renv::init()
  use_rprofile()
  sort_rbuildignore()

  # run renv::init() last to restart the session
  renv::init()
}

#' Use Analysis Package Layout
#'
# nolint start: line_length_linter
#' Add the [Analysis Package Layout](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)
# nolint end
#'   to the current package.
#'
#' When run, `use_analysis_package()` creates analysis package directories, adds exclusions to
#'   .gitignore and .Rbuildignore, creates `_base.yml` in `pkgdown` from the first `URL` in
#'   `DESCRIPTION`, installs the `README.Rmd` template for analysis packages, and the `dplyr`
#'   package needed for the `README.Rmd` template.
#'
#' @inheritParams use_codecov
#'
#' @return List containing `dirs` created, `rbuildignore` lines added to .Rbuildignore, `gitignore`
#'   exclusions added to .gitignore.
#'
#' @export
use_analysis_package <- function(prompt = FALSE) {
  # workaround for lintr, R CMD check
  create <- gitignore <- rbuildignore <- NULL

  analysis_layout <- tibble::tribble(
    ~pattern, ~create, ~gitignore, ~rbuildignore,
    "analysis", TRUE, FALSE, FALSE,
    "analysis/*.docx", FALSE, TRUE, TRUE,
    "analysis/*.html", FALSE, TRUE, TRUE,
    "analysis/*.md", FALSE, TRUE, TRUE,
    "analysis/*.pdf", FALSE, TRUE, TRUE,
    "analysis/*-figure/", FALSE, TRUE, TRUE,
    "analysis/assets", TRUE, FALSE, FALSE,
    "analysis/data", TRUE, FALSE, FALSE,
    "analysis/import", TRUE, TRUE, TRUE,
    "analysis/rendered", TRUE, TRUE, TRUE,
    "docs", TRUE, FALSE, TRUE,
    "pkgdown", TRUE, FALSE, TRUE,
    "_pkgdown.yml", FALSE, FALSE, TRUE,
  )

  analysis_dirs <- subset(analysis_layout, create)$pattern

  analysis_gitignore <- subset(analysis_layout, gitignore)$pattern

  analysis_rbuildignore <- subset(analysis_layout, rbuildignore)$pattern
  analysis_rbuildignore <- gsub("\\.", "\\\\.", analysis_rbuildignore)
  analysis_rbuildignore <- gsub("/$", "", analysis_rbuildignore)
  analysis_rbuildignore <- gsub("\\*", ".\\*", analysis_rbuildignore)
  analysis_rbuildignore <- paste0("^", analysis_rbuildignore, "$")

  fs::dir_create(analysis_dirs)

  usethis::use_git_ignore(c(
    "# analysis package generated files",
    "# see: https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html"
  ))
  usethis::use_git_ignore(analysis_gitignore)

  usethis::use_build_ignore(analysis_rbuildignore, escape = FALSE)
  sort_rbuildignore()

  urls <- desc::desc_get_urls()
  if (length(urls) >= 1 & !fs::file_exists("pkgdown/_base.yml")) {
    yaml::write_yaml(list(url = urls[1]), "pkgdown/_base.yml")
  }

  # always overwrite README.Rmd
  if (fs::file_exists("README.Rmd")) {
    fs::file_delete("README.Rmd")
  }
  usethis::use_template(
    "README-analysis.Rmd",
    save_as = "README.Rmd",
    package = "rdev",
    data = get_github_repo(),
    ignore = TRUE,
    open = rlang::is_interactive()
  )

  renv::install("dplyr")
  usethis::use_package("dplyr", type = "Suggests")
  renv::snapshot(prompt = prompt)

  ret <- list(
    dirs = analysis_dirs, rbuildignore = analysis_rbuildignore, gitignore = analysis_gitignore
  )
  return(invisible(ret))
}
