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
    stop('currently only build_analysis_site(pkg = ".") is supported')
  }
  pkg_obj <- devtools::as.package(pkg)
  if (class(pkg_obj) != "package") {
    stop(pkg, " is not a valid package!")
  }

  header_regex <- paste0(
    "^# ", pkg_obj$package, " ", .standard_regexps()$valid_package_version, "$"
  )
  news_md <- readLines(filename)
  releases <- grep(header_regex, news_md)

  if (length(releases) < 1) {
    stop("no valid releases found in ", filename, "!")
  }
  if (releases[1] != 1) {
    stop("unexpected header in ", filename, "!")
  }

  version <- sub(paste0("^# ", pkg_obj$package, " "), "", news_md[releases[1]])

  # assumes only one leading/trailing blank line at most
  notes_start <- releases[1] + 1
  notes_end <- releases[2] - 1
  if (news_md[notes_start] == "") {
    notes_start <- notes_start + 1
  }
  if (news_md[notes_end] == "") {
    notes_end <- notes_end - 1
  }
  if (notes_end < notes_start) {
    notes <- c("")
  } else {
    notes <- news_md[notes_start:notes_end]
  }

  list(package = pkg_obj$package, version = version, notes = notes)
}

#' Stage a GitHub release
#'
#' Open a GitHub pull request for a new release from `NEWS.md`. Approve, merge, and create the
#'   release using `merge_release()`.
#'
#' When run, `stage_release()`:
#' 1. Extracts release version and release notes from `NEWS.md` using [get_release()]
#' 1. Validates version conforms to rdev conventions (#.#.#) and release notes aren't empty
#' 1. Verifies that version tag doesn't already exist using [gert::git_tag_list()]
#' 1. Checks for uncommitted changes and stops if any exist using [gert::git_diff_patch()]
#' 1. Creates a new branch if on the default branch ([gert::git_branch()] `==`
#'   [usethis::git_default_branch()]) using [gert::git_branch_create()]
#' 1. Updates `Version` in `DESCRIPTION` with [desc::desc_set_version()], commits and push to git
#'   with message `"GitHub release <version>"` using [gert::git_add()], [gert::git_commit()] and
#'   [gert::git_push()]
#' 1. Runs [build_analysis_site()] (if `pkgdown/_base.yml` exists) or [build_rdev_site()], commits
#'   and pushes changes to git with message `"<builder> for GitHub release <version>"`
#' 1. Opens a pull request with the title `"<package> <version>"` and the release notes in the body
#'   using [gh::gh()]
#'
#' @inheritParams get_release
#' @inheritParams usethis::use_github
#'
#' @return results of GitHub pull request, invisibly
#'
#' @export
stage_release <- function(pkg = ".", filename = "NEWS.md", host = NULL) {
  if (pkg != ".") {
    stop('currently only build_analysis_site(pkg = ".") is supported')
  }

  rel <- get_release(pkg = pkg, filename = filename)

  if (!grepl("^[0-9]*\\.[0-9]*\\.[0-9]*$", rel$version)) {
    stop("invalid package version: '", rel$version, "'")
  }
  if (length(rel$notes[rel$notes != ""]) < 1) {
    stop("no release notes found!")
  }

  if (nrow(gert::git_tag_list(match = rel$version, repo = pkg)) > 0) {
    stop("release tag '", rel$version, "' already exists!")
  }

  if (length(gert::git_diff_patch()) != 0) {
    stop("uncommitted changes present, aborting.")
  }

  if (gert::git_branch() == usethis::git_default_branch()) {
    new_branch <- paste0(rel$package, "-", gsub("\\.", "", rel$version))
    gert::git_branch_create(new_branch)
  }

  desc::desc_set_version(rel$version, file = pkg)
  gert::git_add("DESCRIPTION")
  gert::git_commit(paste0("GitHub release ", rel$version))
  gert::git_push()

  if (fs::file_exists("pkgdown/_base.yml")) {
    builder <- "build_analysis_site()"
    build_analysis_site()
  } else {
    builder <- "build_rdev_site()"
    build_rdev_site()
  }
  gert::git_add(".")
  gert::git_commit(paste0(builder, " for GitHub release ", rel$version))
  gert::git_push()

  gh_remote <- remotes::parse_github_url(gert::git_remote_info()$url)
  pr <- gh::gh(
    "POST /repos/{owner}/{repo}/pulls",
    owner = gh_remote$username,
    repo = gh_remote$repo,
    title = paste0(rel$package, " ", rel$version),
    head = gert::git_branch(),
    base = usethis::git_default_branch(),
    body = rel$notes,
    .api_url = host
  )

  invisible(pr)
}
