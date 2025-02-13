#' Use rdev .Rprofile
#'
#' Install rdev .Rprofile template using [usethis::use_template()]
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_rprofile <- function(open = FALSE) {
  usethis::use_template("Rprofile", save_as = ".Rprofile", package = "rdev", open = open)
  # renv is not included in DESCRIPTION by convention
  usethis::use_package("pkgload", type = "Suggests")
  usethis::use_package("devtools", type = "Suggests")
  usethis::use_package("fs", type = "Suggests")
  usethis::use_package("usethis", type = "Suggests")
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
  usethis::use_package("pkgload", type = "Suggests")
}

#' Use rdev TODO.md
#'
#' Install rdev TODO.md template using [usethis::use_template()]
#'
#' @inheritParams usethis::use_template
#'
#' @export
use_todo <- function(open = rlang::is_interactive()) {
  # note: TODO.md generates an R CMD check note if not ignored
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
  if (fs::dir_exists("tests/testthat")) {
    usethis::use_template(
      "test-spelling.R",
      save_as = "tests/testthat/test-spelling.R",
      package = "rdev"
    )
  }
  usethis::use_package("fs", type = "Suggests")
  usethis::use_package("withr", type = "Suggests")
  desc::desc_normalize()
  renv::snapshot(dev = TRUE, prompt = prompt)
}

#' Use rdev code coverage
#'
#' Install code coverage with [`usethis::use_coverage(type = "codecov")`][usethis::use_coverage()],
#'   `DT` package for [covr::report()], and rdev GitHub action `test-coverage.yaml`.
#'
#' Because [use_rdev_package()], [use_analysis_package()] and `use_codecov()` all modify README.Rmd,
#'   `use_codecov()` must be run last or its changes will be overwritten. `use_codecov()` is not run
#'   in [use_rdev_package()].
#'
#' Set option `rdev.codecov` to `FALSE` to skip installation of codecov.io and `test-coverage.yaml`:
#'   `options(rdev.codecov = FALSE)`
#'
#' @inheritSection create_github_repo GitHub Actions
#'
#' @param prompt If TRUE, prompt before writing `renv.lock`, passed to [renv::snapshot()].
#'
#' @export
use_codecov <- function(prompt = FALSE) {
  renv::install("covr")
  if (getOption("rdev.codecov", default = TRUE)) {
    usethis::use_coverage(type = "codecov")
    spelling::update_wordlist(confirm = prompt) # use_coverage creates a "Codecov" badge
    sort_rbuildignore()
    if (getOption("rdev.github.actions", default = TRUE)) {
      usethis::use_github_action(
        url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/test-coverage.yaml"
      )
    }
  }
  usethis::use_package("covr", type = "Suggests")
  renv::install("DT")
  usethis::use_package("DT", type = "Suggests")
  renv::snapshot(dev = TRUE, prompt = prompt)
}

#' Get license option
#'
#' Retrieve and validate `rdev.license` option.
#'
#' `rdev.license` must be one of `c("mit", "gpl", "lgpl", "proprietary")`, and defaults to `"mit"`.
#'   If `rdev.license` is `"proprietary"`, `rdev.license.copyright` (the name of the copyright
#'   holder) must also be set.
#'
#' @return license string, one of `c("mit", "gpl", "lgpl", "proprietary")`
#' @export
get_license <- function() {
  lic <- getOption("rdev.license", default = "mit")
  if (!lic %in% c("mit", "gpl", "lgpl", "proprietary")) {
    stop("invalid rdev.license type, '", lic, "'", call. = FALSE)
  }
  if (lic == "proprietary" && is.null(getOption("rdev.license.copyright"))) {
    stop("rdev.license is 'proprietary' and rdev.license.copyright is not set", call. = FALSE)
  }
  lic
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
  # nocov start
  github_url <- usethis::git_remotes()$origin
  remotes::parse_github_url(github_url)
  # nocov end
}

#' Fix .gitignore file
#'
#' Workaround for closed issue https://github.com/r-lib/usethis/issues/1568: create_package adds
#'   `.Rproj.user` to `.gitignore` even when `.Rproj.user/` is already present
#'
#' @keywords internal
#' @noRd
fix_gitignore <- function(path = ".") {
  checkmate::assert_string(path, min.chars = 1)

  giti_path <- fs::path(path, ".gitignore")
  gitignore <- readLines(giti_path)
  gitignore <- gitignore[gitignore != ".Rproj.user"]
  writeLines(gitignore, giti_path)
}

