#' Start a new branch
#'
#' Create a new "feature" branch from the current or default branch of the project git repository
#'   using [gert::git_branch_create()] and bump 'dev' version to 9000 with
#'   [desc::desc_bump_version()].
#'
#' The new branch will be created and checked out if it does not exist on local or remote. If the
#'   version in DESCRIPTION has 3 components (a release version) and `bump_ver` is `TRUE` (the
#'   default), the fourth component, 'dev' will be bumped to 9000 and checked in to the new branch.
#'
#' If the version already has 4 components, it is not changed.
#'
#' If `current = FALSE` (the default), the new branch will be created from the default branch as
#'   determined by [usethis::git_default_branch()].
#'
#' @param name name of the new branch.
#' @param bump_ver if `TRUE`, bump 'dev' version to 9000, see details.
#' @param current create new branch from the currently active branch (`TRUE`) or from the default
#'   branch (`FALSE`), see details.
#'
#' @export
new_branch <- function(name, bump_ver = TRUE, current = FALSE) {
  checkmate::assert_string(name, min.chars = 1)
  checkmate::assert_flag(bump_ver)
  checkmate::assert_flag(current)

  if (gert::git_branch_exists(name, local = TRUE)) {
    stop("local branch exists", call. = FALSE)
  }
  if (gert::git_branch_exists(paste0("origin/", name), local = FALSE)) {
    stop("branch exists on remote (origin/", name, ")", call. = FALSE)
  }
  if (!current) {
    gert::git_branch_checkout(usethis::git_default_branch())
  }
  gert::git_branch_create(name)

  if (bump_ver && grepl("^[0-9]*\\.[0-9]*\\.[0-9]*$", desc::desc_get_version())) {
    stash <- FALSE
    if (nrow(gert::git_status()) != 0) {
      stash <- TRUE
      gert::git_stash_save(include_untracked = TRUE)
    }

    desc::desc_bump_version("dev")
    gert::git_add("DESCRIPTION")
    ret <- gert::git_commit("Bump version")

    if (stash) gert::git_stash_pop()

    ret
  }
}

#' Get release details
#'
#' Extract release version and release notes from `NEWS.md`.
#'
#' `get_release()` assumes that `NEWS.md` contains markdown release notes, with each release header
#'   of the format: `"# <package> <version>"` followed by the release notes, and expects the first
#'   line of `NEWS.md` to be a release header.
#'
#' @param pkg path to package. Currently, only `pkg = "."` is supported.
#' @param filename name of file containing release notes, defaults to `NEWS.md`.
#'
#' @return list containing the package, version and release notes from the first release contained
#'   in `NEWS.md`
#' @export
get_release <- function(pkg = ".", filename = "NEWS.md") {
  if (pkg != ".") {
    stop('currently only get_release(pkg = ".") is supported', call. = FALSE)
  }
  checkmate::assert_string(filename, min.chars = 1)

  pkg_obj <- devtools::as.package(pkg)
  header_regex <- paste0(
    "^# ", pkg_obj$package, " ", .standard_regexps()$valid_package_version, "$"
  )
  news_md <- readLines(filename)
  releases <- grep(header_regex, news_md)

  if (length(releases) < 1) {
    stop("no valid releases found in '", filename, "'", call. = FALSE)
  }
  if (releases[1] != 1) {
    stop("unexpected header in '", filename, "'", call. = FALSE)
  }

  release_version <- sub(paste0("^# ", pkg_obj$package, " "), "", news_md[releases[1]])

  # assumes only one leading/trailing blank line at most
  notes_start <- releases[1] + 1
  notes_end <- ifelse(length(releases) > 1, releases[2] - 1, length(news_md))
  if (news_md[notes_start] == "") {
    notes_start <- notes_start + 1
  }
  if (news_md[notes_end] == "") {
    notes_end <- notes_end - 1
  }
  if (notes_start > notes_end) {
    notes <- ""
  } else {
    notes <- news_md[notes_start:notes_end]
  }

  list(package = pkg_obj$package, version = release_version, notes = notes)
}

