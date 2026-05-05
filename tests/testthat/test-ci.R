withr::local_dir("test-ci")

# print_renv_vulns

test_that("print_renv_vulns validates arguments", {
  expect_error(print_renv_vulns(silent = NA), "'silent'")
})

test_that("print_renv_vulns properly filters results", {
  no_vulns <- list(list(
    name = "curl", version = "7.1.0", type = "R", source_id = 1L,
    repo_id = 2L, licenses = list("MIT + file LICENSE"), license_types = list(
      "MIT"
    ), blocked = FALSE
  ), list(
    name = "openssl", version = "2.4.0",
    type = "R", source_id = 1L, repo_id = 2L, licenses = list(
      "MIT + file LICENSE"
    ), license_types = list("MIT"), blocked = FALSE
  ))

  all_vulns <- list(list(
    name = "gh", version = "1.4.1", type = "R", vulns = list(
      list(
        id = "RSEC-2025-0", versions = list(
          `1.1.0` = structure(list(), names = character(0)),
          `1.2.0` = structure(list(), names = character(0)),
          `1.2.1` = structure(list(), names = character(0)),
          `1.3.0` = structure(list(), names = character(0)),
          `1.3.1` = structure(list(), names = character(0)),
          `1.4.0` = structure(list(), names = character(0)),
          `1.4.1` = structure(list(), names = character(0))
        ),
        ranges = list(list(type = "ECOSYSTEM", events = list(
          list(introduced = "1.1.0"), list(fixed = "1.5.0")
        ))),
        summary = "Arbitrary Code Execution (ACE) Vulnerability",
        details = "A bug was identified in releases of the GH R package prior to version 1.5. This flaw could expose sensitive information, such as authentication tokens, through request headers during its operation if responses were cached to disk. \nWe issued a Posit Security Advisory with the 1.5 release and attributed the submitter in the release notes.\n", # nolint: line_length_linter.
        modified = "2025-08-04T20:30:50.48787Z", published = "2025-07-31T15:00:00Z"
      )
    ),
    source_id = 1L, repo_id = 2L, licenses = list("MIT + file LICENSE"),
    license_types = list("MIT"), blocked = FALSE
  ), list(
    name = "jsonlite",
    version = "1.8.7", type = "R", vulns = list(list(
      id = "RSEC-2023-3",
      versions = list(
        `0.9.12` = structure(list(), names = character(0)),
        `0.9.13` = structure(list(), names = character(0)),
        `0.9.14` = structure(list(), names = character(0)),
        `0.9.15` = structure(list(), names = character(0)),
        `0.9.16` = structure(list(), names = character(0)),
        `0.9.17` = structure(list(), names = character(0)),
        `0.9.18` = structure(list(), names = character(0)),
        `0.9.19` = structure(list(), names = character(0)),
        `0.9.20` = structure(list(), names = character(0)),
        `0.9.21` = structure(list(), names = character(0)),
        `0.9.22` = structure(list(), names = character(0)),
        `1.0` = structure(list(), names = character(0)),
        `1.1` = structure(list(), names = character(0)),
        `1.2` = structure(list(), names = character(0)),
        `1.3` = structure(list(), names = character(0)),
        `1.4` = structure(list(), names = character(0)),
        `1.5` = structure(list(), names = character(0)),
        `1.6` = structure(list(), names = character(0)),
        `1.6.1` = structure(list(), names = character(0)),
        `1.7.0` = structure(list(), names = character(0)),
        `1.7.1` = structure(list(), names = character(0)),
        `1.7.2` = structure(list(), names = character(0)),
        `1.7.3` = structure(list(), names = character(0)),
        `1.8.0` = structure(list(), names = character(0)),
        `1.8.1` = structure(list(), names = character(0)),
        `1.8.2` = structure(list(), names = character(0)),
        `1.8.3` = structure(list(), names = character(0)),
        `1.8.4` = structure(list(), names = character(0)),
        `1.8.5` = structure(list(), names = character(0)),
        `1.8.6` = structure(list(), names = character(0)),
        `1.8.7` = structure(list(), names = character(0))
      ),
      ranges = list(list(type = "ECOSYSTEM", events = list(
        list(introduced = "0.9.12"), list(fixed = "1.8.8")
      ))),
      summary = "Memory leak vulnerability", details = "The jsonlite R package is exposed to a vulnerability due to its use of yajl library version 2.1.0. The vulnerability originates from the yajl_tree_parse function within yajl. Attackers can exploit this flaw to cause a memory leak, which will result in out-of-memory in server and lead to a crash.", # nolint: line_length_linter.
      modified = "2025-05-19T19:43:48.343626Z", published = "2023-07-18T04:37:21.6Z"
    )),
    source_id = 1L, repo_id = 2L, licenses = list("MIT + file LICENSE"),
    license_types = list("MIT"), blocked = FALSE
  ))

  mixed_vulns <- c(no_vulns, all_vulns)

  mockery::stub(print_renv_vulns, "renv::vulns", no_vulns)
  expect_output(
    print_renv_vulns(), "^2 packages scanned, 0 vulnerable:\\\n\\[\\]$"
  )
  expect_length(print_renv_vulns(silent = TRUE), 0)

  mockery::stub(print_renv_vulns, "renv::vulns", all_vulns)
  expect_output(
    print_renv_vulns(), "^2 packages scanned, 2 vulnerable:\\\n"
  )
  expect_length(print_renv_vulns(silent = TRUE), 2)

  mockery::stub(print_renv_vulns, "renv::vulns", mixed_vulns)
  expect_output(
    print_renv_vulns(), "^4 packages scanned, 2 vulnerable:\\\n"
  )
  expect_length(print_renv_vulns(silent = TRUE), 2)
})

