# local_temppkg

test_that("local_temppkg validates arguments", {
  expect_error(local_temppkg(dir = NA_character_), "'dir'")
  expect_error(local_temppkg(dir = ""), "'dir'")
  expect_error(local_temppkg(type = "badtype"), "'type'")
  expect_error(local_temppkg(env = NA), "'env'")
})

test_that("local_temppkg creates a valid usethis package", {
  usethis::ui_silence(local_temppkg())

  # .Rbuildignore and .gitignore aren't created in rcmdcheck
  expect_true(fs::file_exists("DESCRIPTION"))
  expect_true(fs::file_exists("NAMESPACE"))
  expect_true(fs::dir_exists("R"))
})

test_that("local_temppkg creates a valid rdev package", {
  withr::local_options(
    .new = list(rdev.license = NULL, rdev.license.copyright = NULL, rdev.github.actions = NULL)
  )
  usethis::ui_silence(local_temppkg(type = "rdev"))

  # .Rproj isn't created when running rcmdcheck
  expect_true(fs::file_exists(".Rbuildignore"))
  expect_true(fs::file_exists(".Rprofile"))
  expect_true(fs::file_exists(".git/hooks/pre-commit"))
  expect_true(fs::file_exists(".github/.gitignore"))
  expect_true(fs::file_exists(".github/workflows/R-CMD-check.yaml"))
  expect_true(fs::file_exists(".github/workflows/lint.yaml"))
  expect_true(fs::file_exists(".github/workflows/missing-deps.yaml"))
  expect_true(fs::file_exists(".gitignore"))
  expect_true(fs::file_exists(".lintr"))
  expect_true(fs::file_exists("DESCRIPTION"))
  expect_true(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))
  expect_true(fs::file_exists("NAMESPACE"))
  expect_true(fs::file_exists("NEWS.md"))
  expect_true(fs::file_exists("R/package.R"))
  expect_true(fs::file_exists("README.Rmd"))
  expect_true(fs::file_exists("TODO.md"))
  expect_true(fs::file_exists("tests/testthat/test-package.R"))
  expect_true(fs::file_exists("tests/testthat.R"))
})

test_that("local_temppkg uses license options", {
  withr::with_options(
    list(rdev.license = NULL, rdev.license.copyright = NULL),
    usethis::ui_silence(local_temppkg(type = "rdev"))
  )
  expect_true(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))

  withr::with_options(
    list(rdev.license = "mit", rdev.license.copyright = NULL),
    usethis::ui_silence(local_temppkg(type = "rdev"))
  )
  expect_true(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))

  withr::with_options(
    list(rdev.license = "gpl", rdev.license.copyright = NULL),
    usethis::ui_silence(local_temppkg(type = "rdev"))
  )
  expect_false(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))

  withr::with_options(
    list(rdev.license = "lgpl", rdev.license.copyright = NULL),
    usethis::ui_silence(local_temppkg(type = "rdev"))
  )
  expect_false(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))

  withr::with_options(
    list(rdev.license = "proprietary", rdev.license.copyright = "Test"),
    usethis::ui_silence(local_temppkg(type = "rdev"))
  )
  expect_true(fs::file_exists("LICENSE"))
  expect_false(fs::file_exists("LICENSE.md"))
})

test_that("local_temppkg uses GitHub Action options", {
  withr::with_options(
    list(rdev.github.actions = NULL), usethis::ui_silence(local_temppkg(type = "rdev"))
  )
  expect_true(fs::file_exists(".github/.gitignore"))
  expect_true(fs::file_exists(".github/workflows/R-CMD-check.yaml"))
  expect_true(fs::file_exists(".github/workflows/lint.yaml"))
  expect_true(fs::file_exists(".github/workflows/missing-deps.yaml"))
  withr::with_options(
    list(rdev.github.actions = TRUE), usethis::ui_silence(local_temppkg(type = "rdev"))
  )
  expect_true(fs::file_exists(".github/.gitignore"))
  expect_true(fs::file_exists(".github/workflows/R-CMD-check.yaml"))
  expect_true(fs::file_exists(".github/workflows/lint.yaml"))
  expect_true(fs::file_exists(".github/workflows/missing-deps.yaml"))
  withr::with_options(
    list(rdev.github.actions = FALSE), usethis::ui_silence(local_temppkg(type = "rdev"))
  )
  expect_false(fs::file_exists(".github/.gitignore"))
  expect_false(fs::file_exists(".github/workflows/R-CMD-check.yaml"))
  expect_false(fs::file_exists(".github/workflows/lint.yaml"))
  expect_false(fs::file_exists(".github/workflows/missing-deps.yaml"))
})

