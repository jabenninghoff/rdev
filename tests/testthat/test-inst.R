test_that("inst/templates match rdev package locally", {
  skip_on_ci()
  skip_on_cran()
  skip_on_covr()
  withr::local_dir("../..")

  expect_identical(readLines("inst/templates/lintr"), readLines(".lintr"))
  expect_identical(readLines("inst/templates/spelling.R"), readLines("tests/spelling.R"))
  expect_identical(readLines("inst/templates/pre-commit"), readLines(".git/hooks/pre-commit"))
  expect_identical(
    readLines("inst/templates/test-spelling.R"), readLines("tests/testthat/test-spelling.R")
  )

  rp <- readLines("inst/templates/Rprofile")
  rp <- rp[!grepl("suppressMessages(require(rdev))", rp, fixed = TRUE)]
  expect_identical(rp, readLines(".Rprofile"))
})
