withr::local_dir("test-release")
pkg_test <- structure(list(
  package = "rdev", title = "R Development Tools", version = "1.0.0",
  description = "My personalized collection of development packages, tools and utility functions.",
  encoding = "UTF-8"
), class = "package")

# get_release

test_that("get_release returns correct package, release version and notes", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  expected_notes <- c(
    "Major update.", "", "## New Features", "", "* `feature1()`: description", "",
    "* `feature2()`: description", "", "* `feature3()`: description", "", "## Other Changes", "",
    "* Update one", "", "* Update two"
  )
  rel <- get_release()
  expect_equal(length(rel), 3)
  expect_equal(rel$package, "rdev")
  expect_equal(rel$version, "1.2.0")
  expect_equal(rel$notes, expected_notes)
})

test_that("get_release returns correct package, version, and notes for first release", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release(filename = "first-release.md")
  expect_equal(length(rel), 3)
  expect_equal(rel$package, "rdev")
  expect_equal(rel$version, "1.0.0")
  expect_equal(rel$notes, "Initial release.")
})

test_that('get_release stops when pkg != "."', {
  expect_error(
    get_release(pkg = "foo"),
    regexp = 'currently only build_analysis_site\\(pkg = "\\."\\) is supported'
  )
})

test_that("get_release returns error on invalid NEWS.md format", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  expect_error(get_release(filename = "empty.md"), regexp = "no valid releases found")
  expect_error(get_release(filename = "no-h1.md"), regexp = "no valid releases found")
  expect_error(get_release(filename = "bad-first-h1.md"), regexp = "unexpected header")
  expect_error(get_release(filename = "bad-first-h1-1.md"), regexp = "unexpected header")
})

test_that("get_release returns valid but non-rdev version", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release(filename = "bad-version.md")
  expect_equal(rel$version, "1.1")
})

# stage_release

test_that('stage_release stops when pkg != "."', {
  expect_error(
    stage_release(pkg = "foo"),
    regexp = 'currently only build_analysis_site\\(pkg = "\\."\\) is supported'
  )
})

test_that("stage_release returns error on non-rdev version", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release(filename = "bad-version.md")
  mockery::stub(stage_release, "get_release", rel)
  expect_error(stage_release(filename = "bad-version.md"), regexp = "invalid package version")
})

test_that("stage_release returns error on empty release notes", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release(filename = "bad-notes.md")
  mockery::stub(stage_release, "get_release", rel)
  expect_error(stage_release(filename = "bad-notes.md"), regexp = "no release notes found")
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
  expect_error(stage_release(), regexp = "release tag .* already exists")
})

no_tags <- structure(list(name = character(0), ref = character(0), commit = character(0)),
  row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
)

test_that("stage_release returns error if uncommitted changes are present", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  rel <- get_release()
  mockery::stub(stage_release, "get_release", rel)
  mockery::stub(stage_release, "gert::git_tag_list", no_tags)
  mockery::stub(stage_release, "gert::git_diff_patch", c("diff --git fake/1"))
  expect_error(stage_release(), regexp = "uncommitted changes present, aborting")
})