#' Create rdev GitHub repository
#'
#' Create, configure, clone, and open a new GitHub R package repository following rdev conventions.
#'
#' When run, `create_github_repo()`:
#'   1. Creates a new GitHub repository using [gh::gh()] with license template from [get_license()]
#'   1. Activates Dependabot alerts per `getOption("rdev.dependabot", default = TRUE)`
#'   1. Activates Dependabot security updates per `getOption("rdev.dependabot", default = TRUE)`
#'   1. Adds branch protection to the default branch (if `private` is `FALSE`)
#'   1. Clones the repository locally with [usethis::create_from_github()]
#'   1. Creates a basic package using [usethis::create_package()]
#'   1. If running interactively on macOS, the repository will automatically be opened in RStudio,
#'      GitHub Desktop, and the default browser
#'
#' @section GitHub Actions: GitHub Actions can be disabled by setting `rdev.github.actions` to
#'   `FALSE`: `options(rdev.github.actions = FALSE)`
#'
#' @section Host:
#' Set the `rdev.host` option when using a GitHub Enterprise server:
#'   `options(rdev.host = "https://github.example.com/api/v3")`
#'
#' @seealso [quickstart]
#'
#' @inheritParams usethis::use_github
#' @param repo_name The name of the GitHub repository to create
#' @param repo_desc The description of the GitHub repository to create
#' @param org The organization to create the repository in. If `NULL`, create the repository in the
#'   active user's account.
#'
#' @return return value from [gh::gh()] creating the repository, invisibly
#' @export
create_github_repo <- function(repo_name, repo_desc = "", private = FALSE, org = NULL,
                               host = getOption("rdev.host")) {
  checkmate::assert_string(repo_name, min.chars = 1)
  checkmate::assert_string(repo_desc)
  checkmate::assert_flag(private)
  checkmate::assert_string(org, min.chars = 1, null.ok = TRUE)
  checkmate::assert_string(host, min.chars = 1, null.ok = TRUE)

  conspicuous_place <- "usethis" %:::% "conspicuous_place"
  user_path_prep <- "usethis" %:::% "user_path_prep"

  # determine target dir for create_from_github() and verify it doesn't exist before calling gh
  ut_destdir <- paste0(user_path_prep(conspicuous_place()), "/", repo_name)
  if (fs::dir_exists(ut_destdir)) {
    stop("create_from_github() target, '", ut_destdir, "' already exists", call. = FALSE)
  }

  if (is.null(org)) {
    create <- gh::gh(
      "POST /user/repos",
      name = repo_name,
      description = repo_desc,
      private = private,
      gitignore_template = "R",
      license_template = NULL,
      .api_url = host
    )
  } else {
    create <- gh::gh(
      "POST /orgs/{org}/repos",
      org = org,
      name = repo_name,
      description = repo_desc,
      private = private,
      gitignore_template = "R",
      license_template = NULL,
      .api_url = host
    )
  }

  if (getOption("rdev.dependabot", default = TRUE)) {
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
  }

  if (getOption("rdev.github.actions", default = TRUE)) {
    required_status_checks <- list(
      strict = TRUE,
      checks = list(
        list(context = "lint", app_id = 15368L),
        list(context = "macos-latest (release)", app_id = 15368L),
        list(context = "missing-deps", app_id = 15368L),
        list(context = "windows-latest (release)", app_id = 15368L)
      )
    )
  } else {
    required_status_checks <- list(strict = TRUE, contexts = list())
  }
  if (get_server_url() == "https://github.com/") {
    required_pull_request_reviews <- list(
      dismiss_stale_reviews = FALSE,
      require_code_owner_reviews = FALSE,
      required_approving_review_count = 0L
    )
  } else {
    required_pull_request_reviews <- NA
  }
  if (!private) {
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
  }

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
  writeLines("Apply rdev conventions within the new project by running init() without committing,")
  writeLines("update the Title and Description fields in `DESCRIPTION` without committing,")
  writeLines("and run either setup_ananlysis() or setup_rdev() to finish configuration.")

  if (Sys.info()["sysname"] == "Darwin" && rlang::is_interactive()) {
    system(paste0("open ", create$html_url, "/settings"))
    system(paste0("github ", fs_path))
  }

  invisible(create)
}

