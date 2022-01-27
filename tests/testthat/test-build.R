withr::local_dir("test-build")

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

# to_document

test_that("to_document errors when file isn't a well-formed R markdown document", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  expect_error(to_document("test.txt", dest), "is not an R Markdown \\(\\*\\.Rmd\\) file")
  expect_error(to_document("no-front-matter.Rmd", dest), "is not a valid R Notebook")
  expect_error(to_document("no-yaml.Rmd", dest), "is not a valid R Notebook")
})

test_that("overwrite = FALSE prevents file from being overwritten", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  fs::file_create(dest)

  expect_error(to_document("valid.Rmd", dest), "file already exists")
  expect_error(to_document("valid.Rmd", dest, overwrite = FALSE), "file already exists")
  expect_length(readLines(dest), 0)
})

test_that("overwrite = TRUE overwrites file", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  fs::file_create(dest)
  to_document("valid.Rmd", dest, overwrite = TRUE)
  expect_length(readLines(dest), length(readLines("valid.Rmd")))
})

test_that("to_document errors when yaml front matter doesn't contain `html_notebook`", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  expect_error(to_document("document.Rmd", dest), "does not contain `output: html_notebook`")
  expect_error(
    to_document("minimal-document.Rmd", dest), "does not contain `output: html_notebook`"
  )
})

test_that("to_document removes all other output types", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  to_document("multiple.Rmd", dest)
  yaml <- rmarkdown::yaml_front_matter(dest)

  expect_length(yaml$output, 1)
  expect_length(yaml$output$html_document, 2)
})

test_that("to_document converts `html_notebook` to `html_document`", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  to_document("valid.Rmd", dest)
  nb_yaml <- rmarkdown::yaml_front_matter("valid.Rmd")
  doc_yaml <- rmarkdown::yaml_front_matter(dest)

  expect_null(doc_yaml$output$html_notebook)
  expect_equal(doc_yaml$output$html_document, nb_yaml$output$html_notebook)
})

test_that("to_document converts minimal `html_notebook` to `html_document`", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  to_document("minimal.Rmd", dest)
  yaml <- rmarkdown::yaml_front_matter(dest)

  expect_equal(yaml$output, "html_document")
})

test_that("to_document copies source file to a directory", {
  dest <- fs::path_temp()
  if (fs::dir_exists(dest)) {
    fs::dir_delete(dest)
    fs::dir_create(dest)
  }

  new_file <- to_document("valid.Rmd", dest)
  nb_yaml <- rmarkdown::yaml_front_matter("valid.Rmd")
  doc_yaml <- rmarkdown::yaml_front_matter(new_file)

  expect_null(doc_yaml$output$html_notebook)
  expect_equal(doc_yaml$output$html_document, nb_yaml$output$html_notebook)
})
