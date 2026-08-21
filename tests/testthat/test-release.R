# test-release globals

withr::local_dir("test-release")
git_status_empty <- structure(
  list(file = character(0), status = character(0), staged = logical(0)),
  row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
)
git_status_changed <- structure(
  list(file = "test", status = "new", staged = FALSE),
  row.names = c(NA, -1L), class = c("tbl_df", "tbl", "data.frame")
)

# new_branch

ver <- structure(list(c(1L, 0L, 0L)), class = c(
  "package_version",
  "numeric_version"
))

dev_ver <- structure(list(c(1L, 0L, 0L, 9000L)), class = c(
  "package_version",
  "numeric_version"
))

test_that("new_branch validates arguments", {
  mockery::stub(new_branch, "gert::git_branch_exists", NULL)
  mockery::stub(new_branch, "gert::git_branch_checkout", NULL)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", NULL)
  mockery::stub(new_branch, "gert::git_status", NULL)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", NULL)
  mockery::stub(new_branch, "gert::git_stash_pop", NULL)

  expect_error(new_branch(name = NA_character_), "'name'")
  expect_error(new_branch(name = ""), "'name'")
  expect_error(new_branch("test", bump_ver = NA), "'bump_ver'")
  expect_error(new_branch("test", current = NA), "'current'")
})

test_that("new_branch errors when local or remote branch exists", {
  g <- function(name, local = TRUE) {
    if (name == "local" && local) {
      return(TRUE)
    }
    if (name == "origin/remote" && !local) {
      return(TRUE)
    }
    FALSE
  }
  mockery::stub(new_branch, "gert::git_branch_exists", g)
  mockery::stub(new_branch, "gert::git_branch_checkout", NULL)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", ver)
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", NULL)
  mockery::stub(new_branch, "gert::git_stash_pop", NULL)

  expect_error(new_branch("local"), "^local branch exists$")
  expect_error(new_branch("remote"), "^branch exists on remote \\(origin/remote\\)$")
  expect_no_error(new_branch("test"))
})

test_that("new_branch branches from default branch when current = FALSE and current when TRUE", {
  s <- function(x) {
    stop("gert::git_branch_checkout", call. = FALSE)
  }
  mockery::stub(new_branch, "gert::git_branch_exists", FALSE)
  mockery::stub(new_branch, "gert::git_branch_checkout", s)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", ver)
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")
  mockery::stub(new_branch, "gert::git_stash_pop", NULL)

  expect_identical(new_branch("test", current = TRUE), "Bump version")
  expect_error(new_branch("test", current = FALSE), "^gert::git_branch_checkout$")
})

test_that("new_branch bumps non-dev version", {
  mockery::stub(new_branch, "gert::git_branch_exists", FALSE)
  mockery::stub(new_branch, "gert::git_branch_checkout", NULL)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", ver)
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")
  mockery::stub(new_branch, "gert::git_stash_pop", NULL)

  expect_identical(new_branch("test"), "Bump version")
  expect_null(new_branch("test", bump_ver = FALSE))
})

test_that("new_branch doesn't bump dev version", {
  mockery::stub(new_branch, "gert::git_branch_exists", FALSE)
  mockery::stub(new_branch, "gert::git_branch_checkout", NULL)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", dev_ver)
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")
  mockery::stub(new_branch, "gert::git_stash_pop", NULL)

  expect_null(new_branch("test"))
  expect_null(new_branch("test", bump_ver = FALSE))
})

test_that("new_branch stashes files", {
  mockery::stub(new_branch, "gert::git_branch_exists", FALSE)
  mockery::stub(new_branch, "gert::git_branch_checkout", NULL)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", ver)
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(
    new_branch, "gert::git_stash_save", function(...) stop("git_stash_save", call. = FALSE)
  )
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")
  mockery::stub(new_branch, "gert::git_stash_pop", function() stop("git_stash_pop", call. = FALSE))

  # git_status_empty skips stash
  expect_identical(new_branch("test"), "Bump version")

  # git_status_changed saves and pops stash
  mockery::stub(new_branch, "gert::git_status", git_status_changed)
  expect_error(new_branch("test"), "^git_stash_save$")
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
  expect_error(new_branch("test"), "^git_stash_pop$")

  # version is still bumped when git_status_changed
  mockery::stub(new_branch, "gert::git_stash_pop", NULL)
  expect_identical(new_branch("test"), "Bump version")
  expect_null(new_branch("test", bump_ver = FALSE))
})

