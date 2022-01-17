withr::local_dir("test-release")
pkg_test <- structure(list(
  package = "rdev", title = "R Development Tools", version = "1.0.0",
  description = "My personalized collection of development packages, tools and utility functions.",
  encoding = "UTF-8"
), class = "package")

test_that("get_release returns correct release version and notes", {
  mockery::stub(get_release, "devtools::as.package", pkg_test)
  expected_notes <- c(
    "Major update.", "", "## New Features", "", "* `feature1()`: description", "",
    "* `feature2()`: description", "", "* `feature3()`: description", "", "## Other Changes", "",
    "* Update one", "", "* Update two"
  )
  rel <- get_release()
  expect_equal(rel$version, "1.2.0")
  expect_equal(rel$notes, expected_notes)
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
