withr::local_dir("test-to_document")

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

test_that("to_document errors when output contains an unexpected object type", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  bad_object <- list(title = "Minimal Notebook", date = "2022-01-22", output = 42)
  mockery::stub(to_document, "rmarkdown::yaml_front_matter", bad_object)

  expect_error(to_document("minimal.Rmd", dest), "unexpected object type for output")
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
  expect_identical(doc_yaml$output$html_document, nb_yaml$output$html_notebook)
})

test_that("to_document converts minimal `html_notebook` to `html_document`", {
  dest <- fs::file_temp(pattern = "notebook", ext = "Rmd")
  withr::local_file(dest)

  to_document("minimal.Rmd", dest)
  yaml <- rmarkdown::yaml_front_matter(dest)

  expect_identical(yaml$output, "html_document")
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
  expect_identical(doc_yaml$output$html_document, nb_yaml$output$html_notebook)
})

# rmd_metadata

test_that("rmd_metadata errors when file isn't a well-formed R markdown document", {
  mockery::stub(rmd_metadata, "desc::desc_get_urls", "https://example.github.io/package")

  expect_error(rmd_metadata("test.txt"), "is not an R Markdown \\(\\*\\.Rmd\\) file")
  expect_error(rmd_metadata("no-front-matter.Rmd"), "is not a valid R Notebook")
  expect_error(rmd_metadata("no-yaml.Rmd"), "is not a valid R Notebook")
})

test_that("rmd_metadata errors when yaml front matter doesn't contain `html_notebook`", {
  mockery::stub(rmd_metadata, "desc::desc_get_urls", "https://example.github.io/package")

  expect_error(rmd_metadata("document.Rmd"), "does not contain `output: html_notebook`")
  expect_error(rmd_metadata("minimal-document.Rmd"), "does not contain `output: html_notebook`")
})

test_that("rmd_metadata errors when output contains an unexpected object type", {
  mockery::stub(rmd_metadata, "desc::desc_get_urls", "https://example.github.io/package")
  bad_object <- list(title = "Minimal Notebook", date = "2022-01-22", output = 42)
  mockery::stub(rmd_metadata, "rmarkdown::yaml_front_matter", bad_object)

  expect_error(rmd_metadata("minimal.Rmd"), "unexpected object type for output")
})

test_that("rmd_metadata returns correct description with extra spaces", {
  mockery::stub(rmd_metadata, "desc::desc_get_urls", "https://example.github.io/package")
  valid <- list(
    title = "Extra Spaces Notebook", url = "https://example.github.io/package/extra-spaces.html",
    date = "2022-01-28",
    description = paste0(
      "Valid Notebook from 'Analysis Notebook' template ",
      "with extra spaces before the description line."
    )
  )

  expect_identical(rmd_metadata("extra-spaces.Rmd"), valid)
})

test_that("rmd_metadata errors when DESCRIPTION doesn't contain a URL", {
  mockery::stub(rmd_metadata, "desc::desc_get_urls", character(0))

  expect_error(rmd_metadata("valid.Rmd"), "no URL found in DESCRIPTION")
})

test_that("rmd_metadata returns analysis notebook metadata", {
  mockery::stub(rmd_metadata, "desc::desc_get_urls", "https://example.github.io/package")

  valid <- list(
    title = "Valid Notebook", url = "https://example.github.io/package/valid.html",
    date = "2022-01-22", description = "Valid Notebook from 'Analysis Notebook' template."
  )

  expect_identical(rmd_metadata("valid.Rmd"), valid)
})