#' Stage a GitHub release
#'
#' Open a GitHub pull request for a new release from `NEWS.md`. Approve, merge, and create the
#'   release using [merge_release()].
#'
#' When run, `stage_release()`:
#' 1. Extracts release version and release notes from `NEWS.md` using [get_release()]
#' 1. Validates version conforms to rdev conventions (#.#.#) and release notes aren't empty
#' 1. Verifies that version tag doesn't already exist using [gert::git_tag_list()]
#' 1. Checks for uncommitted changes and stops if any exist using [gert::git_status()]
#' 1. Creates a new branch if on the default branch ([gert::git_branch()] `==`
#'   [usethis::git_default_branch()]) using [gert::git_branch_create()]
#' 1. Updates `Version` in `DESCRIPTION` with [desc::desc_set_version()], commits and push to git
#'   with message `"GitHub release <version>"` using [gert::git_add()], [gert::git_commit()] and
#'   [gert::git_push()]
#' 1. Runs [build_quarto_site()] (if `_quarto.yml` exists), [build_analysis_site()] (if
#'   `pkgdown/_base.yml` exists) or [build_rdev_site()] (if `_pkgdown.yml` exists), commits and
#'   pushes changes (if any) to git with message: `"<builder> for release <version>"`
#' 1. Opens a pull request with the title `"<package> <version>"` and the release notes in the body
#'   using [gh::gh()]
#'
#' @inheritSection create_github_repo Host
#'
#' @inheritParams get_release
#' @inheritParams build_quarto_site
#' @inheritParams usethis::use_github
#'
#' @return results of GitHub pull request, invisibly
#'
#' @export
stage_release <- function(pkg = ".",
                          filename = "NEWS.md",
                          unfreeze = FALSE,
                          host = getOption("rdev.host")) {
  if (pkg != ".") {
    stop('currently only stage_release(pkg = ".") is supported', call. = FALSE)
  }
  checkmate::assert_string(filename, min.chars = 1)
  checkmate::assert_flag(unfreeze)
  checkmate::assert_string(host, min.chars = 1, null.ok = TRUE)

  rel <- get_release(pkg = pkg, filename = filename)

  if (!grepl("^[0-9]*\\.[0-9]*\\.[0-9]*$", rel$version)) {
    stop("invalid package version '", rel$version, "'", call. = FALSE)
  }
  if (!any(nzchar(rel$notes))) {
    stop("no release notes found", call. = FALSE)
  }

  if (nrow(gert::git_tag_list(match = rel$version, repo = pkg)) > 0) {
    stop("release tag '", rel$version, "' already exists", call. = FALSE)
  }

  if (nrow(gert::git_status()) != 0) {
    stop("uncommitted changes present", call. = FALSE)
  }

  if (gert::git_branch() == usethis::git_default_branch()) {
    new_branch <- paste0(rel$package, "-", gsub(".", "", rel$version, fixed = TRUE))
    gert::git_branch_create(new_branch)
  }

  # double-check we're not on the default branch before making commits
  if (gert::git_branch() == usethis::git_default_branch()) {
    stop("on default branch (this should never happen)", call. = FALSE)
  }

  rel_message <- paste0("GitHub release ", rel$version)
  desc::desc_set_version(rel$version, file = pkg)
  gert::git_add("DESCRIPTION")
  gert::git_commit(rel_message)

  pkg_type <- package_type(pkg = pkg, strict = TRUE)
  if (pkg_type == "quarto") { # nolint: if_switch_linter. `if` is cleaner here.
    builder <- paste0("build_quarto_site(unfreeze = ", unfreeze, ")")
    build_quarto_site(unfreeze = unfreeze)
  } else if (pkg_type == "analysis") {
    builder <- "build_analysis_site()"
    build_analysis_site()
  } else if (pkg_type == "rdev") {
    builder <- "build_rdev_site()"
    build_rdev_site()
  } else {
    stop("could not determine builder type", call. = FALSE)
  }

  # commit builder changes if there are any
  if (nrow(gert::git_status()) != 0) {
    gert::git_add(".")
    gert::git_commit(paste0(builder, " for release ", rel$version))
  }
  gert::git_push()

  gh_remote <- remotes::parse_github_url(gert::git_remote_info()$url)
  pr <- gh::gh(
    "POST /repos/{owner}/{repo}/pulls",
    owner = gh_remote$username,
    repo = gh_remote$repo,
    title = paste0(rel$package, " ", rel$version),
    head = gert::git_branch(),
    base = usethis::git_default_branch(),
    body = paste(rel$notes, collapse = "\n"),
    .api_url = host
  )

  invisible(pr)
}