#' Get server URL
#'
#' Determine server URL from `rdev.host`
#'
#' @return server URL string, for use in [use_rdev_package()]
#'
#' @keywords internal
#' @noRd
get_server_url <- function() {
  host_url <- xml2::url_parse(getOption("rdev.host", default = "https://github.com/"))
  port <- ""
  if (!is.na(host_url$port)) port <- paste0(":", as.character(host_url$port))
  user <- ""
  if (host_url$user != "") user <- paste0(host_url$user, "@")

  paste0(host_url$scheme, "://", user, host_url$server, port, "/")
}

#' Is GitHub repository private?
#'
#' Query GitHub to determine if a repository is private or not. Written as an internal function so
#'   it can be stubbed out in local_temppkg().
#'
#' @param owner repository owner
#' @param repo repository name
#'
#' @return logical, `TRUE` if the repository is private
#'
#' @keywords internal
#' @noRd
gh_repo_private <- function(owner, repo) {
  gh_json <- gh::gh(
    "GET /repos/{owner}/{repo}",
    owner = owner,
    repo = repo,
    .api_url = getOption("rdev.host")
  )

  gh_json$private
}

#' Use rdev package conventions
#'
#' Add rdev templates and settings within the active package. Normally invoked when first setting
#'   up a package.
#'
#' @inheritSection create_github_repo GitHub Actions
#'
#' @section GitHub Pages: GitHub Pages is enabled by default for public repositories, and can be
#'   disabled by setting `rdev.github.pages` to `FALSE`: `options(rdev.github.pages = FALSE)`.
#'   GitHub Pages is disabled by default for private repositories (as it is not supported on the
#'   free plan), and can be enabled by setting `rdev.github.pages` to `TRUE`.
#'
#' @param quiet If TRUE, disable user prompts by setting [rlang::local_interactive()] to FALSE.
#'
#' @export
use_rdev_package <- function(quiet = TRUE) {
  checkmate::assert_flag(quiet)

  rlang::local_interactive(value = !quiet)

  # add templates
  use_lintr()
  use_package_r()
  if (getOption("rdev.github.actions", default = TRUE)) {
    usethis::use_github_action(
      url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/R-CMD-check.yaml"
    )
    usethis::use_github_action(
      url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/lint.yaml"
    )
    usethis::use_github_action(
      url = "https://github.com/jabenninghoff/rdev/blob/main/.github/workflows/missing-deps.yaml"
    )
  }
  use_todo()
  usethis::use_news_md()
  usethis::use_readme_rmd()
  # README.Rmd uses knitr and rmarkdown per renv::dependencies()
  usethis::use_package("knitr", type = "Suggests")
  usethis::use_package("rmarkdown", type = "Suggests")
  switch(get_license(),
    mit = usethis::use_mit_license(copyright_holder = getOption("rdev.license.copyright")),
    gpl = usethis::use_gpl_license(),
    lgpl = usethis::use_lgpl_license(),
    proprietary = usethis::use_proprietary_license(getOption("rdev.license.copyright"))
  )

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
  usethis::use_package("desc", type = "Suggests")
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

  # add github URLs to DESCRIPTION, optionally activate github pages
  gh_repo <- get_github_repo()
  gh_url <- paste0(get_server_url(), gh_repo$username, "/", gh_repo$repo)
  gh_issues <- paste0(gh_url, "/issues")
  private <- gh_repo_private(owner = gh_repo$username, repo = gh_repo$repo)

  if (getOption("rdev.github.pages", default = !private)) {
    gh_pages <- usethis::use_github_pages(branch = usethis::git_default_branch(), path = "/docs")
    pages_url <- gh_pages$html_url
    urls <- c(pages_url, gh_url)

    gh::gh(
      "PATCH /repos/{owner}/{repo}",
      owner = gh_repo$username,
      repo = gh_repo$repo,
      homepage = pages_url,
      .api_url = getOption("rdev.host")
    )
  } else {
    urls <- gh_url
  }

  desc::desc_set_urls(urls)
  desc::desc_set("BugReports", gh_issues)

  # update dependencies
  usethis::use_package("devtools", type = "Suggests")
  # use install_github() to prevent renv initialization
  remotes::install_github("jabenninghoff/rdev")
  usethis::use_dev_package("rdev", type = "Suggests", remote = "jabenninghoff/rdev")
  usethis::use_testthat()
  # add a test for package.R so that ci() passes immediately after use_rdev_package() is run
  usethis::use_test("package")

  desc::desc_normalize()

  # run document() to create package .Rd file
  devtools::document()
  # build REAMDE.md so that modified git hook works as expected
  devtools::build_readme()

  # use_rprofile() and sort_rbuildignore() need to run last, right before renv::init()
  use_rprofile()
  sort_rbuildignore()

  # run renv::init() last to restart the session
  # specify repos to use CRAN mirror instead of Posit Public Package Manager
  renv::init(settings = list(snapshot.type = "implicit"), repos = "https://cloud.r-project.org")
}

