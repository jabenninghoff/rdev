# init

test_that("init errors if not running interactively", {
  mockery::stub(init, "gert::git_branch_create", NULL)
  mockery::stub(init, "gert::git_add", NULL)
  mockery::stub(init, "gert::git_commit", NULL)
  mockery::stub(init, "use_rdev_package", NULL)
  mockery::stub(init, "utils::askYesNo", FALSE)

  expect_output(rlang::with_interactive(init(), value = TRUE), "^Exiting\\.\\.\\.$")
  expect_error(
    rlang::with_interactive(init(), value = FALSE), "^init\\(\\) must be run interactively$"
  )
})

test_that("init only runs when askYesNo is explicitly answered 'yes'", {
  mockery::stub(init, "gert::git_branch_create", NULL)
  mockery::stub(init, "gert::git_add", NULL)
  mockery::stub(init, "gert::git_commit", NULL)
  mockery::stub(init, "use_rdev_package", NULL)

  mockery::stub(init, "utils::askYesNo", FALSE)
  expect_output(rlang::with_interactive(init(), value = TRUE), "^Exiting\\.\\.\\.$")

  mockery::stub(init, "utils::askYesNo", NA)
  expect_output(rlang::with_interactive(init(), value = TRUE), "^Exiting\\.\\.\\.$")

  mockery::stub(init, "utils::askYesNo", TRUE)
  expect_output(
    rlang::with_interactive(init(), value = TRUE),
    "^Creating new branch\\.\\.\\.\\\nuse_rdev_package\\(\\)\\.\\.\\.$"
  )
})
