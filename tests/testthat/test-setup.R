# use_package_r

test_that("use_package_r creates an R directory if it doesn't exist", {
  withr::local_dir(withr::local_tempdir())
  mockery::stub(use_package_r, "usethis::use_template", NULL)

  use_package_r(open = FALSE)

  expect_identical(fs::dir_exists("R"), c(R = TRUE))
})

# use_codecov

test_that("rdev.codecov option skips installation of codecov.io components", {
  u_pack <- function(package, type = "Imports") {
    writeLines(paste0("package = '", package, "', type ='", type, "'"))
  }
  mockery::stub(use_codecov, "renv::install", NULL)
  mockery::stub(use_codecov, "renv::snapshot", NULL)
  mockery::stub(use_codecov, "usethis::use_coverage", function(type) writeLines("use_coverage"))
  mockery::stub(use_codecov, "sort_rbuildignore", function() writeLines("sort_rbuildignore"))
  mockery::stub(
    use_codecov, "usethis::use_github_action", function(url) writeLines("use_github_action")
  )
  mockery::stub(use_codecov, "usethis::use_package", u_pack)

  expect_output(
    withr::with_options(list(rdev.codecov = NULL), use_codecov()),
    "use_coverage\\nsort_rbuildignore\\nuse_github_action\\npackage = 'DT', type ='Suggests'"
  )
  expect_output(
    withr::with_options(list(rdev.codecov = TRUE), use_codecov()),
    "use_coverage\\nsort_rbuildignore\\nuse_github_action\\npackage = 'DT', type ='Suggests'"
  )
  expect_output(
    withr::with_options(list(rdev.codecov = FALSE), use_codecov()),
    "package = 'covr', type ='Suggests'\\npackage = 'DT', type ='Suggests'"
  )
})

# get_license

test_that("get_license validates options", {
  expect_error(
    withr::with_options(list(rdev.license = "cc0"), get_license()),
    "invalid rdev.license type, 'cc0'"
  )
  expect_error(
    withr::with_options(list(rdev.license = "proprietary"), get_license()),
    "rdev.license is 'proprietary' and rdev.license.copyright is not set"
  )
  expect_identical(withr::with_options(list(rdev.license = "mit"), get_license()), "mit")
  expect_identical(withr::with_options(list(rdev.license = "gpl"), get_license()), "gpl")
  expect_identical(withr::with_options(list(rdev.license = "lgpl"), get_license()), "lgpl")
  expect_identical(
    withr::with_options(
      list(rdev.license = "proprietary", rdev.license.copyright = "Test"),
      get_license()
    ),
    "proprietary"
  )
})

# fix_gitignore

test_that("fix_gitignore removes extra '.Rproj.user'", {
  withr::local_dir(withr::local_tempdir())
  gitignore_tidy <- c(
    ".Rproj.user/",
    "xRproj.user",
    ".Rprojxuser",
    ".Rproj.user"
  )
  gitignore_fixed <- c(
    ".Rproj.user/",
    "xRproj.user",
    ".Rprojxuser"
  )

  writeLines(gitignore_tidy, ".gitignore")
  fix_gitignore()
  expect_identical(readLines(".gitignore"), gitignore_fixed)
})

# create_github_repo

test_that("create_github_repo errors when proposed repo directory exists locally", {
  mockery::stub(create_github_repo, "fs::dir_exists", TRUE)
  mockery::stub(create_github_repo, "gh::gh", NULL)
  mockery::stub(create_github_repo, "usethis::create_from_github", NULL)
  mockery::stub(create_github_repo, "fs::file_delete", NULL)
  mockery::stub(create_github_repo, "usethis::create_package", NULL)
  mockery::stub(create_github_repo, "fix_gitignore", NULL)

  expect_error(
    create_github_repo("rdtest9", "rdev test analysis package 9"),
    "create_from_github\\(\\) target, '.*' already exists"
  )
})

test_that("create_github_repo options work", {
  fs_path <- "/Users/test/Desktop/rdtest9"
  create <- list(html_url = "https://github.com/test/rdtest9")
  with_dependabot <- paste0(
    "^POST /user/repos\\n",
    "PUT /repos/\\{owner\\}/\\{repo\\}/vulnerability-alerts\\n",
    "PUT /repos/\\{owner\\}/\\{repo\\}/automated-security-fixes\\n",
    "PUT /repos/\\{owner\\}/\\{repo\\}/branches/\\{branch\\}/protection\\n",
    "\\nRepository created at: ", create$html_url, "\\n",
    "Open the repository by executing: \\$ github ", fs_path, "\\n",
    "Apply rdev conventions within the new project with use_rdev_package\\(\\),\\n",
    "and use either use_analysis_package\\(\\) or usethis::use_pkgdown\\(\\) for GitHub Pages\\.$"
  )
  without_dependabot <- paste0(
    "^POST /user/repos\\n",
    "PUT /repos/\\{owner\\}/\\{repo\\}/branches/\\{branch\\}/protection\\n",
    "\\nRepository created at: ", create$html_url, "\\n",
    "Open the repository by executing: \\$ github ", fs_path, "\\n",
    "Apply rdev conventions within the new project with use_rdev_package\\(\\),\\n",
    "and use either use_analysis_package\\(\\) or usethis::use_pkgdown\\(\\) for GitHub Pages\\.$"
  )
  gh_gh <- function(command, ...) {
    writeLines(command)
    create
  }
  mockery::stub(create_github_repo, "fs::dir_exists", FALSE)
  mockery::stub(create_github_repo, "gh::gh", gh_gh)
  mockery::stub(create_github_repo, "usethis::create_from_github", fs_path)
  mockery::stub(create_github_repo, "fs::file_delete", NULL)
  mockery::stub(create_github_repo, "usethis::create_package", NULL)
  mockery::stub(create_github_repo, "fix_gitignore", NULL)

  expect_output(
    withr::with_options(
      list(rdev.dependabot = NULL),
      create_github_repo("rdtest9", "rdev test analysis package 9")
    ),
    with_dependabot,
    perl = TRUE
  )
  expect_output(
    withr::with_options(
      list(rdev.dependabot = TRUE),
      create_github_repo("rdtest9", "rdev test analysis package 9")
    ),
    with_dependabot,
    perl = TRUE
  )
  expect_output(
    withr::with_options(
      list(rdev.dependabot = FALSE),
      create_github_repo("rdtest9", "rdev test analysis package 9")
    ),
    without_dependabot,
    perl = TRUE
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
  mockery::stub(create_github_repo, "fix_gitignore", NULL)

  expect_output(
    create_github_repo("rdtest9", "rdev test analysis package 9"),
    paste0(
      "^\\nRepository created at: ", create$html_url, "\\n",
      "Open the repository by executing: \\$ github ", fs_path, "\\n",
      "Apply rdev conventions within the new project with use_rdev_package\\(\\),\\n",
      "and use either use_analysis_package\\(\\) or usethis::use_pkgdown\\(\\) for GitHub Pages\\.$"
    ),
    perl = TRUE
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
  mockery::stub(use_analysis_package, "renv::install", NULL)
  mockery::stub(use_analysis_package, "usethis::use_package", NULL)
  mockery::stub(use_analysis_package, "renv::snapshot", NULL)

  expect_identical(use_analysis_package(), values)
})
