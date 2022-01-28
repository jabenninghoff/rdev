withr::local_dir("test-ci")

# check_renv

test_that("All renv functions are called", {
  mockery::stub(check_renv, "renv::status", NULL)
  mockery::stub(check_renv, "renv::clean", NULL)
  mockery::stub(check_renv, "renv::update", NULL)

  expect_output(
    check_renv(),
    "^(?s)renv::status\\(\\)\\n\\nrenv::clean\\(\\)\\n\\nrenv::update\\(\\)$",
    perl = TRUE
  )
})

test_that("renv::update isn't run when update = FALSE", {
  mockery::stub(check_renv, "renv::status", NULL)
  mockery::stub(check_renv, "renv::clean", NULL)
  mockery::stub(check_renv, "renv::update", NULL)

  expect_output(
    check_renv(update = FALSE),
    "^(?s)renv::status\\(\\)\\n\\nrenv::clean\\(\\)$",
    perl = TRUE
  )
})

# style_all

# set styler.quiet = FALSE to suppress output
style_test <- withr::with_options(list(styler.quiet = TRUE), style_all())

test_that("style_all returns a tibble", {
  expect_equal(tibble::is_tibble(style_test), TRUE)
})

test_that("style_all returns the correct columns", {
  expect_equal(colnames(style_test), c("file", "changed"))
})

test_that("style_all tests R and Rmd files", {
  expect_equal(nrow(style_test), 3)
})

# lint_all

# testthat suppresses messages but because lintr uses interactive() to control message output, there
#   is no easy way to turn off the side-effect of ci being printed twice in the test() report,
#   see: https://github.com/r-lib/lintr/blob/master/R/lint.R
lint_test <- lint_all()

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

# ci

test_that("All renv functions are called only when parameter = TRUE", {
  mockery::stub(ci, "style_all", NULL)
  mockery::stub(ci, "lint_all", NULL)
  mockery::stub(ci, "devtools::document", NULL)
  mockery::stub(ci, "rcmdcheck::rcmdcheck", NULL)

  begin <- "^(?s)"
  end <- "$"
  sep <- "\\n\\n"
  styler <- "style_all\\(\\)"
  lintr <- "lint_all\\(\\)"
  document <- "devtools::document\\(\\)"
  rcmdcheck <- 'rcmdcheck::rcmdcheck\\(args = "--no-manual", error_on = "warning"\\)'

  # default
  expect_output(ci(), paste0(begin, document, sep, rcmdcheck, end), perl = TRUE)

  # inverse
  expect_output(
    ci(styler = TRUE, lintr = TRUE, document = FALSE, rcmdcheck = FALSE),
    paste0(begin, styler, sep, lintr, end),
    perl = TRUE
  )

  # all
  expect_output(
    ci(styler = TRUE, lintr = TRUE, document = TRUE, rcmdcheck = TRUE),
    paste0(begin, styler, sep, lintr, sep, document, sep, rcmdcheck, end),
    perl = TRUE
  )

  # none
  expect_output(ci(styler = FALSE, lintr = FALSE, document = FALSE, rcmdcheck = FALSE), NA)
})