#' Use Analysis Package Layout
#'
# nolint next: line_length_linter.
#' Add the [Analysis Package Layout](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html)
#'   to the current package.
#'
#' When run, `use_analysis_package()`:
#' 1. Creates analysis package directories
#' 1. Adds exclusions to .gitignore and .Rbuildignore
#' 1. Adds `extra.css` to `analysis/assets` and `pkgdown` (when `use_quarto` is `FALSE`) to fix
#'    rendering of GitHub-style
# nolint next: line_length_linter.
#'    [task lists](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/about-task-lists)
#' 1. Adds `.nojekyll`, `_quarto.yml`, `changelog.qmd`, `index.qmd` and `analysis/_metadata.yml`
#'    from templates OR creates `_base.yml` in `pkgdown` from the first `URL` in `DESCRIPTION`
#' 1. Installs the `README.Rmd` template for analysis packages, and the `dplyr`
#'    package needed for the `README.Rmd` template
#'
#' @param use_quarto If `TRUE` (the default), use Quarto for publishing ([build_quarto_site()]),
#'   otherwise use [build_analysis_site()].
#' @inheritParams use_codecov
#'
#' @return List containing `dirs` created, `rbuildignore` lines added to .Rbuildignore, `gitignore`
#'   exclusions added to .gitignore.
#'
#' @export
use_analysis_package <- function(use_quarto = TRUE, prompt = FALSE) {
  # workaround for lintr, R CMD check
  create <- gitignore <- rbuildignore <- NULL

  checkmate::assert_flag(use_quarto)

  analysis_layout <- tibble::tribble(
    ~pattern,             ~create, ~gitignore, ~rbuildignore,
    "analysis",           TRUE,    FALSE,      FALSE,
    "analysis/*.docx",    FALSE,   TRUE,       TRUE,
    "analysis/*.html",    FALSE,   TRUE,       TRUE,
    "analysis/*.md",      FALSE,   TRUE,       TRUE,
    "analysis/*.pdf",     FALSE,   TRUE,       TRUE,
    "analysis/*-figure/", FALSE,   TRUE,       TRUE,
    "analysis/assets",    TRUE,    FALSE,      FALSE,
    "analysis/data",      TRUE,    FALSE,      FALSE,
    "analysis/import",    TRUE,    TRUE,       TRUE,
    "analysis/rendered",  TRUE,    TRUE,       TRUE,
    "docs",               TRUE,    FALSE,      TRUE
  )

  if (use_quarto) {
    quarto_layout <- tibble::tribble(
      ~pattern,             ~create, ~gitignore, ~rbuildignore,
      ".nojekyll",          FALSE,   FALSE,      TRUE,
      ".quarto",            FALSE,   FALSE,      TRUE,
      "/.quarto/",          FALSE,   TRUE,       FALSE,
      "_freeze",            FALSE,   FALSE,      TRUE,
      "_quarto.yml",        FALSE,   FALSE,      FALSE
    )
    analysis_layout <- rbind(analysis_layout, quarto_layout)
  } else {
    pkgdown_layout <- tibble::tribble(
      ~pattern,             ~create, ~gitignore, ~rbuildignore,
      "pkgdown",            TRUE,    FALSE,      TRUE,
      "_pkgdown.yml",       FALSE,   FALSE,      TRUE
    )
    analysis_layout <- rbind(analysis_layout, pkgdown_layout)
  }

  analysis_dirs <- subset(analysis_layout, create)$pattern

  analysis_gitignore <- subset(analysis_layout, gitignore)$pattern

  analysis_rbuildignore <- subset(analysis_layout, rbuildignore)$pattern
  analysis_rbuildignore <- gsub(".", "\\.", analysis_rbuildignore, fixed = TRUE)
  analysis_rbuildignore <- gsub("/$", "", analysis_rbuildignore)
  analysis_rbuildignore <- gsub("*", ".*", analysis_rbuildignore, fixed = TRUE)
  analysis_rbuildignore <- paste0("^", analysis_rbuildignore, "$")

  fs::dir_create(analysis_dirs)

  usethis::use_git_ignore(c(
    "# analysis package generated files",
    "# see: https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html"
  ))
  usethis::use_git_ignore(analysis_gitignore)

  # remove TODO.md from .Rbuildignore for analysis packages
  rbi <- readLines(".Rbuildignore")
  writeLines(rbi[!grepl("^TODO\\.md$", rbi, fixed = TRUE)], ".Rbuildignore")
  usethis::use_build_ignore(analysis_rbuildignore, escape = FALSE)
  sort_rbuildignore()

  usethis::use_template("extra.css", save_as = "analysis/assets/extra.css", package = "rdev")

  urls <- desc::desc_get_urls()
  if (length(urls) < 1) {
    stop("no URL found in DESCRIPTION", call. = FALSE)
  }
  github_repo <- get_github_repo()
  if (use_quarto) {
    fields <- list(
      repo = github_repo$repo,
      description = desc::desc_get_field("Description"),
      site_url = ifelse(!is.na(urls[2]), urls[1], "."),
      repo_url = ifelse(!is.na(urls[2]), urls[2], urls[1]),
      year = format(Sys.Date(), "%Y"),
      author = paste(desc::desc_get_author()$given, desc::desc_get_author()$family)
    )
    fs::file_create(".nojekyll")
    usethis::use_template("_quarto.yml", package = "rdev", data = fields)
    usethis::use_template("changelog.qmd", package = "rdev")
    usethis::use_template("index.qmd", package = "rdev", data = fields)
    usethis::use_template("_metadata.yml", save_as = "analysis/_metadata.yml", package = "rdev")
  } else {
    if (!fs::file_exists("pkgdown/_base.yml")) {
      yaml::write_yaml(
        list(url = ifelse(!is.na(urls[2]), urls[1], "."), template = list(bootstrap = 5L)),
        "pkgdown/_base.yml"
      )
    }
    usethis::use_template("extra.css", save_as = "pkgdown/extra.css", package = "rdev")
  }

  # always overwrite README.Rmd
  if (fs::file_exists("README.Rmd")) {
    fs::file_delete("README.Rmd")
  }
  usethis::use_template(
    "README-analysis.Rmd",
    save_as = "README.Rmd",
    package = "rdev",
    data = github_repo,
    ignore = TRUE,
    open = rlang::is_interactive()
  )
  desc::desc_set_dep("R", type = "Depends", version = ">= 4.1.0")
  desc::desc_normalize()

  renv::install("dplyr")
  usethis::use_package("dplyr", type = "Suggests")
  usethis::use_package("fs", type = "Suggests")
  usethis::use_package("purrr", type = "Suggests")
  if (use_quarto) {
    usethis::use_package("quarto", type = "Suggests")
  } else {
    usethis::use_package("pkgdown", type = "Suggests")
  }
  renv::snapshot(dev = TRUE, prompt = prompt)

  ret <- list(
    dirs = analysis_dirs, rbuildignore = analysis_rbuildignore, gitignore = analysis_gitignore
  )
  return(invisible(ret))
}

