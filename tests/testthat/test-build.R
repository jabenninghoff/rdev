# build_rdev_site

test_that('build_rdev_site errors when pkg is something other than "."', {
  mockery::stub(build_rdev_site, "devtools::build_readme", NULL)
  mockery::stub(build_rdev_site, "pkgdown::clean_site", NULL)
  mockery::stub(build_rdev_site, "pkgdown::build_site", NULL)

  expect_error(
    build_rdev_site(pkg = "test"), 'currently only build_analysis_site\\(pkg = "."\\) is supported'
  )
  expect_output(build_rdev_site(pkg = "."))
})

test_that("all build_rdev_site functions are called", {
  mockery::stub(build_rdev_site, "devtools::build_readme", NULL)
  mockery::stub(build_rdev_site, "pkgdown::clean_site", NULL)
  mockery::stub(build_rdev_site, "pkgdown::build_site", NULL)

  expect_output(
    build_rdev_site(),
    paste0(
      "^(?s)devtools::build_readme\\(\\)\\n\\npkgdown::clean_site\\(\\)\\n\\n",
      "pkgdown::build_site\\(\\)$"
    ),
    perl = TRUE
  )
})