# get_release

pkg_test <- structure(list(
  package = "testpkg", title = "R Test Package", version = "1.0.0",
  description = "A test package.",
  encoding = "UTF-8"
), class = "package")

test_that("get_release validates arguments", {
  mockery::stub(get_release, "devtools::as.package", NULL)

  expect_error(
    get_release(pkg = "tpkg"), '^currently only get_release\\(pkg = "\\."\\) is supported$'
  )
  expect_error(get_release(filename = NA_character_), "'filename'")
  expect_error(get_release(filename = ""), "'filename'")
})

test_that("get_release returns correct package, release version and notes", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  expected_notes <- c(
    "Major update.", "", "## New Features", "", "* `feature1()`: description", "",
    "* `feature2()`: description", "", "* `feature3()`: description", "", "## Other Changes", "",
    "* Update one", "", "* Update two"
  )
  rel <- get_release()
  expect_length(rel, 3)
  expect_identical(rel$package, "testpkg")
  expect_identical(rel$version, "1.2.0")
  expect_identical(rel$notes, expected_notes)
})

test_that("get_release returns correct package, version, and notes for first release", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  rel <- get_release(filename = "first-release.md")
  expect_length(rel, 3)
  expect_identical(rel$package, "testpkg")
  expect_identical(rel$version, "1.0.0")
  expect_identical(rel$notes, "Initial release.")
})

test_that("get_release returns error on invalid NEWS.md format", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  expect_error(get_release(filename = "empty.md"), "^no valid releases found in 'empty\\.md'$")
  expect_error(get_release(filename = "no-h1.md"), "^no valid releases found in 'no-h1\\.md'$")
  expect_error(
    get_release(filename = "bad-first-h1.md"), "^unexpected header in 'bad-first-h1\\.md'$"
  )
  expect_error(
    get_release(filename = "bad-first-h1-1.md"), "^unexpected header in 'bad-first-h1-1\\.md'$"
  )
})

test_that("get_release returns valid but non-rdev version", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  rel <- get_release(filename = "bad-version.md")
  expect_identical(rel$version, "1.1")
})

# validate_release

test_that("validate_release validates release notes", {
  mockery::stub(validate_release, "gert::git_tag_list", NULL)

  pkg <- NULL
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  rel <- get_release(filename = "bad-version.md")
  expect_error(validate_release(pkg, rel), "^invalid package version '1\\.1'$")

  rel <- get_release(filename = "bad-notes.md")
  expect_error(validate_release(pkg, rel), "^no release notes found$")
})

test_that("validate_release returns error if git tag matching version exists", {
  tag_12 <- structure(list(
    name = "1.2.0", ref = "refs/tags/1.2.0",
    commit = "a7422084c6e7f89206b37bd567f66e8111e7e219"
  ), row.names = 1L, class = c(
    "tbl_df",
    "tbl", "data.frame"
  ))
  mockery::stub(validate_release, "gert::git_tag_list", tag_12)

  pkg <- NULL
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()

  expect_error(validate_release(pkg, rel), "^release tag '1\\.2\\.0' already exists$")
})

# stop_uncommitted

test_that("stop_uncommitted returns error if uncommitted changes are present", {
  mockery::stub(stop_uncommitted, "gert::git_status", git_status_changed)
  expect_error(stop_uncommitted(), "^uncommitted changes present$")

  mockery::stub(stop_uncommitted, "gert::git_status", git_status_empty)
  expect_no_error(stop_uncommitted())
})

# find_staged_pr

test_that("find_staged_pr errors when expected", {
  # sophisticated stub for gh::gh
  gh_pull_number <- list(
    locked = FALSE, draft = FALSE, mergeable = TRUE, rebaseable = TRUE,
    html_url = "https://github.com/example/test"
  )
  gh <- function(command, ...) {
    if (command == "GET /repos/{owner}/{repo}/pulls") {
      return(gh_pulls)
    }
    if (command == "GET /repos/{owner}/{repo}/pulls/{pull_number}") {
      return(gh_pull_number)
    }
    stop("unknown command", call. = FALSE)
  }
  mockery::stub(find_staged_pr, "gh::gh", gh)
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  gh_remote <- list(name = "origin", url = "https://github.com/example/test.git")
  host <- NULL

  gh_pulls <- list(list(title = "testpkg 1.2.0"))
  expect_no_error(find_staged_pr(rel, gh_remote, host))

  gh_pulls <- list(list(title = "testpkg 1.2.0"), list(title = "testpkg 1.2.0"))
  expect_error(
    find_staged_pr(rel, gh_remote, host),
    "^found more than one pull request with the title 'testpkg 1\\.2\\.0'$"
  )

  gh_pulls <- list(list(title = "test PR"), list(title = "test PR 2"))
  expect_error(
    find_staged_pr(rel, gh_remote, host),
    "^found no open pull requests with the title 'testpkg 1\\.2\\.0'$"
  )
})

