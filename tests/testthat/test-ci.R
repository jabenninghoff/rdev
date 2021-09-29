style_test <- style_all("test_dir")

test_that("style_all returns a tibble", {
  expect_equal(tibble::is_tibble(style_test), TRUE)
})

test_that("style_all returns the correct columns", {
  expect_equal(colnames(style_test), c("file", "changed"))
})

test_that("style_all tests R and Rmd files", {
  expect_equal(nrow(style_test), 3)
})

lint_test <- lint_all("test_dir")

test_that("lint_all returns the correct type", {
  expect_equal(typeof(lint_test), "list")
})

test_that("lint_all returns the correct class", {
  expect_equal(class(lint_test), "lints")
})

# TODO: validate that lint_all tests all types by creating test files with linting failures
