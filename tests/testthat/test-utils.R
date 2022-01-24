# TODO: test_that sort_file errors when file does not exist

test_that("sort_file sorts a file", {
  tmp_file <- withr::local_tempfile()

  strings <- stringi::stri_rand_strings(10, 10)
  writeLines(strings, tmp_file)
  sort_file(tmp_file)

  expect_equal(readLines(tmp_file), sort(strings))
})

# TODO: test_that sort_rbuildignore errors when .Rbuildignore does not exist

test_that("sort_rbuildignore sorts .Rbuildignore", {
  withr::local_dir(withr::local_tempdir())
  withr::local_file(".Rbuildignore")

  strings <- stringi::stri_rand_strings(10, 10)
  writeLines(strings, ".Rbuildignore")
  sort_rbuildignore()

  expect_equal(readLines(".Rbuildignore"), sort(strings))
})
