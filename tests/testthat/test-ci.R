withr::local_dir("test-ci")
tmp_file <- withr::local_tempfile()

# use with_output_sink to suppress output
style_test <- withr::with_output_sink(tmp_file, style_all())

test_that("style_all returns a tibble", {
  expect_equal(tibble::is_tibble(style_test), TRUE)
})

test_that("style_all returns the correct columns", {
  expect_equal(colnames(style_test), c("file", "changed"))
})

test_that("style_all tests R and Rmd files", {
  expect_equal(nrow(style_test), 3)
})

# use with_output_sink to suppress output
lint_test <- withr::with_output_sink(tmp_file, lint_all())

test_that("lint_all returns the correct type", {
  expect_equal(typeof(lint_test), "list")
})

test_that("lint_all returns the correct class", {
  expect_equal(class(lint_test), "lints")
})

test_that("lint_all checks all test files", {
  # snapshot captures "..." for the 3 files tested
  # use cran = FALSE and skip_on_ci() as expect_snapshot only works when tests are run interactively
  skip_on_ci()
  expect_snapshot(lint_all(), cran = FALSE)
})

# TODO: create static test package, migrate testing from test-ci to test package,
#   add snapshot tests for ci()
