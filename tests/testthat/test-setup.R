# use_package_r

test_that("use_package_r creates an R directory if it doesn't exist", {
  withr::local_dir(withr::local_tempdir())
  mockery::stub(use_package_r, "usethis::use_template", NULL)

  use_package_r(open = FALSE)

  expect_equal(fs::dir_exists("R"), c(R = TRUE))
})