#' Use rdev pkgdown
#'
#' Add pkgdown with rdev customizations. Implemented as a wrapper for [usethis::use_pkgdown()].
#'
#' In addition to running [usethis::use_pkgdown()], `use_rdev_pkgdown` adds `extra.css` to
#'   `pkgdown` to fix rendering of GitHub-style
# nolint next: line_length_linter.
#'   [task lists](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/about-task-lists),
#'   adds the GitHub Pages URL, and enables
#'   [`template.light-switch`](https://pkgdown.r-lib.org/articles/customise.html#light-switch).
#'
#' @inheritParams usethis::use_pkgdown
#'
#' @export
use_rdev_pkgdown <- function(config_file = "_pkgdown.yml", destdir = "docs") {
  usethis::use_pkgdown(config_file = config_file, destdir = destdir)
  usethis::use_package("pkgdown", type = "Suggests")
  fs::dir_create(c("pkgdown", destdir))
  usethis::use_template("extra.css", save_as = "pkgdown/extra.css", package = "rdev")
  pkg <- yaml::read_yaml(config_file)
  urls <- desc::desc_get_urls()
  pkg$url <- ifelse(!is.na(urls[2]), urls[1], ".")
  pkg$template <- append(pkg$template, list(`light-switch` = TRUE))
  # workaround for RStudio race condition
  if (rlang::is_interactive()) {
    writeLines(paste0("\nupdating ", config_file, "..."), sep = "")
    Sys.sleep(1)
    writeLines("done!")
  }
  yaml::write_yaml(pkg, config_file, handlers = list(logical = yaml::verbatim_logical))
  sort_rbuildignore()
}