# commit_build_release

test_that("commit_build_release errors on default branch", {
  mockery::stub(commit_build_release, "gert::git_branch", "main")
  mockery::stub(commit_build_release, "usethis::git_default_branch", "main")
  mockery::stub(commit_build_release, "desc::desc_set_version", NULL)
  mockery::stub(commit_build_release, "gert::git_add", NULL)
  mockery::stub(commit_build_release, "gert::git_commit", NULL)
  mockery::stub(commit_build_release, "package_type", NULL)
  mockery::stub(commit_build_release, "build_quarto_site", NULL)
  mockery::stub(commit_build_release, "build_analysis_site", NULL)
  mockery::stub(commit_build_release, "build_rdev_site", NULL)
  mockery::stub(commit_build_release, "gert::git_push", NULL)

  pkg <- rel <- unfreeze <- NULL
  expect_error(
    commit_build_release(pkg, rel, unfreeze), "^on default branch \\(this should never happen\\)$"
  )
})

test_that("commit_build_release runs proper builder", {
  mockery::stub(commit_build_release, "gert::git_branch", "stage-release")
  mockery::stub(commit_build_release, "usethis::git_default_branch", "main")
  mockery::stub(commit_build_release, "desc::desc_set_version", NULL)
  mockery::stub(commit_build_release, "gert::git_add", NULL)
  mockery::stub(commit_build_release, "gert::git_commit", NULL)
  mockery::stub(commit_build_release, "package_type", NULL)
  quarto <- function(unfreeze = TRUE) stop("build_quarto_site", call. = FALSE)
  analysis <- function() stop("build_analysis_site", call. = FALSE)
  rdev <- function() stop("build_rdev_site", call. = FALSE)
  mockery::stub(commit_build_release, "build_quarto_site", quarto)
  mockery::stub(commit_build_release, "build_analysis_site", analysis)
  mockery::stub(commit_build_release, "build_rdev_site", rdev)
  mockery::stub(commit_build_release, "gert::git_push", NULL)

  pkg <- NULL
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  unfreeze <- TRUE

  mockery::stub(commit_build_release, "package_type", "fake")
  expect_error(commit_build_release(pkg, rel, unfreeze), "^could not determine builder type$")

  mockery::stub(commit_build_release, "package_type", "quarto")
  expect_error(commit_build_release(pkg, rel, unfreeze), "^build_quarto_site$")

  mockery::stub(commit_build_release, "package_type", "analysis")
  expect_error(commit_build_release(pkg, rel, unfreeze), "^build_analysis_site$")

  mockery::stub(commit_build_release, "package_type", "rdev")
  expect_error(commit_build_release(pkg, rel, unfreeze), "^build_rdev_site$")
})

# stage_release

test_that("stage_release validates arguments", {
  mockery::stub(stage_release, "get_release", NULL)
  mockery::stub(stage_release, "validate_release", NULL)
  mockery::stub(stage_release, "stop_uncommitted", NULL)
  mockery::stub(stage_release, "gert::git_branch", NULL)
  mockery::stub(stage_release, "usethis::git_default_branch", NULL)
  mockery::stub(stage_release, "gert::git_remote_info", NULL)
  mockery::stub(stage_release, "remotes::parse_github_url", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)
  mockery::stub(stage_release, "view_url", NULL)

  expect_error(
    stage_release(pkg = "tpkg"), '^currently only stage_release\\(pkg = "\\."\\) is supported$'
  )
  expect_error(stage_release(filename = NA_character_), "'filename'")
  expect_error(stage_release(filename = ""), "'filename'")
  expect_error(stage_release(host = NA_character_), "'host'")
  expect_error(stage_release(host = ""), "'host'")
})

