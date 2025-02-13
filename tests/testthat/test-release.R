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
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", NULL)
  mockery::stub(new_branch, "gert::git_status", NULL)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
  mockery::stub(new_branch, "gert::git_stash_pop", NULL)

  expect_error(new_branch(name = NA_character_), "'name'")
  expect_error(new_branch(name = ""), "'name'")
  expect_error(new_branch("test", bump_ver = NA), "'bump_ver'")
  expect_error(new_branch("test", current = NA), "'current'")
})

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
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
  mockery::stub(new_branch, "gert::git_stash_pop", NULL)

  expect_error(new_branch("local"), "^local branch exists$")
  expect_error(new_branch("remote"), "^branch exists on remote \\(origin/remote\\)$")
  expect_error(new_branch("test"), NA)
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
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
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
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
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
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(new_branch, "gert::git_stash_save", NULL)
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
  mockery::stub(new_branch, "desc::desc_bump_version", NULL)
  mockery::stub(new_branch, "gert::git_add", NULL)
  mockery::stub(new_branch, "gert::git_commit", "Bump version")
  mockery::stub(new_branch, "gert::git_status", git_status_empty)
  mockery::stub(
    new_branch, "gert::git_stash_save", function() stop("git_stash_save", call. = FALSE)
  )
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

test_that("get_release validates arguments", {
  expect_error(
    get_release(pkg = "tpkg"), '^currently only get_release\\(pkg = "\\."\\) is supported$'
  )
  expect_error(get_release(filename = NA_character_), "'filename'")
  expect_error(get_release(filename = ""), "'filename'")
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

# stage_release

test_that("stage_release validates arguments", {
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "build_analysis_site", NULL)
  mockery::stub(stage_release, "build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(
    stage_release(pkg = "tpkg"), '^currently only stage_release\\(pkg = "\\."\\) is supported$'
  )
  expect_error(stage_release(filename = NA_character_), "'filename'")
  expect_error(stage_release(filename = ""), "'filename'")
  expect_error(stage_release(unfreeze = NA), "'unfreeze'")
  expect_error(stage_release(host = NA_character_), "'host'")
  expect_error(stage_release(host = ""), "'host'")
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
  mockery::stub(stage_release, "build_analysis_site", NULL)
  mockery::stub(stage_release, "build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(filename = "bad-version.md"), "^invalid package version '1\\.1'$")
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
  mockery::stub(stage_release, "build_analysis_site", NULL)
  mockery::stub(stage_release, "build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(filename = "bad-notes.md"), "^no release notes found$")
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
  mockery::stub(stage_release, "build_analysis_site", NULL)
  mockery::stub(stage_release, "build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(), "^release tag '1\\.2\\.0' already exists$")
})

test_that("stage_release returns error if uncommitted changes are present", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_status", git_status_changed)
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "build_analysis_site", NULL)
  mockery::stub(stage_release, "build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(), "^uncommitted changes present$")
})

test_that("stage_release creates new branch", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_status", git_status_empty)
  mockery::stub(stage_release, "gert::git_branch", "main")
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  # stub functions that change state
  g <- function(x) {
    stop(x, call. = FALSE)
  }
  mockery::stub(stage_release, "gert::git_branch_create", g)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "build_analysis_site", NULL)
  mockery::stub(stage_release, "build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(), "^testpkg-120$")
})

test_that("stage_release errors when on default branch before commits", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_status", git_status_empty)
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  mockery::stub(stage_release, "gert::git_branch", "main")
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "build_analysis_site", NULL)
  mockery::stub(stage_release, "build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  expect_error(stage_release(), "^on default branch \\(this should never happen\\)$")
})

test_that("stage_release runs proper builder", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_status", git_status_empty)
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  mockery::stub(stage_release, "gert::git_branch", "stage-release")
  mockery::stub(stage_release, "gert::git_remote_info", NULL)
  mockery::stub(stage_release, "remotes::parse_github_url", NULL)
  # stub functions that change state
  analysis <- function() {
    stop("build_analysis_site", call. = FALSE)
  }
  quarto <- function(unfreeze = TRUE) {
    stop("build_quarto_site", call. = FALSE)
  }
  rdev <- function() {
    stop("build_rdev_site", call. = FALSE)
  }
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "build_analysis_site", analysis)
  mockery::stub(stage_release, "build_quarto_site", quarto)
  mockery::stub(stage_release, "build_rdev_site", rdev)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", NULL)

  withr::local_dir(withr::local_tempdir())
  expect_error(stage_release(), "^could not determine builder type$")

  pkgdown <- fs::file_create("_pkgdown.yml")
  writeLines("url: ~", pkgdown)
  expect_error(stage_release(), "^build_rdev_site$")

  fs::dir_create("pkgdown")
  base <- fs::file_create("pkgdown/_base.yml")
  writeLines("url: ~", base)
  expect_error(stage_release(), "^build_analysis_site$")

  fs::file_create("_quarto.yml")
  expect_error(stage_release(), "^build_quarto_site$")
})