# check_renv

test_that("check_renv validates arguments", {
  mockery::stub(check_renv, "renv::status", NULL)
  mockery::stub(check_renv, "renv::clean", NULL)
  mockery::stub(check_renv, "print_renv_vulns", NULL)
  mockery::stub(check_renv, "renv::update", NULL)

  expect_error(check_renv(update = NA), "'update'")
})

test_that("All renv functions are called, unless set to FALSE", {
  mockery::stub(check_renv, "renv::status", NULL)
  mockery::stub(check_renv, "renv::clean", NULL)
  mockery::stub(check_renv, "print_renv_vulns", NULL)
  mockery::stub(check_renv, "renv::update", NULL)

  begin <- "^"
  end <- "$"
  sep <- "\\n\\n"
  status <- "renv::status\\(\\)"
  vulns <- 'renv::vulns\\(repos = "https://packagemanager.posit.co/cran/latest"\\)'
  clean <- "renv::clean\\(\\)"
  update <- "renv::update\\(\\)"

  expect_output(
    check_renv(update = TRUE), paste0(begin, status, sep, clean, sep, vulns, sep, update, end)
  )
  expect_output(
    check_renv(update = FALSE), paste0(begin, status, sep, clean, sep, vulns, end)
  )
})

# style_all

test_that("style_all tests all file types", {
  # test files include renv/test.R, packrat/test.R, and R/RcppExports.R which should be excluded
  # set styler.quiet = TRUE to suppress output
  expect_identical(nrow(withr::with_options(list(styler.quiet = TRUE), style_all())), 7L)
})

# lint_all

test_that("lint_all checks all file types", {
  # test files include renv/test.R, packrat/test.R, and R/RcppExports.R which should be excluded
  all_files <- c(
    "test-revealjs.qmd", "test.Rrst", "test.Rtex", "test.Rtxt", "testcode.Rhtml", "testcode.Rmd",
    "testcode.Rnw", "testcode.Rpres", "testcode.qmd", "testcode_1.R", "testcode_2.R"
  )
  withr::local_options(lintr.linter_file = "lintr_test_config")
  expect_named(lint_all(), all_files)
})

# ci

