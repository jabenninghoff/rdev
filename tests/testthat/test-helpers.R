# local_temppkg

test_that("local_temppkg errors with an invalid package type", {
  expect_error(local_temppkg(type = "badtype"), "unrecognized package type, 'badtype'")
})

test_that("local_temppkg creates a valid rdev package", {
  dir <- usethis::ui_silence(local_temppkg())

  # paste0(fs::path_file(dir), ".Rproj") isn't created when running rcmdcheck
  expect_true(fs::file_exists(".Rbuildignore"))
  expect_true(fs::file_exists(".Rprofile"))
  expect_true(fs::dir_exists(".git"))
  expect_true(fs::dir_exists(".github"))
  expect_true(fs::file_exists(".gitignore"))
  expect_true(fs::file_exists(".lintr"))
  expect_true(fs::file_exists("DESCRIPTION"))
  expect_true(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))
  expect_true(fs::file_exists("NAMESPACE"))
  expect_true(fs::file_exists("NEWS.md"))
  expect_true(fs::dir_exists("R"))
  expect_true(fs::file_exists("R/package.R"))
  expect_true(fs::file_exists("README.Rmd"))
  expect_true(fs::file_exists("TODO.md"))
  expect_true(fs::dir_exists("tests"))
  expect_true(fs::dir_exists("tests/testthat"))
  expect_true(fs::file_exists("tests/testthat/test-package.R"))
  expect_true(fs::file_exists("tests/testthat.R"))
})

test_that("local_temppkg creates a valid analysis package", {
  dir <- usethis::ui_silence(local_temppkg(type = "analysis"))

  # valid rdev package
  # paste0(fs::path_file(dir), ".Rproj") isn't created when running rcmdcheck
  expect_true(fs::file_exists(".Rbuildignore"))
  expect_true(fs::file_exists(".Rprofile"))
  expect_true(fs::dir_exists(".git"))
  expect_true(fs::dir_exists(".github"))
  expect_true(fs::file_exists(".gitignore"))
  expect_true(fs::file_exists(".lintr"))
  expect_true(fs::file_exists("DESCRIPTION"))
  expect_true(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))
  expect_true(fs::file_exists("NAMESPACE"))
  expect_true(fs::file_exists("NEWS.md"))
  expect_true(fs::dir_exists("R"))
  expect_true(fs::file_exists("R/package.R"))
  expect_true(fs::file_exists("README.Rmd"))
  expect_true(fs::file_exists("TODO.md"))
  expect_true(fs::dir_exists("tests"))
  expect_true(fs::dir_exists("tests/testthat"))
  expect_true(fs::file_exists("tests/testthat/test-package.R"))
  expect_true(fs::file_exists("tests/testthat.R"))

  # valid analysis package
  expect_true(fs::dir_exists("analysis"))
  expect_true(fs::dir_exists("analysis/assets"))
  expect_true(fs::dir_exists("analysis/data"))
  expect_true(fs::dir_exists("analysis/import"))
  expect_true(fs::dir_exists("analysis/rendered"))
  expect_true(fs::dir_exists("docs"))
  expect_true(fs::dir_exists("pkgdown"))
  expect_true(fs::file_exists("pkgdown/_base.yml"))
})
