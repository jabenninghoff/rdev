withr::local_dir("test-build")

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

  expect_message(to_document("valid.Rmd", dest), "exists, skipping")
  expect_message(to_document("valid.Rmd", dest, overwrite = FALSE), "exists, skipping")
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
  expect_error(to_document(
    "minimal-document.Rmd", dest), "does not contain `output: html_notebook`"
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