test_that("local_temppkg creates a valid analysis package", {
  withr::local_options(
    .new = list(rdev.license = NULL, rdev.license.copyright = NULL, rdev.github.actions = NULL)
  )
  usethis::ui_silence(local_temppkg(type = "analysis"))

  # valid rdev package
  # .Rproj isn't created when running rcmdcheck
  expect_true(fs::file_exists(".Rbuildignore"))
  expect_true(fs::file_exists(".Rprofile"))
  expect_true(fs::file_exists(".git/hooks/pre-commit"))
  expect_true(fs::file_exists(".github/.gitignore"))
  expect_true(fs::file_exists(".github/workflows/R-CMD-check.yaml"))
  expect_true(fs::file_exists(".github/workflows/lint.yaml"))
  expect_true(fs::file_exists(".github/workflows/missing-deps.yaml"))
  expect_true(fs::file_exists(".gitignore"))
  expect_true(fs::file_exists(".lintr"))
  expect_true(fs::file_exists("DESCRIPTION"))
  expect_true(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))
  expect_true(fs::file_exists("NAMESPACE"))
  expect_true(fs::file_exists("NEWS.md"))
  expect_true(fs::file_exists("R/package.R"))
  expect_true(fs::file_exists("README.Rmd"))
  expect_true(fs::file_exists("TODO.md"))
  expect_true(fs::file_exists("tests/testthat/test-package.R"))
  expect_true(fs::file_exists("tests/testthat.R"))

  # valid analysis package
  expect_true(fs::dir_exists("analysis"))
  expect_true(fs::dir_exists("analysis/assets"))
  expect_true(fs::file_exists("analysis/assets/extra.css"))
  expect_true(fs::dir_exists("analysis/data"))
  expect_true(fs::dir_exists("analysis/import"))
  expect_true(fs::dir_exists("analysis/rendered"))
  expect_true(fs::dir_exists("docs"))
  expect_true(fs::file_exists("pkgdown/_base.yml"))
  expect_true(fs::file_exists("pkgdown/extra.css"))

  # no quarto files
  expect_false(fs::file_exists(".nojekyll"))
  expect_false(fs::file_exists("_quarto.yml"))
  expect_false(fs::file_exists("changelog.qmd"))
  expect_false(fs::file_exists("index.qmd"))
  expect_false(fs::file_exists("analysis/_metadata.yml"))
})

test_that("local_temppkg creates a valid quarto package", {
  withr::local_options(
    .new = list(rdev.license = NULL, rdev.license.copyright = NULL, rdev.github.actions = NULL)
  )
  usethis::ui_silence(local_temppkg(type = "quarto"))

  # valid rdev package
  # .Rproj isn't created when running rcmdcheck
  expect_true(fs::file_exists(".Rbuildignore"))
  expect_true(fs::file_exists(".Rprofile"))
  expect_true(fs::file_exists(".git/hooks/pre-commit"))
  expect_true(fs::file_exists(".github/.gitignore"))
  expect_true(fs::file_exists(".github/workflows/R-CMD-check.yaml"))
  expect_true(fs::file_exists(".github/workflows/lint.yaml"))
  expect_true(fs::file_exists(".github/workflows/missing-deps.yaml"))
  expect_true(fs::file_exists(".gitignore"))
  expect_true(fs::file_exists(".lintr"))
  expect_true(fs::file_exists("DESCRIPTION"))
  expect_true(fs::file_exists("LICENSE"))
  expect_true(fs::file_exists("LICENSE.md"))
  expect_true(fs::file_exists("NAMESPACE"))
  expect_true(fs::file_exists("NEWS.md"))
  expect_true(fs::file_exists("R/package.R"))
  expect_true(fs::file_exists("README.Rmd"))
  expect_true(fs::file_exists("TODO.md"))
  expect_true(fs::file_exists("tests/testthat/test-package.R"))
  expect_true(fs::file_exists("tests/testthat.R"))

  # valid quarto package
  expect_true(fs::dir_exists("analysis"))
  expect_true(fs::dir_exists("analysis/assets"))
  expect_true(fs::file_exists("analysis/assets/extra.css"))
  expect_true(fs::dir_exists("analysis/data"))
  expect_true(fs::dir_exists("analysis/import"))
  expect_true(fs::dir_exists("analysis/rendered"))
  expect_true(fs::dir_exists("docs"))
  expect_true(fs::file_exists(".nojekyll"))
  expect_true(fs::file_exists("_quarto.yml"))
  expect_true(fs::file_exists("changelog.qmd"))
  expect_true(fs::file_exists("index.qmd"))
  expect_true(fs::file_exists("analysis/_metadata.yml"))

  # no pkgdown files
  expect_false(fs::file_exists("pkgdown/_base.yml"))
  expect_false(fs::file_exists("pkgdown/extra.css"))
})
