# build_rdev_site

test_that('build_rdev_site errors when pkg is something other than "."', {
  mockery::stub(build_rdev_site, "devtools::build_readme", NULL)
  mockery::stub(build_rdev_site, "pkgdown::clean_site", NULL)
  mockery::stub(build_rdev_site, "pkgdown::build_site", NULL)

  expect_error(
    build_rdev_site(pkg = "tpkg"), 'currently only build_analysis_site\\(pkg = "."\\) is supported'
  )
  expect_output(build_rdev_site(pkg = "."))
})

test_that("all build_rdev_site functions are called", {
  mockery::stub(build_rdev_site, "devtools::build_readme", NULL)
  mockery::stub(build_rdev_site, "pkgdown::clean_site", NULL)
  mockery::stub(build_rdev_site, "pkgdown::build_site", NULL)

  begin <- "^(?s)"
  end <- "$"
  sep <- "\\n\\n"
  build_readme <- "devtools::build_readme\\(\\)"
  clean_site <- "pkgdown::clean_site\\(\\)"
  build_site <- "pkgdown::build_site\\(\\)"

  expect_output(
    build_rdev_site(),
    paste0(begin, build_readme, sep, clean_site, sep, build_site, end),
    perl = TRUE
  )
})

# build_analysis_site

test_that('build_analysis_site errors when pkg is something other than "."', {
  withr::local_dir(withr::local_tempdir())

  expect_error(
    build_analysis_site(pkg = "tpkg"),
    'currently only build_analysis_site\\(pkg = "."\\) is supported'
  )
})

test_that("build_analysis_site errors when components are missing", {
  withr::local_dir(withr::local_tempdir())

  expect_error(build_analysis_site(), "No analysis directory found")
  fs::dir_create("analysis")
  expect_error(build_analysis_site(), "No \\*\\.Rmd files in analysis directory")
  fs::file_create("analysis/test.Rmd")
  expect_error(build_analysis_site(), "pkgdown/_base.yml does not exist")
})

# TODO: tests for build_analysis_site using local_tmppkg()

# end with: test_that("build_analysis_site copies correct files to /docs", {})