#' Merge staged GitHub release
#'
#' Merge a pull request staged with [stage_release()] and create a new release on GitHub.
#'
#' Manually verify that all status checks have completed before running, as `merge_release()`
#'  doesn't currently validate that status checks are successful.
#'
#' When run, `merge_release()`:
#' 1. Determines the staged release title from `NEWS.md` using [get_release()]
#' 1. Selects the GitHub pull request that matches the staged release title, stops if there is more
#'   or less than one matching PR using [gh::gh()]
#' 1. Verifies the staged pull request is ready to be merged by checking the locked, draft,
#'   mergeable, and rebaseable flags
#' 1. Merges the pull request into the default branch using "Rebase and merge" using [gh::gh()]
#' 1. Deletes the pull request branch remotely and locally using [gh::gh()] and
#'   [gert::git_branch_delete()]
#' 1. Updates the default branch with [gert::git_pull()]
#' 1. Adds the version tag to the `DESCRIPTION` commit with the message `"GitHub release <version>"`
#'   with [gert::git_tag_create()] and pushes using [gert::git_tag_push()]
#' 1. Create the GitHub release from the newly created tag, with the name `"<version>"` and the
#'   release notes in the body, using [gh::gh()]
#'
#' @inheritSection create_github_repo Host
#'
#' @inheritParams get_release
#' @inheritParams usethis::use_github
#'
#' @return list containing results of pull request merge and GitHub release, invisibly
#'
#' @export
merge_release <- function(pkg = ".", filename = "NEWS.md", host = getOption("rdev.host")) {
  if (pkg != ".") {
    stop('currently only merge_release(pkg = ".") is supported', call. = FALSE)
  }
  checkmate::assert_string(filename, min.chars = 1)
  checkmate::assert_string(host, min.chars = 1, null.ok = TRUE)

  rel <- get_release(pkg = pkg, filename = filename)
  pr_title <- paste0(rel$package, " ", rel$version)

  gh_remote <- remotes::parse_github_url(gert::git_remote_info()$url)
  pr_list <- gh::gh(
    "GET /repos/{owner}/{repo}/pulls",
    owner = gh_remote$username,
    repo = gh_remote$repo,
    .api_url = host
  )
  pr_list <- Filter(function(x) x$title == pr_title, pr_list)
  if (length(pr_list) == 0) {
    stop("found no open pull requests with the title '", pr_title, "'", call. = FALSE)
  }
  if (length(pr_list) > 1) {
    stop("found more than one pull request with the title '", pr_title, "'", call. = FALSE)
  }
  staged_pr <- gh::gh(
    "GET /repos/{owner}/{repo}/pulls/{pull_number}",
    owner = gh_remote$username,
    repo = gh_remote$repo,
    pull_number = pr_list[[1]]$number,
    .api_url = host
  )

  if (staged_pr$locked) {
    stop("pull request '", staged_pr$html_url, "' is marked as locked", call. = FALSE)
  }
  if (staged_pr$draft) {
    stop("pull request '", staged_pr$html_url, "' is marked as draft", call. = FALSE)
  }
  if (!staged_pr$mergeable) {
    stop("pull request '", staged_pr$html_url, "' is not marked as mergeable", call. = FALSE)
  }
  if (!staged_pr$rebaseable) {
    stop("pull request '", staged_pr$html_url, "' is not marked as rebaseable", call. = FALSE)
  }

  pr_merge <- gh::gh(
    "PUT /repos/{owner}/{repo}/pulls/{pull_number}/merge",
    owner = gh_remote$username,
    repo = gh_remote$repo,
    pull_number = staged_pr$number,
    sha = staged_pr$head$sha,
    merge_method = "rebase",
    .api_url = host
  )
  if (!pr_merge$merged) {
    stop("pull request merge '", staged_pr$html_url, "' failed", call. = FALSE)
  }

  gh::gh(
    "DELETE /repos/{owner}/{repo}/git/refs/heads/{branch}",
    owner = gh_remote$username,
    repo = gh_remote$repo,
    branch = staged_pr$head$ref,
    .api_url = host
  )
  gert::git_branch_checkout(usethis::git_default_branch())
  gert::git_branch_delete(staged_pr$head$ref)

  gert::git_pull()

  rel_message <- paste0("GitHub release ", rel$version)
  # see https://stackoverflow.com/questions/23303549/what-are-commit-ish-and-tree-ish-in-git
  gert::git_tag_create(rel$version, rel_message, ref = paste0("HEAD^{/", rel_message, "}"))
  gert::git_tag_push(rel$version)

  gh_release <- gh::gh(
    "POST /repos/{owner}/{repo}/releases",
    owner = gh_remote$username,
    repo = gh_remote$repo,
    tag_name = rel$version,
    name = rel$version,
    body = paste(rel$notes, collapse = "\n"),
    .api_url = host
  )

  invisible(list(merge = pr_merge, release = gh_release))
}