test_that("stage_release stops on default branch", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "validate_release", NULL)
  mockery::stub(stage_release, "stop_uncommitted", NULL)
  mockery::stub(stage_release, "gert::git_branch", "add-feature")
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  mockery::stub(stage_release, "gert::git_remote_info", NULL)
  mockery::stub(stage_release, "remotes::parse_github_url", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)
  mockery::stub(stage_release, "view_url", NULL)

  expect_no_error(stage_release())

  mockery::stub(stage_release, "gert::git_branch", "main")
  expect_error(stage_release(), "^on default branch$")
})

test_that("stage_release returns pull request results", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "validate_release", NULL)
  mockery::stub(stage_release, "stop_uncommitted", NULL)
  mockery::stub(stage_release, "gert::git_branch", "stage-release")
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  rem <- list(name = "origin", url = "https://github.com/example/test.git")
  mockery::stub(stage_release, "gert::git_remote_info", rem)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", "pull_request")
  mockery::stub(stage_release, "view_url", NULL)

  withr::local_dir(withr::local_tempdir())
  fs::file_create("_quarto.yml")

  expect_identical(stage_release(), "pull_request")
})

# approve_release

test_that("approve_release validates arguments", {
  mockery::stub(approve_release, "stop_uncommitted", NULL)
  mockery::stub(approve_release, "get_release", NULL)
  mockery::stub(approve_release, "remotes::parse_github_url", NULL)
  mockery::stub(approve_release, "gert::git_remote_info", NULL)
  mockery::stub(approve_release, "find_staged_pr", NULL)
  mockery::stub(approve_release, "gert::git_branch", NULL)
  mockery::stub(approve_release, "gert::git_pull", NULL)
  mockery::stub(approve_release, "gert::git_log", NULL)
  mockery::stub(approve_release, "gh::gh", NULL)
  mockery::stub(approve_release, "commit_build_release", NULL)

  expect_error(
    approve_release(pkg = "tpkg"), '^currently only approve_release\\(pkg = "\\."\\) is supported$'
  )
  expect_error(approve_release(filename = NA_character_), "'filename'")
  expect_error(approve_release(filename = ""), "'filename'")
  expect_error(approve_release(unfreeze = NA), "'unfreeze'")
  expect_error(approve_release(host = NA_character_), "'host'")
  expect_error(approve_release(host = ""), "'host'")
})

test_that("approve_release checks PR branch, PR approval, updates PR description", {
  rel <- list(
    package = "testpkg",
    version = "1.2.0",
    notes = "* Updated `test_function()` for R 4.0"
  )
  mockery::stub(approve_release, "stop_uncommitted", NULL)
  mockery::stub(approve_release, "get_release", rel)
  mockery::stub(approve_release, "remotes::parse_github_url", NULL)
  mockery::stub(approve_release, "gert::git_remote_info", NULL)
  pr <- list(
    head = list(ref = "update-test-function"),
    body = "* Updated `test_function()` for R 4.0",
    html_url = "https://github.com/example/test"
  )
  mockery::stub(approve_release, "find_staged_pr", pr)
  mockery::stub(approve_release, "gert::git_branch", "update-test-function")
  mockery::stub(approve_release, "gert::git_pull", NULL)
  git_log <- data.frame(message = "test commit\n", stringsAsFactors = FALSE)
  mockery::stub(approve_release, "gert::git_log", git_log)
  mockery::stub(approve_release, "gh::gh", "PR updated")
  mockery::stub(approve_release, "commit_build_release", NULL)

  expect_no_error(approve_release())
  expect_identical(approve_release(), pr)

  rel <- list(
    package = "testpkg",
    version = "1.2.0",
    notes = c("* Updated `test_function()` for R 4.0", "* Updated README")
  )
  mockery::stub(approve_release, "get_release", rel)
  # if PR is updated, approve_release will return the results of gh::gh
  expect_identical(approve_release(), "PR updated")

  git_log <- data.frame(message = "GitHub release 1.2.0\n", stringsAsFactors = FALSE)
  mockery::stub(approve_release, "gert::git_log", git_log)
  expect_error(
    approve_release(), "^pull request 'https://github\\.com/example/test' is already approved$"
  )

  mockery::stub(approve_release, "gert::git_branch", "add-feature-x")
  expect_error(approve_release(), "^not on PR branch 'update-test-function'$")
})

# merge_release

