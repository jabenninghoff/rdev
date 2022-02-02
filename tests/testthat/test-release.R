withr::local_dir("test-release")

# new_branch

ver <- structure(list(c(1L, 0L, 0L)), class = c(
  "package_version",
  "numeric_version"
))

dev_ver <- structure(list(c(1L, 0L, 0L, 9000L)), class = c(
  "package_version",
  "numeric_version"
))

test_that("new_branch errors when local or remote branch exists", {
  g <- function(name, local = TRUE) {
    if (name == "local" & local) {
      return(TRUE)
    }
    if (name == "origin/remote" & !local) {
      return(TRUE)
    }
    FALSE
  }
  mockery::stub(new_branch, "gert::git_branch_exists", g)
  mockery::stub(new_branch, "gert::git_branch_checkout", NULL)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", ver)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", NULL)

  expect_error(new_branch("local"), "local branch exists")
  expect_error(new_branch("remote"), "branch exists on remote")
  expect_error(new_branch("test"), NA)
})

test_that("new_branch branches from default branch when current = FALSE and current when TRUE", {
  s <- function(x) {
    stop("gert::git_branch_checkout")
  }
  mockery::stub(new_branch, "gert::git_branch_exists", FALSE)
  mockery::stub(new_branch, "gert::git_branch_checkout", s)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", ver)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")

  expect_identical(new_branch("test", current = TRUE), "Bump version")
  expect_error(new_branch("test", current = FALSE), "gert::git_branch_checkout")
})

test_that("new_branch bumps non-dev version", {
  mockery::stub(new_branch, "gert::git_branch_exists", FALSE)
  mockery::stub(new_branch, "gert::git_branch_checkout", NULL)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", ver)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")

  expect_identical(new_branch("test"), "Bump version")
  expect_identical(new_branch("test", bump_ver = FALSE), NULL)
})

test_that("new_branch doesn't bump dev version", {
  mockery::stub(new_branch, "gert::git_branch_exists", FALSE)
  mockery::stub(new_branch, "gert::git_branch_checkout", NULL)
  mockery::stub(new_branch, "usethis::git_default_branch", NULL)
  mockery::stub(new_branch, "gert::git_branch_create", NULL)
  mockery::stub(new_branch, "desc::desc_get_version", dev_ver)
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")

  expect_identical(new_branch("test"), NULL)
  expect_identical(new_branch("test", bump_ver = FALSE), NULL)
})

# get_release

pkg_test <- structure(list(
  package = "testpkg", title = "R Test Package", version = "1.0.0",
  description = "A test package.",
  encoding = "UTF-8"
), class = "package")

test_that("get_release returns correct package, release version and notes", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  expected_notes <- c(
    "Major update.", "", "## New Features", "", "* `feature1()`: description", "",
    "* `feature2()`: description", "", "* `feature3()`: description", "", "## Other Changes", "",
    "* Update one", "", "* Update two"
  )
  rel <- get_release()
  expect_identical(length(rel), 3L)
  expect_identical(rel$package, "testpkg")
  expect_identical(rel$version, "1.2.0")
  expect_identical(rel$notes, expected_notes)
})

test_that("get_release returns correct package, version, and notes for first release", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  rel <- get_release(filename = "first-release.md")
  expect_identical(length(rel), 3L)
  expect_identical(rel$package, "testpkg")
  expect_identical(rel$version, "1.0.0")
  expect_identical(rel$notes, "Initial release.")
})

test_that('get_release stops when pkg != "."', {
  expect_error(
    get_release(pkg = "foo"), 'currently only build_analysis_site\\(pkg = "\\."\\) is supported'
  )
})

test_that("get_release returns error on invalid NEWS.md format", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  expect_error(get_release(filename = "empty.md"), "no valid releases found")
  expect_error(get_release(filename = "no-h1.md"), "no valid releases found")
  expect_error(get_release(filename = "bad-first-h1.md"), "unexpected header")
  expect_error(get_release(filename = "bad-first-h1-1.md"), "unexpected header")
})

test_that("get_release returns valid but non-rdev version", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)

  rel <- get_release(filename = "bad-version.md")
  expect_identical(rel$version, "1.1")
})

# stage_release

test_that('stage_release stops when pkg != "."', {
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", NULL)
  mockery::stub(stage_release, "rdev::build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(
    stage_release(pkg = "foo"), 'currently only build_analysis_site\\(pkg = "\\."\\) is supported'
  )
})

test_that("stage_release returns error on non-rdev version", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release(filename = "bad-version.md")
  mockery::stub(stage_release, "get_release", rel)
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", NULL)
  mockery::stub(stage_release, "rdev::build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(filename = "bad-version.md"), "invalid package version")
})

test_that("stage_release returns error on empty release notes", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release(filename = "bad-notes.md")
  mockery::stub(stage_release, "get_release", rel)
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", NULL)
  mockery::stub(stage_release, "rdev::build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(filename = "bad-notes.md"), "no release notes found")
})

