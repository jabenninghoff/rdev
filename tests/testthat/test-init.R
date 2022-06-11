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

# setup_analysis

test_that("setup_analysis errors if not running interactively", {
  mockery::stub(setup_analysis, "gert::git_add", NULL)
  mockery::stub(setup_analysis, "gert::git_commit", NULL)
  mockery::stub(setup_analysis, "use_analysis_package", NULL)
  mockery::stub(setup_analysis, "use_spelling", NULL)
  mockery::stub(setup_analysis, "fs::file_delete", NULL)
  mockery::stub(setup_analysis, "ci", NULL)
  mockery::stub(setup_analysis, "utils::askYesNo", FALSE)

  expect_output(rlang::with_interactive(setup_analysis(), value = TRUE), "^Exiting\\.\\.\\.$")
  expect_error(
    rlang::with_interactive(setup_analysis(), value = FALSE),
    "^setup_analysis\\(\\) must be run interactively$"
  )
})

test_that("setup_analysis only runs when askYesNo is explicitly answered 'yes'", {
  mockery::stub(setup_analysis, "gert::git_add", NULL)
  mockery::stub(setup_analysis, "gert::git_commit", NULL)
  mockery::stub(setup_analysis, "use_analysis_package", NULL)
  mockery::stub(setup_analysis, "use_spelling", NULL)
  mockery::stub(setup_analysis, "fs::file_delete", NULL)
  mockery::stub(setup_analysis, "ci", NULL)

  mockery::stub(setup_analysis, "utils::askYesNo", FALSE)
  expect_output(rlang::with_interactive(setup_analysis(), value = TRUE), "^Exiting\\.\\.\\.$")

  mockery::stub(setup_analysis, "utils::askYesNo", NA)
  expect_output(rlang::with_interactive(setup_analysis(), value = TRUE), "^Exiting\\.\\.\\.$")

  mockery::stub(setup_analysis, "utils::askYesNo", TRUE)
  expect_output(
    rlang::with_interactive(setup_analysis(), value = TRUE),
    paste0(
      "^Committing\\.\\.\\.\\\nuse_analysis_package\\(\\)\\.\\.\\.\\\n",
      "Committing\\.\\.\\.\\\nuse_spelling\\(\\)\\.\\.\\.\\\n",
      "Committing\\.\\.\\.\\\nci\\(\\)\\.\\.\\.$"
    )
  )
})
