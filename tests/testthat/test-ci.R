withr::local_dir("test-ci")

# check_renv

test_that("All renv functions are called, unless set to FALSE", {
  mockery::stub(check_renv, "renv::status", NULL)
  mockery::stub(check_renv, "renv::clean", NULL)
  mockery::stub(check_renv, "renv::update", NULL)

  begin <- "^(?s)"
  end <- "$"
  sep <- "\\n\\n"
  status <- "renv::status\\(\\)"
  clean <- "renv::clean\\(\\)"
  update <- "renv::update\\(\\)"

  expect_output(
    check_renv(update = TRUE),
    paste0(begin, status, sep, clean, sep, update, end),
    perl = TRUE
  )
  expect_output(check_renv(update = FALSE), paste0(begin, status, sep, clean, end), perl = TRUE)
})

# style_all

test_that("style_all tests R and Rmd files", {
  # set styler.quiet = FALSE to suppress output
  expect_identical(nrow(withr::with_options(list(styler.quiet = TRUE), style_all())), 3L)
})

# lint_all

test_that("lint_all checks all test files", {
  # snapshot captures "..." for the 3 files tested
  # use cran = FALSE and skip_on_ci() as expect_snapshot only works when tests are run interactively
  skip_on_ci()
  expect_snapshot(lint_all(), cran = FALSE)
})

# ci

test_that("All renv functions are called according to ci logic", {
  mockery::stub(ci, "style_all", NULL)
  mockery::stub(ci, "lint_all", NULL)
  mockery::stub(ci, "gert::git_diff_patch", NULL)
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
  expect_output(
    ci(),
    paste0(begin, styler, sep, lintr, sep, document, sep, rcmdcheck, end),
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

  # uncommitted changes
  mockery::stub(ci, "gert::git_diff_patch", c("diff"))
  expect_output(
    ci(styler = NULL, lintr = TRUE, document = TRUE, rcmdcheck = TRUE),
    paste0(begin, lintr, sep, document, sep, rcmdcheck, end),
    perl = TRUE
  )

  # lints found
  mockery::stub(ci, "gert::git_diff_patch", NULL)
  mockery::stub(ci, "lint_all", list("lint"))
  expect_output(
    ci(styler = NULL, lintr = TRUE, document = TRUE, rcmdcheck = TRUE),
    paste0(begin, styler, sep, lintr, end),
    perl = TRUE
  )
})