test_that("ci validates arguments", {
  mockery::stub(ci, "renv::status", NULL)
  mockery::stub(ci, "print_renv_vulns", NULL)
  mockery::stub(ci, "missing_deps", NULL)
  mockery::stub(ci, "fs::file_exists", NULL)
  mockery::stub(ci, "pkgdown::check_pkgdown", NULL)
  mockery::stub(ci, "style_all", NULL)
  mockery::stub(ci, "lint_all", NULL)
  mockery::stub(ci, "gert::git_status", NULL)
  mockery::stub(ci, "devtools::document", NULL)
  mockery::stub(ci, "desc::desc_normalize", NULL)
  mockery::stub(ci, "print_tbl", NULL)
  mockery::stub(ci, "extra_deps", NULL)
  mockery::stub(ci, "spelling::update_wordlist", NULL)
  mockery::stub(ci, "update_wordlist_notebooks", NULL)
  mockery::stub(ci, "url_check", NULL)
  mockery::stub(ci, "html_url_check", NULL)
  mockery::stub(ci, "rcmdcheck::rcmdcheck", NULL)

  expect_error(ci(renv = NA), "'renv'")
  expect_error(ci(missing = NA), "'missing'")
  expect_error(ci(pkgdown = NA), "'pkgdown'")
  expect_error(ci(styler = NA), "'styler'")
  expect_error(ci(lintr = NA), "'lintr'")
  expect_error(ci(document = NA), "'document'")
  expect_error(ci(normalize = NA), "'normalize'")
  expect_error(ci(extra = NA), "'extra'")
  expect_error(ci(spelling = NA), "'spelling'")
  expect_error(ci(urls = NA), "'urls'")
  expect_error(ci(rcmdcheck = NA), "'rcmdcheck'")
})

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
  mockery::stub(ci, "print_renv_vulns", NULL)
  mockery::stub(ci, "missing_deps", missing_deps_empty)
  mockery::stub(ci, "fs::file_exists", TRUE)
  mockery::stub(ci, "pkgdown::check_pkgdown", NULL)
  mockery::stub(ci, "style_all", NULL)
  mockery::stub(ci, "lint_all", NULL)
  mockery::stub(ci, "gert::git_status", git_status_empty)
  mockery::stub(ci, "devtools::document", NULL)
  mockery::stub(ci, "desc::desc_normalize", NULL)
  mockery::stub(ci, "print_tbl", NULL)
  mockery::stub(ci, "extra_deps", NULL)
  mockery::stub(ci, "spelling::update_wordlist", NULL)
  mockery::stub(ci, "update_wordlist_notebooks", NULL)
  mockery::stub(ci, "url_check", NULL)
  mockery::stub(ci, "html_url_check", NULL)
  mockery::stub(ci, "rcmdcheck::rcmdcheck", NULL)

  begin <- "^"
  end <- "$"
  sep <- "\\n\\n"
  renv_status <- "renv::status\\(\\)"
  renv_vulns <- 'renv::vulns\\(repos = "https://packagemanager\\.posit\\.co/cran/latest"\\)'
  renv <- paste0(renv_status, sep, renv_vulns)
  missing <- "missing_deps\\(\\)"
  pkgdown <- "pkgdown::check_pkgdown\\(\\)"
  styler <- "style_all\\(\\)"
  lintr <- "lint_all\\(\\)"
  document <- "devtools::document\\(\\)"
  normalize <- "desc::desc_normalize\\(\\)"
  extra <- "extra_deps\\(\\)"
  spelling <- "spelling::update_wordlist\\(\\)"
  spelling_analysis <- "update_wordlist_notebooks\\(\\)"
  urls <- "url_check\\((\\))\nhtml_url_check\\(\\)"
  rcmdcheck <- paste0(
    'Setting env vars: NOT_CRAN="true", CI="true"\\n',
    'rcmdcheck::rcmdcheck\\(args = "--no-manual", error_on = "warning"\\)'
  )

  # spelling package types
  mockery::stub(ci, "package_type", "analysis")
  expect_output(
    ci(
      renv = FALSE, missing = FALSE, pkgdown = FALSE, styler = FALSE, lintr = FALSE,
      document = FALSE, normalize = FALSE, extra = FALSE, spelling = TRUE, urls = FALSE,
      rcmdcheck = FALSE
    ), spelling_analysis
  )
  mockery::stub(ci, "package_type", "rdev")
  expect_output(
    ci(
      renv = FALSE, missing = FALSE, pkgdown = FALSE, styler = FALSE, lintr = FALSE,
      document = FALSE, normalize = FALSE, extra = FALSE, spelling = TRUE, urls = FALSE,
      rcmdcheck = FALSE
    ), spelling
  )

  # default
  expect_output(
    ci(),
    paste0(
      begin, renv, sep, missing, sep, pkgdown, sep, styler, sep, lintr, sep, document, sep,
      normalize, sep, extra, sep, spelling, sep, urls, sep, rcmdcheck, end
    )
  )

  # all
  expect_output(
    ci(
      renv = TRUE, missing = TRUE, pkgdown = TRUE, styler = TRUE, lintr = TRUE, document = TRUE,
      normalize = TRUE, extra = TRUE, spelling = TRUE, urls = TRUE, rcmdcheck = TRUE
    ),
    paste0(
      begin, renv, sep, missing, sep, pkgdown, sep, styler, sep, lintr, sep, document, sep,
      normalize, sep, extra, sep, spelling, sep, urls, sep, rcmdcheck, end
    )
  )

  # none
  expect_output(
    ci(
      renv = FALSE, missing = FALSE, pkgdown = FALSE, styler = FALSE, lintr = FALSE,
      document = FALSE, normalize = FALSE, extra = FALSE, spelling = FALSE, urls = FALSE,
      rcmdcheck = FALSE
    ), NA
  )

  # uncommitted changes
  mockery::stub(ci, "gert::git_status", git_status_changed)
  expect_output(
    ci(
      renv = TRUE, missing = TRUE, pkgdown = TRUE, styler = NULL, lintr = TRUE, document = TRUE,
      normalize = TRUE, extra = TRUE, spelling = TRUE, urls = TRUE, rcmdcheck = TRUE
    ),
    paste0(
      begin, renv, sep, missing, sep, pkgdown, sep, lintr, sep, document, sep, normalize, sep,
      extra, sep, spelling, sep, urls, sep, rcmdcheck, end
    )
  )

  # lints found
  mockery::stub(ci, "gert::git_status", git_status_empty)
  mockery::stub(ci, "lint_all", list("lint"))
  expect_output(
    ci(
      renv = TRUE, missing = TRUE, pkgdown = TRUE, styler = NULL, lintr = TRUE, document = TRUE,
      normalize = TRUE, extra = TRUE, spelling = TRUE, urls = TRUE, rcmdcheck = TRUE
    ),
    paste0(begin, renv, sep, missing, sep, pkgdown, sep, styler, sep, lintr, end)
  )

  # no _pkgdown.yml
  mockery::stub(ci, "fs::file_exists", FALSE)
  expect_output(
    ci(
      renv = TRUE, missing = TRUE, pkgdown = TRUE, styler = NULL, lintr = TRUE, document = TRUE,
      normalize = TRUE, extra = TRUE, spelling = TRUE, urls = TRUE, rcmdcheck = TRUE
    ),
    paste0(begin, renv, sep, missing, sep, styler, sep, lintr, end)
  )

  # missing dependencies
  mockery::stub(ci, "missing_deps", missing_deps_missing)
  expect_output(
    ci(
      renv = TRUE, missing = TRUE, pkgdown = TRUE, styler = NULL, lintr = TRUE, document = TRUE,
      normalize = TRUE, extra = TRUE, spelling = TRUE, urls = TRUE, rcmdcheck = TRUE
    ),
    paste0(begin, renv, sep, missing, end)
  )

  # renv not synchronized
  mockery::stub(ci, "renv::status", renv_sync_false)
  expect_output(
    ci(
      renv = TRUE, missing = TRUE, pkgdown = TRUE, styler = NULL, lintr = TRUE, document = TRUE,
      normalize = TRUE, extra = TRUE, spelling = TRUE, urls = TRUE, rcmdcheck = TRUE
    ),
    paste0(begin, renv_status, end)
  )
})
