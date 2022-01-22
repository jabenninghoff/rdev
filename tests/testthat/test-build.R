# set up a test fixture per https://testthat.r-lib.org/articles/test-fixtures.html
# use rmarkdown::yaml_front_matter() for testing

test_that("to_document errors when file isn't a well-formed R markdown document", {
  # file extension other than *.Rmd fails
  # no front matter fails
  # no body fails
})

test_that("to_document errors when yaml front matter doesn't contain `html_notebook`", {
  #
})

test_that("to_document removes all other output types", {
  #
})

test_that("to_document converts `html_notebook` to `html_document`", {
  #
})
