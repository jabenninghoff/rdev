# build_rdev_site

test_that('build_rdev_site errors when pkg is something other than "."', {
  mockery::stub(build_rdev_site, "devtools::build_readme", NULL)
  mockery::stub(build_rdev_site, "pkgdown::build_site_github_pages", NULL)

  expect_error(
    build_rdev_site(pkg = "tpkg"), '^currently only build_rdev_site\\(pkg = "."\\) is supported$'
  )
})

test_that("all build_rdev_site functions are called", {
  mockery::stub(build_rdev_site, "devtools::build_readme", NULL)
  mockery::stub(build_rdev_site, "pkgdown::build_site_github_pages", NULL)

  begin <- "^"
  end <- "$"
  sep <- "\\n\\n"
  build_readme <- "devtools::build_readme\\(\\)"
  build_site_ghp <- "pkgdown::build_site_github_pages\\(install = TRUE, new_process = TRUE\\)"

  expect_output(
    build_rdev_site(), paste0(begin, build_readme, sep, build_site_ghp, end)
  )
  expect_output(
    build_rdev_site(pkg = "."), paste0(begin, build_readme, sep, build_site_ghp, end)
  )
})

# unfreeze

test_that("unfreeze errors when components are missing", {
  withr::local_dir(withr::local_tempdir())

  expect_error(unfreeze(), "^_quarto\\.yml does not exist$")
})

# build_quarto_site

test_that("build_quarto_site validates arguments", {
  mockery::stub(build_quarto_site, "devtools::build_readme", NULL)
  mockery::stub(build_quarto_site, "unfreeze", NULL)
  mockery::stub(build_quarto_site, "quarto::quarto_render", NULL)
  withr::local_dir(withr::local_tempdir())
  fs::file_create("README.Rmd")
  fs::dir_create("analysis")
  fs::file_create("analysis/test.Rmd")
  fs::file_create("_quarto.yml")

  expect_error(build_quarto_site(unfreeze = NA), "'unfreeze'")
})

test_that("build_quarto_site errors when components are missing", {
  withr::local_dir(withr::local_tempdir())

  expect_error(build_quarto_site(), "^README\\.Rmd does not exist$")
  fs::file_create("README.Rmd")
  expect_error(build_quarto_site(), "^no analysis directory found$")
  fs::dir_create("analysis")
  expect_error(build_quarto_site(), "^no \\*\\.Rmd or \\*\\.qmd files in analysis directory$")
  fs::file_create("analysis/test.Rmd")
  expect_error(build_quarto_site(), "^_quarto\\.yml does not exist$")
  fs::file_delete("analysis/test.Rmd")
  fs::file_create("analysis/test.qmd")
  expect_error(build_quarto_site(), "^_quarto\\.yml does not exist$")
})

test_that("all build_quarto_site functions are called", {
  mockery::stub(build_quarto_site, "devtools::build_readme", NULL)
  mockery::stub(build_quarto_site, "unfreeze", NULL)
  mockery::stub(build_quarto_site, "quarto::quarto_render", NULL)
  withr::local_dir(withr::local_tempdir())
  fs::file_create("README.Rmd")
  fs::dir_create("analysis")
  fs::file_create("analysis/test.Rmd")
  fs::file_create("_quarto.yml")

  begin <- "^"
  end <- "$"
  sep <- "\\n\\n"
  build_readme <- "devtools::build_readme\\(\\)"
  unfreeze <- "unfreeze\\(\\)"
  quarto_render <- "quarto::quarto_render\\(\\)"

  expect_output(
    build_quarto_site(), paste0(begin, build_readme, sep, quarto_render, end)
  )
  expect_output(
    build_quarto_site(unfreeze = TRUE),
    paste0(begin, build_readme, sep, unfreeze, sep, quarto_render, end)
  )
})

# build_analysis_site

test_that('build_analysis_site errors when pkg is something other than "."', {
  withr::local_dir(withr::local_tempdir())

  expect_error(
    build_analysis_site(pkg = "tpkg"),
    '^currently only build_analysis_site\\(pkg = "."\\) is supported$'
  )
})

test_that("build_analysis_site errors when components are missing", {
  withr::local_dir(withr::local_tempdir())

  expect_error(build_analysis_site(), "^no analysis directory found$")
  fs::dir_create("analysis")
  expect_error(build_analysis_site(), "^no \\*\\.Rmd files in analysis directory$")
  fs::file_create("analysis/test.Rmd")
  expect_error(build_analysis_site(), "^pkgdown/_base\\.yml does not exist$")
})

test_that("build_analysis_site creates analysis site", {
  withr::local_options(.new = list(rdev.host = NULL))
  test_notebook <- readLines("test-to_document/with-code.Rmd")

  # run build_analysis_site() only once to speed up testing
  dir <- usethis::ui_silence(local_temppkg(type = "analysis"))
  fs::file_delete(c(".Rprofile", "README.Rmd"))
  writeLines(test_notebook, "analysis/test-notebook.Rmd")
  # silence output and messages (but not warnings and errors)
  # nolint next: implicit_assignment_linter.
  withr::with_output_sink(withr::local_tempfile(), suppressMessages(site <- build_analysis_site()))

  expect_true(fs::file_exists("_pkgdown.yml"))

  # head of _pkgdown.yml should match _base.yml
  bas <- readLines("pkgdown/_base.yml")
  pkg <- readLines("_pkgdown.yml")
  len <- ifelse(length(bas) == 0, 1, length(bas))
  expect_identical(bas, pkg[1:len])

  # _pkgdown.yml should contain analysis navbar, Analysis menu, and test notebook
  yml <- yaml::read_yaml("_pkgdown.yml")
  expect_identical(tail(yml$navbar$structure$left, 1), "analysis")
  expect_identical(yml$navbar$components$analysis$text, "Analysis")
  expect_length(yml$navbar$components$analysis$menu, 1)
  expect_identical(yml$navbar$components$analysis$menu[[1]]$text, "Valid Notebook with R Code")
  expect_identical(yml$navbar$components$analysis$menu[[1]]$href, "test-notebook.html")

  # _site.yml should match expect_site
  expect_site <- list(
    output_dir = "docs",
    navbar = list(
      title = paste0(fs::path_file(dir), " notebooks"),
      type = "default",
      left = list(
        reference = list(text = "Reference", href = "reference/index.html"),
        news = list(text = "Changelog", href = "news/index.html"),
        analysis = list(text = "Analysis", menu = list(list(
          text = "Valid Notebook with R Code", href = "test-notebook.html"
        )))
      ),
      right = list(
        search = list(search = list()),
        github = list(
          icon = "fab fa-github fa-lg", href = "https://github.com/example/tpkg/",
          `aria-label` = "GitHub"
        )
      )
    ),
    output = list(html_document = list(
      code_download = TRUE, code_folding = "show", df_print = "paged",
      fig_width = 8, fig_height = 4.5, highlight = "textmate"
    ))
  )
  expect_identical(site, expect_site)

  # assets, rendered, and site_libs should be copied, data and import should not
  expect_true(fs::dir_exists("docs/assets"))
  expect_true(fs::dir_exists("docs/rendered"))
  expect_true(fs::dir_exists("docs/site_libs"))
  expect_false(fs::dir_exists("docs/data"))
  expect_false(fs::dir_exists("docs/import"))

  # test-notebook and plot should be copied
  expect_true(fs::file_exists("docs/test-notebook.html"))
  expect_true(fs::file_exists("docs/test-notebook_files/figure-html/cars-1.png"))
})