test_that("stage_release returns error if git tag matching version exists", {
  tag_12 <- structure(list(
    name = "1.2.0", ref = "refs/tags/1.2.0",
    commit = "a7422084c6e7f89206b37bd567f66e8111e7e219"
  ), row.names = 1L, class = c(
    "tbl_df",
    "tbl", "data.frame"
  ))
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", tag_12)
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", NULL)
  mockery::stub(stage_release, "rdev::build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(), "release tag .* already exists")
})

test_that("stage_release returns error if uncommitted changes are present", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_diff_patch", c("diff --git fake/1"))
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", NULL)
  mockery::stub(stage_release, "rdev::build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(), "uncommitted changes present, aborting")
})

test_that("stage_release creates new branch", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_diff_patch", character(0))
  mockery::stub(stage_release, "gert::git_branch", "main")
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  # stub functions that change state
  g <- function(x) {
    stop(x)
  }
  mockery::stub(stage_release, "gert::git_branch_create", g)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", NULL)
  mockery::stub(stage_release, "rdev::build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(), "testpkg-120")
})

test_that("stage_release errors when on default branch before commits", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_diff_patch", character(0))
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  mockery::stub(stage_release, "gert::git_branch", "main")
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", NULL)
  mockery::stub(stage_release, "rdev::build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(), "on default branch\\. This should never happen, aborting!")
})

test_that("stage_release runs proper builder", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_diff_patch", character(0))
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  mockery::stub(stage_release, "gert::git_branch", "stage-release")
  # stub functions that change state
  analysis <- function() {
    stop("rdev::build_analysis_site")
  }
  rdev <- function() {
    stop("rdev::build_rdev_site")
  }
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", analysis)
  mockery::stub(stage_release, "rdev::build_rdev_site", rdev)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  withr::local_dir(withr::local_tempdir())
  expect_error(stage_release(), "rdev::build_rdev_site")

  fs::dir_create("pkgdown")
  base <- fs::file_create("pkgdown/_base.yml")
  writeLines("url: ~", base)
  expect_error(stage_release(), "rdev::build_analysis_site")
})

test_that("stage_release returns pull request results", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_diff_patch", character(0))
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  mockery::stub(stage_release, "gert::git_branch", "stage-release")
  rem <- list(name = "origin", url = "https://github.com/example/test.git")
  mockery::stub(stage_release, "gert::git_remote_info", rem)
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "rdev::build_analysis_site", NULL)
  mockery::stub(stage_release, "rdev::build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", "pull_request")

  expect_identical(stage_release(), "pull_request")
})

# merge_release

test_that("merge_release errors when expected", {
  # sophisticated stub for gh::gh
  gh_pulls <- list(list(title = "testpkg 1.2.0"))
  gh_pull_number <- list(
    locked = FALSE, draft = FALSE, mergeable = TRUE, rebaseable = TRUE,
    html_url = "https://github.com/example/test"
  )
  gh_merge <- list(merged = TRUE)
  gh <- function(command, ...) {
    if (command == "GET /repos/{owner}/{repo}/pulls") {
      return(gh_pulls)
    }
    if (command == "GET /repos/{owner}/{repo}/pulls/{pull_number}") {
      return(gh_pull_number)
    }
    if (command == "PUT /repos/{owner}/{repo}/pulls/{pull_number}/merge") {
      return(gh_merge)
    }
  }

  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(merge_release, "get_release", rel)
  rem <- list(name = "origin", url = "https://github.com/example/test.git")
  mockery::stub(merge_release, "gert::git_remote_info", rem)
  # stub functions that change state
  mockery::stub(merge_release, "gh::gh", gh)
  mockery::stub(merge_release, "gert::git_branch_checkout", NULL)
  mockery::stub(merge_release, "gert::git_branch_delete", NULL)
  mockery::stub(merge_release, "gert::git_pull", NULL)
  mockery::stub(merge_release, "gert::git_tag_create", NULL)
  mockery::stub(merge_release, "gert::git_tag_push", NULL)

  gh_merge <- list(merged = FALSE)
  expect_error(merge_release(), "pull request merge failed: https://github.com/example/test")

  gh_pull_number$rebaseable <- FALSE
  expect_error(
    merge_release(), "pull request is not marked as rebaseable: https://github.com/example/test"
  )

  gh_pull_number$mergeable <- FALSE
  expect_error(
    merge_release(), "pull request is not marked as mergeable: https://github.com/example/test"
  )

  gh_pull_number$draft <- TRUE
  expect_error(merge_release(), "pull request is marked as draft: https://github.com/example/test")

  gh_pull_number$locked <- TRUE
  expect_error(merge_release(), "pull request is marked as locked: https://github.com/example/test")

  gh_pulls <- list(list(title = "testpkg 1.2.0"), list(title = "testpkg 1.2.0"))
  expect_error(
    merge_release(), "found more than one pull request with the title 'testpkg 1.2.0', aborting"
  )

  gh_pulls <- list(list(title = "test PR"), list(title = "test PR 2"))
  expect_error(
    merge_release(), "found no open pull requests with the title 'testpkg 1.2.0', aborting"
  )

  expect_error(
    merge_release(pkg = "foo"), 'currently only build_analysis_site\\(pkg = "\\."\\) is supported'
  )
})

test_that("merge_release returns list", {
  # sophisticated stub for gh::gh
  gh_pulls <- list(list(title = "testpkg 1.2.0"))
  gh_pull_number <- list(
    locked = FALSE, draft = FALSE, mergeable = TRUE, rebaseable = TRUE,
    html_url = "https://github.com/example/test"
  )
  gh_merge <- list(merged = TRUE)
  gh <- function(command, ...) {
    if (command == "GET /repos/{owner}/{repo}/pulls") {
      return(gh_pulls)
    }
    if (command == "GET /repos/{owner}/{repo}/pulls/{pull_number}") {
      return(gh_pull_number)
    }
    if (command == "PUT /repos/{owner}/{repo}/pulls/{pull_number}/merge") {
      return(gh_merge)
    }
  }

  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(merge_release, "get_release", rel)
  rem <- list(name = "origin", url = "https://github.com/example/test.git")
  mockery::stub(merge_release, "gert::git_remote_info", rem)
  # stub functions that change state
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
})
