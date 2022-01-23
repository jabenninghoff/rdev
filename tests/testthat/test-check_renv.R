test_that("All renv functions are called", {
  mockery::stub(check_renv, "renv::status", NULL)
  mockery::stub(check_renv, "renv::clean", NULL)
  mockery::stub(check_renv, "renv::update", NULL)

  expect_output(
    check_renv(),
    "^(?s)renv::status\\(\\)\\n\\nrenv::clean\\(\\)\\n\\nrenv::update\\(\\)$",
    perl = TRUE
  )
})

test_that("renv::update isn't run when update = FALSE", {
  mockery::stub(check_renv, "renv::status", NULL)
  mockery::stub(check_renv, "renv::clean", NULL)
  mockery::stub(check_renv, "renv::update", NULL)

  expect_output(
    check_renv(update = FALSE),
    "^(?s)renv::status\\(\\)\\n\\nrenv::clean\\(\\)$",
    perl = TRUE
  )
})
