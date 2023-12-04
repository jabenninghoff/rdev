# sort_file

test_that("sort_file validates arguments", {
  expect_error(sort_file(NA_character_), "'filename'")
})

test_that("sort_file errors when file does not exist", {
  expect_error(sort_file("nonexistant"), "^cannot sort file, 'nonexistant': no such file$")
})

test_that("sort_file sorts a file", {
  tmp_file <- withr::local_tempfile()

  strings <- stringi::stri_rand_strings(10, 10)
  writeLines(strings, tmp_file)
  sort_file(tmp_file)

  expect_identical(readLines(tmp_file), sort(strings))
})

# sort_rbuildignore

test_that("sort_rbuildignore errors when file does not exist", {
  expect_error(sort_rbuildignore(), "^cannot sort file, '.Rbuildignore': no such file$")
})

test_that("sort_rbuildignore sorts .Rbuildignore", {
  withr::local_dir(withr::local_tempdir())
  withr::local_file(".Rbuildignore")

  strings <- stringi::stri_rand_strings(10, 10)
  writeLines(strings, ".Rbuildignore")
  sort_rbuildignore()

  expect_identical(readLines(".Rbuildignore"), sort(strings))
})

# spell_check_notebooks

test_that("spell_check_notebooks validates arguments", {
  withr::local_dir(withr::local_tempdir())

  expect_error(spell_check_notebooks(path = NA_character_), "'path'")
  expect_error(spell_check_notebooks(glob = NA_character_), "'glob'")
  expect_error(spell_check_notebooks(use_wordlist = NA), "'use_wordlist'")
  expect_error(spell_check_notebooks(lang = NA_character_), "'lang'")
})

test_that("spell_check_notebooks logic flows work", {
  withr::local_dir(withr::local_tempdir())
  fs::dir_create("inst")
  writeLines("spelltest", "inst/WORDLIST")
  writeLines("Package: test\nLanguage: en-US", "DESCRIPTION")

  expect_error(spell_check_notebooks(), "^'analysis' directory not found$")
  expect_error(spell_check_notebooks(path = "testdir"), "^'testdir' directory not found$")

  fs::dir_create("analysis")
  expect_length(spell_check_notebooks()$found, 0)

  writeLines(c("spelltest", "valid US English words"), "analysis/test.Rmd")
  expect_length(spell_check_notebooks()$found, 0)
  expect_length(spell_check_notebooks(use_wordlist = FALSE)$found, 1)

  fs::file_delete("inst/WORDLIST")
  expect_length(spell_check_notebooks()$found, 1)
  expect_length(spell_check_notebooks(use_wordlist = FALSE)$found, 1)
  expect_length(spell_check_notebooks(glob = "*.tmp")$found, 0)
  expect_length(spell_check_notebooks(glob = "*.Rmd")$found, 1)

  writeLines("Package: test", "DESCRIPTION")
  expect_error(spell_check_notebooks(), "^Field 'Language' not found$")

  fs::file_delete("DESCRIPTION")
  expect_error(spell_check_notebooks(), "^DESCRIPTION not found$")
  expect_length(spell_check_notebooks(lang = "en_US")$found, 1)
})

# deps_check

test_that("deps_check validates arguments", {
  mockery::stub(deps_check, "renv::dependencies", NULL)
  mockery::stub(deps_check, "desc::desc_get_deps", NULL)

  expect_error(deps_check("badtype"), "'badtype'")
  expect_error(deps_check("missing", exclude_base = NA), "'exclude_base'")
})

