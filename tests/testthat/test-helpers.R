# local_temppkg

test_that("local_temppkg errors with an invalid package type", {
  expect_error(local_temppkg(type = "badtype"), "unrecognized package type, 'badtype'")
})

test_that("local_temppkg creates a valid rdev package", {
  dir <- usethis::ui_silence(local_temppkg())

  # paste0(fs::path_file(dir), ".Rproj") and ".Rbuildignore" aren't created when running rcmdcheck
  expect_identical(
    as.character(fs::dir_ls(all = TRUE)), c(".git", ".gitignore", "DESCRIPTION", "NAMESPACE", "R")
  )
  expect_true(fs::dir_exists(".git"))
  expect_true(fs::file_exists(".gitignore"))
  expect_true(fs::file_exists("DESCRIPTION"))
  expect_true(fs::file_exists("NAMESPACE"))
  expect_true(fs::dir_exists("R"))
})

test_that("local_temppkg creates a valid analysis package", {
  dir <- usethis::ui_silence(local_temppkg())

  expect_true(fs::dir_exists(dir))
})
