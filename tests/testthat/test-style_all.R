# these tests currently run against the files in tests/testthat : this is potentially dangerous
# and should be changed - see https://r-pkgs.org/tests.html
test_that("returns a tibble", {
  expect_equal(tibble::is_tibble(style_all()), TRUE)
})

test_that("returns the correct columns", {
  expect_equal(colnames(style_all()), c("file", "changed"))
})
