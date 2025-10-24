# use_upkeep_issue

test_that("use_upkeep_issue validates arguments", {
  withr::local_dir(withr::local_tempdir())
  mockery::stub(use_upkeep_issue, "get_github_repo", NULL)
  mockery::stub(use_upkeep_issue, "upkeep_checklist", NULL)
  mockery::stub(use_upkeep_issue, "desc::desc_get_field", NULL)
  mockery::stub(use_upkeep_issue, "gh::gh", NULL)
  mockery::stub(use_upkeep_issue, "view_url", NULL)
  mockery::stub(use_upkeep_issue, "record_upkeep_date", NULL)

  expect_error(use_upkeep_issue(last_upkeep = TRUE), "'last_upkeep'")
  expect_error(use_upkeep_issue(last_upkeep = "character"), "'last_upkeep'")
  expect_error(use_upkeep_issue(last_upkeep = 200.1), "'last_upkeep'")
  expect_no_error(use_upkeep_issue(last_upkeep = 2025L))
  expect_no_error(use_upkeep_issue(last_upkeep = 2025))
})

# upkeep_checklist

base_length <- 38

test_that("upkeep_checklist is expected length for first upkeep", {
  usethis::ui_silence(local_temppkg(type = "rdev"))

  # get_license() "mit", package_type() "rdev", pkg_minimum_r_version NA, r_version character(0),
  # usethis::git_default_branch() "master", no inst/templates or inst/rmarkdown/templates
  expect_length(upkeep_checklist(), base_length)

  mockery::stub(upkeep_checklist, "package_type", "analysis")
  expect_length(upkeep_checklist(), base_length)

  mockery::stub(upkeep_checklist, "package_type", "quarto")
  expect_length(upkeep_checklist(), base_length + 1)

  mockery::stub(upkeep_checklist, "package_type", "rdev")
  expect_length(upkeep_checklist(), base_length)

  fs::dir_create("R/test")
  expect_length(upkeep_checklist(), base_length + 1)

  mockery::stub(upkeep_checklist, "usethis::git_default_branch", "main")
  expect_length(upkeep_checklist(), base_length)

  desc_r_version <- data.frame(
    type = "Depends", package = "R", version = ">= 4.1.0", stringsAsFactors = FALSE
  )
  mockery::stub(upkeep_checklist, "desc::desc_get_deps", desc_r_version)
  expect_length(upkeep_checklist(), base_length - 1)

  mockery::stub(upkeep_checklist, "desc::desc_get_field", "rdev")
  expect_length(upkeep_checklist(), base_length)

  mockery::stub(upkeep_checklist, "get_license", "proprietary")
  expect_length(upkeep_checklist(), base_length - 1)

  fs::dir_create("inst/templates/test")
  expect_length(upkeep_checklist(), base_length)

  fs::dir_create("inst/rmarkdown/templates/test")
  expect_length(upkeep_checklist(), base_length + 1)
})

test_that("upkeep_checklist is expected length for last upkeep year", {
  usethis::ui_silence(local_temppkg(type = "rdev"))

  expect_length(upkeep_checklist(), base_length)
  expect_length(upkeep_checklist(2021), base_length)
  expect_length(upkeep_checklist(2022), base_length - 6)
  expect_length(upkeep_checklist(2023), base_length - 11)
  expect_length(upkeep_checklist(2024), base_length - 16)
  expect_length(upkeep_checklist(2025), base_length - 20)
  expect_length(upkeep_checklist(2026), base_length - 25)
})