test_that("stage_release returns pull request results", {
  no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_status", git_status_empty)
  mockery::stub(stage_release, "usethis::git_default_branch", "main")
  mockery::stub(stage_release, "gert::git_branch", "stage-release")
  rem <- list(name = "origin", url = "https://github.com/example/test.git")
  mockery::stub(stage_release, "gert::git_remote_info", rem)
  # stub functions that change state
  mockery::stub(stage_release, "gert::git_branch_create", NULL)
  mockery::stub(stage_release, "desc::desc_set_version", NULL)
  mockery::stub(stage_release, "gert::git_add", NULL)
  mockery::stub(stage_release, "gert::git_commit", NULL)
  mockery::stub(stage_release, "build_analysis_site", NULL)
  mockery::stub(stage_release, "build_quarto_site", NULL)
  mockery::stub(stage_release, "build_rdev_site", NULL)
  mockery::stub(stage_release, "gert::git_push", NULL)
  mockery::stub(stage_release, "gh::gh", "pull_request")

  withr::local_dir(withr::local_tempdir())
  fs::file_create("_quarto.yml")

  expect_identical(stage_release(), "pull_request")
})

# merge_release

test_that("merge_release errors when expected and returns list", {
  # sophisticated stub for gh::gh
  gh_pulls <- list(list(title = "testpkg 1.2.0"))
  gh_pull_number <- list(
    locked = FALSE, draft = FALSE, mergeable = TRUE, rebaseable = TRUE,
    html_url = "https://github.com/example/test"
  )
  gh_merge <- list(merged = TRUE)
  gh_release <- list(tag_name = "1.2.0")
  gh_delete_branch <- NULL
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
    if (command == "POST /repos/{owner}/{repo}/releases") {
      return(gh_release)
    }
    if (command == "DELETE /repos/{owner}/{repo}/git/refs/heads/{branch}") {
      return(gh_delete_branch)
    }
    stop("unknown command", call. = FALSE)
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

  gh_merge <- list(merged = FALSE)
  expect_error(merge_release(), "^pull request merge 'https://github\\.com/example/test' failed$")

  gh_pull_number$rebaseable <- FALSE
  expect_error(
    merge_release(),
    "^pull request 'https://github\\.com/example/test' is not marked as rebaseable$"
  )

  gh_pull_number$mergeable <- FALSE
  expect_error(
    merge_release(), "^pull request 'https://github\\.com/example/test' is not marked as mergeable$"
  )

  gh_pull_number$draft <- TRUE
  expect_error(
    merge_release(), "^pull request 'https://github\\.com/example/test' is marked as draft$"
  )

  gh_pull_number$locked <- TRUE
  expect_error(
    merge_release(), "^pull request 'https://github\\.com/example/test' is marked as locked$"
  )

  gh_pulls <- list(list(title = "testpkg 1.2.0"), list(title = "testpkg 1.2.0"))
  expect_error(
    merge_release(), "^found more than one pull request with the title 'testpkg 1\\.2\\.0'$"
  )

  gh_pulls <- list(list(title = "test PR"), list(title = "test PR 2"))
  expect_error(
    merge_release(), "^found no open pull requests with the title 'testpkg 1\\.2\\.0'$"
  )

  expect_error(
    merge_release(pkg = "tpkg"), '^currently only merge_release\\(pkg = "\\."\\) is supported$'
  )
})

test_that("merge_release validates arguments", {
  mockery::stub(merge_release, "get_release", NULL)
  mockery::stub(merge_release, "gert::git_remote_info", NULL)
  mockery::stub(merge_release, "remotes::parse_github_url", NULL)
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
