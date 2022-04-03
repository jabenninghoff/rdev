# sort_file

test_that("sort_file errors when file does not exist", {
  expect_error(sort_file("nonexistant"), "^cannot sort file, '.*': no such file$")
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

test_that("spell_check_notebooks logic flows work", {
  withr::local_dir(withr::local_tempdir())
  fs::dir_create("inst")
  writeLines("spelltest", "inst/WORDLIST")
  writeLines("Package: test\nLanguage: en-US", "DESCRIPTION")

  expect_error(spell_check_notebooks(), "'analysis' directory not found")
  expect_error(spell_check_notebooks(path = "testdir"), "'testdir' directory not found")

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
  expect_error(spell_check_notebooks(), "Field 'Language' not found")

  fs::file_delete("DESCRIPTION")
  expect_error(spell_check_notebooks(), "DESCRIPTION not found")
  expect_length(spell_check_notebooks(lang = "en_US")$found, 1)
})