test_that("deps_check finds correct missing and extra deps", {
  # nolint start: absolute_path_linter.
  renv_dependencies <- as.data.frame(tibble::tribble(
    ~Source, ~Package, ~Require, ~Version, ~Dev,
    "/Users/test/pkg/DESCRIPTION", "desc_only_1", "", "", FALSE,
    "/Users/test/pkg/DESCRIPTION", "desc_only_2", "", "", FALSE,
    "/Users/test/pkg/DESCRIPTION", "desc_source_1", "", "", FALSE,
    "/Users/test/pkg/R/function_1.R", "desc_source_1", "", "", FALSE,
    "/Users/test/pkg/DESCRIPTION", "desc_source_2", "", "", FALSE,
    "/Users/test/pkg/tests/test.R", "desc_source_2", "", "", FALSE,
    "/Users/test/pkg/R/function_1.R", "source_only_1", "", "", FALSE,
    "/Users/test/pkg/tests/test.R", "source_only_2", "", "", FALSE,
    # base packages loaded at startup
    "/Users/test/pkg/R/function_1.R", "base", "", "", FALSE,
    "/Users/test/pkg/tests/test.R", "utils", "", "", FALSE,
    # base packages loaded later
    "/Users/test/pkg/R/function_1.R", "grDevices", "", "", FALSE,
    "/Users/test/pkg/tests/test.R", "stats", "", "", FALSE,
    # always ignore pkg and renv
    "/Users/test/pkg/renv.lock", "renv", "", "", FALSE,
    "/Users/test/pkg/tests/test.R", "pkg", "", "", FALSE
  ))

  desc_desc_get_deps <- as.data.frame(tibble::tribble(
    ~type, ~package, ~version,
    "Imports", "desc_only_1", "*",
    "Suggests", "desc_only_2", "*",
    "Imports", "desc_source_1", "*",
    "Suggests", "desc_source_2", "*"
  ))

  extras <- structure(
    list(
      type = c("Imports", "Suggests"),
      package = c("desc_only_1", "desc_only_2"),
      version = c("*", "*")
    ),
    row.names = 1:2,
    class = "data.frame"
  )

  missing <- structure(
    list(
      Source = c("/Users/test/pkg/R/function_1.R", "/Users/test/pkg/tests/test.R"),
      Package = c("source_only_1", "source_only_2"),
      Require = c("", ""),
      Version = c("", ""),
      Dev = c(FALSE, FALSE)
    ),
    row.names = 7:8,
    class = "data.frame"
  )

  missing_withbase <- structure(
    list(
      Source = c(
        "/Users/test/pkg/R/function_1.R", "/Users/test/pkg/tests/test.R",
        "/Users/test/pkg/R/function_1.R", "/Users/test/pkg/tests/test.R",
        "/Users/test/pkg/R/function_1.R", "/Users/test/pkg/tests/test.R"
      ),
      Package = c("source_only_1", "source_only_2", "base", "utils", "grDevices", "stats"),
      Require = c("", "", "", "", "", ""),
      Version = c("", "", "", "", "", ""),
      Dev = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
    ),
    row.names = 7:12,
    class = "data.frame"
  )
  # nolint end

  mockery::stub(deps_check, "renv::dependencies", renv_dependencies)
  mockery::stub(deps_check, "desc::desc_get_deps", desc_desc_get_deps)
  mockery::stub(deps_check, "pkgload::pkg_name", "pkg")

  expect_output(deps_check("extra"), "^desc::desc_get_deps\\(\\) not found by renv:$")
  expect_output(deps_check("missing"), "^renv::dependencies\\(\\) not in DESCRIPTION:$")

  mockery::stub(deps_check, "writeLines", NULL)
  expect_identical(deps_check("extra"), extras)
  expect_identical(deps_check("missing"), missing)
  expect_identical(deps_check("missing", exclude_base = TRUE), missing)
  expect_identical(deps_check("missing", exclude_base = FALSE), missing_withbase)
})

test_that("missing_deps validates arguments", {
  mockery::stub(missing_deps, "deps_check", NULL)

  expect_error(missing_deps(exclude_base = NA), "'exclude_base'")
})

test_that("missing_deps and extra_deps call correct deps_check type", {
  dc <- function(type, exclude_base = TRUE) {
    type
  }
  mockery::stub(missing_deps, "deps_check", dc)
  mockery::stub(extra_deps, "deps_check", dc)

  expect_identical(missing_deps(), "missing")
  expect_identical(extra_deps(), "extra")
})

# open_files

test_that("open_files validates arguments", {
  mockery::stub(open_files, "rstudioapi::verifyAvailable", NULL)
  mockery::stub(open_files, "rstudioapi::navigateToFile", NULL)

  expect_error(open_files(files = NA), "'files'")
  expect_error(open_files(files = NULL), "'files'")
  expect_error(open_files(files = ""), "'files'")
})

test_that("open_files opens all files", {
  mockery::stub(open_files, "rstudioapi::verifyAvailable", NULL)
  mockery::stub(open_files, "rstudioapi::navigateToFile", "2BC23D46")
  files <- c("TODO.md", "NEWS.md", "README.Rmd", "DESCRIPTION")

  expect_output(
    ret <- open_files(files = files), # nolint: implicit_assignment_linter. suppresses output.
    "^Opening files: TODO\\.md, NEWS\\.md, README\\.Rmd, DESCRIPTION$"
  )
  expect_named(ret, files)
})
