# use_package_r

test_that("use_package_r creates an R directory if it doesn't exist", {
  withr::local_dir(withr::local_tempdir())
  mockery::stub(use_package_r, "usethis::use_template", NULL)

  use_package_r(open = FALSE)

  expect_identical(fs::dir_exists("R"), c(R = TRUE))
})

# create_github_repo

test_that("create_github_repo errors when proposed repo directory exists locally", {
  mockery::stub(create_github_repo, "fs::dir_exists", TRUE)
  mockery::stub(create_github_repo, "gh::gh", NULL)
  mockery::stub(create_github_repo, "usethis::create_from_github", NULL)
  mockery::stub(create_github_repo, "fs::file_delete", NULL)
  mockery::stub(create_github_repo, "usethis::create_package", NULL)

  expect_error(
    create_github_repo("rdtest9", "rdev test analysis package 9"),
    "create_from_github\\(\\) target, '.*' already exists"
  )
})

test_that("create_github_repo generates expected output", {
  mockery::stub(create_github_repo, "fs::dir_exists", FALSE)
  mockery::stub(create_github_repo, "gh::gh", NULL)
  mockery::stub(create_github_repo, "usethis::create_from_github", NULL)
  mockery::stub(create_github_repo, "fs::file_delete", NULL)
  mockery::stub(create_github_repo, "usethis::create_package", NULL)

  expect_output(
    create_github_repo("rdtest9", "rdev test analysis package 9"),
    paste0(
      "\\nRepository created at: \\nOpen the repository by executing: \\$ github \\n\\n",
      "Manually add any branch protection at: /settings/branches\\n",
      "Apply rdev conventions within the new project with use_rdev_package\\(\\),\\n",
      "and use either use_analysis_package\\(\\) or usethis::use_pkgdown\\(\\) for GitHub Pages\\."
    )
  )
})