test_that("merge_release validates arguments", {
  mockery::stub(merge_release, "stop_uncommitted", NULL)
  mockery::stub(merge_release, "get_release", NULL)
  mockery::stub(merge_release, "gert::git_remote_info", NULL)
  mockery::stub(merge_release, "find_staged_pr", NULL)
  mockery::stub(merge_release, "gert::git_log", NULL)
  mockery::stub(merge_release, "gh::gh", NULL)
  mockery::stub(merge_release, "gert::git_branch_checkout", NULL)
  mockery::stub(merge_release, "gert::git_branch_delete", NULL)
  mockery::stub(merge_release, "gert::git_pull", NULL)
  mockery::stub(merge_release, "gert::git_tag_create", NULL)
  mockery::stub(merge_release, "gert::git_tag_push", NULL)

  expect_error(
    merge_release(pkg = "tpkg"), '^currently only merge_release\\(pkg = "\\."\\) is supported$'
  )
  expect_error(merge_release(filename = NA_character_), "'filename'")
  expect_error(merge_release(filename = ""), "'filename'")
  expect_error(merge_release(host = NA_character_), "'host'")
  expect_error(merge_release(host = ""), "'host'")
})

test_that("merge_release errors when expected and returns list", {
  # sophisticated stub for gh::gh
  gh_pull_number <- list(
    locked = FALSE, draft = FALSE, mergeable = TRUE, rebaseable = TRUE,
    html_url = "https://github.com/example/test"
  )
  gh_merge <- list(merged = TRUE)
  gh_release <- list(tag_name = "1.2.0")
  gh_delete_branch <- NULL
  gh <- function(command, ...) {
    if (command == "PUT /repos/{owner}/{repo}/pulls/{pull_number}/merge") {
      return(gh_merge)
    }
    if (command == "POST /repos/{owner}/{repo}/releases") {
      return(gh_release)
    }
    if (command == "DELETE /repos/{owner}/{repo}/git/refs/heads/{branch}") {
      return(gh_delete_branch)
    }
    stop("unknown command", call. = FALSE)
  }

  mockery::stub(merge_release, "stop_uncommitted", NULL)
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(merge_release, "get_release", rel)
  rem <- list(name = "origin", url = "https://github.com/example/test.git")
  mockery::stub(merge_release, "gert::git_remote_info", rem)
  mockery::stub(merge_release, "find_staged_pr", gh_pull_number)
  git_log <- data.frame(message = "GitHub release 1.2.0\n", stringsAsFactors = FALSE)
  mockery::stub(merge_release, "gert::git_log", git_log)
  mockery::stub(merge_release, "gh::gh", gh)
  mockery::stub(merge_release, "gert::git_branch_checkout", NULL)
  mockery::stub(merge_release, "gert::git_branch_delete", NULL)
  mockery::stub(merge_release, "gert::git_pull", NULL)
  mockery::stub(merge_release, "gert::git_tag_create", NULL)
  mockery::stub(merge_release, "gert::git_tag_push", NULL)

  mr_ret <- list(
    merge = gh("PUT /repos/{owner}/{repo}/pulls/{pull_number}/merge"),
    release = gh("POST /repos/{owner}/{repo}/releases")
  )
  expect_identical(merge_release(), mr_ret)

  gh_merge <- list(merged = FALSE)
  expect_error(merge_release(), "^pull request merge 'https://github\\.com/example/test' failed$")

  gh_pull_number$rebaseable <- FALSE
  mockery::stub(merge_release, "find_staged_pr", gh_pull_number)
  expect_error(
    merge_release(),
    "^pull request 'https://github\\.com/example/test' is not marked as rebaseable$"
  )

  gh_pull_number$mergeable <- FALSE
  mockery::stub(merge_release, "find_staged_pr", gh_pull_number)
  expect_error(
    merge_release(), "^pull request 'https://github\\.com/example/test' is not marked as mergeable$"
  )

  gh_pull_number$draft <- TRUE
  mockery::stub(merge_release, "find_staged_pr", gh_pull_number)
  expect_error(
    merge_release(), "^pull request 'https://github\\.com/example/test' is marked as draft$"
  )

  gh_pull_number$locked <- TRUE
  mockery::stub(merge_release, "find_staged_pr", gh_pull_number)
  expect_error(
    merge_release(), "^pull request 'https://github\\.com/example/test' is marked as locked$"
  )

  git_log <- data.frame(message = "test commit\n", stringsAsFactors = FALSE)
  mockery::stub(merge_release, "gert::git_log", git_log)
  expect_error(
    merge_release(), "^pull request 'https://github\\.com/example/test' is not properly approved$"
  )
})
