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
  fs_path <- "/Users/test/Desktop/rdtest9"
  create <- list(html_url = "https://github.com/test/rdtest9")
  mockery::stub(create_github_repo, "fs::dir_exists", FALSE)
  mockery::stub(create_github_repo, "gh::gh", create)
  mockery::stub(create_github_repo, "usethis::create_from_github", fs_path)
  mockery::stub(create_github_repo, "fs::file_delete", NULL)
  mockery::stub(create_github_repo, "usethis::create_package", NULL)

  expect_output(
    create_github_repo("rdtest9", "rdev test analysis package 9"),
    paste0(
      "\\nRepository created at: ", create$html_url, "\\n",
      "Open the repository by executing: \\$ github ", fs_path, "\\n",
      "\\nManually add any branch protection at: ", create$html_url, "/settings/branches\\n",
      "Apply rdev conventions within the new project with use_rdev_package\\(\\),\\n",
      "and use either use_analysis_package\\(\\) or usethis::use_pkgdown\\(\\) for GitHub Pages\\."
    )
  )
})

# use_analysis_package

test_that("use_analysis_package returns expected values", {
  values <- list(
    dirs = c(
      "analysis", "analysis/assets", "analysis/data", "analysis/import", "analysis/rendered",
      "docs", "pkgdown"
    ), rbuildignore = c(
      "^analysis/.*\\.docx$", "^analysis/.*\\.html$", "^analysis/.*\\.md$", "^analysis/.*\\.pdf$",
      "^analysis/.*-figure$", "^analysis/import$", "^analysis/rendered$",
      "^docs$", "^pkgdown$", "^_pkgdown\\.yml$"
    ), gitignore = c(
      "analysis/*.docx", "analysis/*.html", "analysis/*.md", "analysis/*.pdf", "analysis/*-figure/",
      "analysis/import", "analysis/rendered"
    )
  )
  urls <- c("https://example.github.io/test")
  mockery::stub(use_analysis_package, "fs::dir_create", NULL)
  mockery::stub(use_analysis_package, "usethis::use_git_ignore", NULL)
  mockery::stub(use_analysis_package, "usethis::use_build_ignore", NULL)
  mockery::stub(use_analysis_package, "sort_rbuildignore", NULL)
  mockery::stub(use_analysis_package, "desc::desc_get_urls", urls)
  mockery::stub(use_analysis_package, "fs::file_exists", FALSE)
  mockery::stub(use_analysis_package, "yaml::write_yaml", NULL)
  mockery::stub(use_analysis_package, "usethis::use_template", NULL)

  expect_identical(use_analysis_package(), values)
})
