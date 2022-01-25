withr::local_dir("test-ci")
tmp_file <- withr::local_tempfile()

# TODO: !getOption("styler.quiet", FALSE) will also suppress output for styler
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

# TODO: set interactive() to FALSE suppress output (?)
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
