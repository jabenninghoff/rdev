withr::local_dir("test-ci")

# check_renv

test_that("All renv functions are called, unless set to FALSE", {
  mockery::stub(check_renv, "renv::status", NULL)
  mockery::stub(check_renv, "renv::clean", NULL)
  mockery::stub(check_renv, "renv::update", NULL)

  begin <- "^"
  end <- "$"
  sep <- "\\n\\n"
  status <- "renv::status\\(\\)"
  clean <- "renv::clean\\(\\)"
  update <- "renv::update\\(\\)"

  expect_output(check_renv(update = TRUE), paste0(begin, status, sep, clean, sep, update, end))
  expect_output(check_renv(update = FALSE), paste0(begin, status, sep, clean, end))
})

# style_all

test_that("style_all tests all file types", {
  # set styler.quiet = FALSE to suppress output
  expect_identical(nrow(withr::with_options(list(styler.quiet = TRUE), style_all())), 5L)
})

# lint_all

test_that("lint_all checks all file types", {
  # snapshot captures "........." for the 9 files tested
  # use cran = FALSE and skip_on_ci() as expect_snapshot only works when tests are run interactively
  # set TESTTHAT=false to un-silence lintr, see
  #   https://github.com/r-lib/lintr/commit/74f1e9d2886c4bd06f52bd2510e939eac644065a
  # TODO: rewrite this to detect specific lints, like lintr
  skip_on_ci()
  withr::with_envvar(new = c(TESTTHAT = "false"), expect_snapshot(lint_all(), cran = FALSE))
})

# ci

test_that("All renv functions are called according to ci logic", {
  renv_sync_true <- list(library = list(), lockfile = list(), synchronized = TRUE)
  renv_sync_false <- list(library = list(), lockfile = list(), synchronized = FALSE)
  missing_deps_empty <- structure(
    list(
      Source = character(0), Package = character(0), Require = character(0),
      Version = character(0), Dev = logical(0)
    ),
    row.names = integer(0), class = "data.frame"
  )
  missing_deps_missing <- structure(
    list(Source = "R/missing.R", Package = "missing", Require = "", Version = "", Dev = FALSE),
    row.names = 88L, class = "data.frame"
  )
  git_status_empty <- structure(
    list(file = character(0), status = character(0), staged = logical(0)),
    row.names = integer(0), class = c("tbl_df", "tbl", "data.frame")
  )
  git_status_changed <- structure(
    list(file = "test", status = "new", staged = FALSE),
    row.names = c(NA, -1L), class = c("tbl_df", "tbl", "data.frame")
  )
  mockery::stub(ci, "renv::status", renv_sync_true)
  mockery::stub(ci, "missing_deps", missing_deps_empty)
  mockery::stub(ci, "style_all", NULL)
  mockery::stub(ci, "lint_all", NULL)
  mockery::stub(ci, "gert::git_status", git_status_empty)
  mockery::stub(ci, "devtools::document", NULL)
  mockery::stub(ci, "desc::desc_normalize", NULL)
  mockery::stub(ci, "rcmdcheck::rcmdcheck", NULL)
  mockery::stub(ci, "print_tbl", NULL)
  mockery::stub(ci, "extra_deps", NULL)
  mockery::stub(ci, "url_check", NULL)
  mockery::stub(ci, "html_url_check", NULL)

  begin <- "^"
  end <- "$"
  sep <- "\\n\\n"
  renv <- "renv::status\\(\\)"
  missing <- "missing_deps\\(\\)"
  styler <- "style_all\\(\\)"
  lintr <- "lint_all\\(\\)"
  document <- "devtools::document\\(\\)"
  normalize <- "desc::desc_normalize\\(\\)"
  rcmdcheck <- paste0(
    'Setting env vars: NOT_CRAN="true", CI="true"\\n',
    'rcmdcheck::rcmdcheck\\(args = "--no-manual", error_on = "warning"\\)'
  )
  extra <- "extra_deps\\(\\)"
  urls <- "url_check\\((\\))\nhtml_url_check\\(\\)"

  # default
  expect_output(
    ci(),
    paste0(
      begin, renv, sep, missing, sep, styler, sep, lintr, sep, document, sep, normalize, sep,
      rcmdcheck, "\\n", extra, sep, urls, end
    )
  )

  # all
  expect_output(
    ci(
      renv = TRUE, styler = TRUE, lintr = TRUE, document = TRUE, normalize = TRUE, rcmdcheck = TRUE,
      missing = TRUE, extra = TRUE, urls = TRUE
    ),
    paste0(
      begin, renv, sep, missing, sep, styler, sep, lintr, sep, document, sep, normalize, sep,
      rcmdcheck, "\\n", extra, sep, urls, end
    )
  )

  # none
  expect_output(
    ci(
      renv = FALSE, styler = FALSE, lintr = FALSE, document = FALSE, normalize = FALSE,
      rcmdcheck = FALSE, missing = FALSE, extra = FALSE, urls = FALSE
    ), NA
  )

  # uncommitted changes
  mockery::stub(ci, "gert::git_status", git_status_changed)
  expect_output(
    ci(
      renv = TRUE, styler = NULL, lintr = TRUE, document = TRUE, normalize = TRUE, rcmdcheck = TRUE,
      missing = TRUE, extra = TRUE, urls = TRUE
    ),
    paste0(
      begin, renv, sep, missing, sep, lintr, sep, document, sep, normalize, sep, rcmdcheck, "\\n",
      extra, sep, urls, end
    )
  )

  # lints found
  mockery::stub(ci, "gert::git_status", git_status_empty)
  mockery::stub(ci, "lint_all", list("lint"))
  expect_output(
    ci(
      renv = TRUE, styler = NULL, lintr = TRUE, document = TRUE, normalize = TRUE, rcmdcheck = TRUE,
      missing = TRUE, extra = TRUE, urls = TRUE
    ),
    paste0(begin, renv, sep, missing, sep, styler, sep, lintr, end)
  )

  # missing dependencies
  mockery::stub(ci, "missing_deps", missing_deps_missing)
  expect_output(
    ci(
      renv = TRUE, styler = NULL, lintr = TRUE, document = TRUE, normalize = TRUE, rcmdcheck = TRUE,
      missing = TRUE, extra = TRUE, urls = TRUE
    ),
    paste0(begin, renv, sep, missing, end)
  )

  # renv not synchronized
  mockery::stub(ci, "renv::status", renv_sync_false)
  expect_output(
    ci(
      renv = TRUE, styler = NULL, lintr = TRUE, document = TRUE, normalize = TRUE, rcmdcheck = TRUE,
      missing = TRUE, extra = TRUE, urls = TRUE
    ),
    paste0(begin, renv, end)
  )
})
