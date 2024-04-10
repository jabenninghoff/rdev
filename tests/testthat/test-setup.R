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

  cov_out <- "use_coverage\\nsort_rbuildignore\\n"
  gha_out <- "use_github_action\\n"
  use_out <- "package = 'covr', type ='Suggests'\\npackage = 'DT', type ='Suggests'"

  expect_output(
    withr::with_options(list(rdev.codecov = NULL, rdev.github.actions = NULL), use_codecov()),
    paste0("^", cov_out, gha_out, use_out, "$")
  )
  expect_output(
    withr::with_options(list(rdev.codecov = TRUE, rdev.github.actions = TRUE), use_codecov()),
    paste0("^", cov_out, gha_out, use_out, "$")
  )
  expect_output(
    withr::with_options(list(rdev.codecov = TRUE, rdev.github.actions = FALSE), use_codecov()),
    paste0("^", cov_out, use_out, "$")
  )
  expect_output(
    withr::with_options(list(rdev.codecov = FALSE, rdev.github.actions = TRUE), use_codecov()),
    paste0("^", use_out, "$")
  )
})

# get_license

test_that("get_license validates options", {
  expect_error(
    withr::with_options(list(rdev.license = "cc0"), get_license()),
    "^invalid rdev\\.license type, 'cc0'$"
  )
  expect_error(
    withr::with_options(
      list(rdev.license = "proprietary", rdev.license.copyright = NULL), get_license()
    ),
    "^rdev\\.license is 'proprietary' and rdev\\.license\\.copyright is not set$"
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

test_that("fix_gitignore validates arguments", {
  withr::local_dir(withr::local_tempdir())

  expect_error(fix_gitignore(path = NA_character_), "'path'")
  expect_error(fix_gitignore(path = ""), "'path'")
})

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

test_that("create_github_repo validates arguments", {
  mockery::stub(create_github_repo, "fs::dir_exists", NULL)
  mockery::stub(create_github_repo, "gh::gh", NULL)
  mockery::stub(create_github_repo, "usethis::create_from_github", NULL)
  mockery::stub(create_github_repo, "fs::file_delete", NULL)
  mockery::stub(create_github_repo, "usethis::create_package", NULL)
  mockery::stub(create_github_repo, "fix_gitignore", NULL)

  expect_error(create_github_repo(repo_name = NA_character_), "'repo_name'")
  expect_error(create_github_repo(repo_name = ""), "'repo_name'")
  expect_error(create_github_repo("test", repo_desc = NA_character_), "'repo_desc'")
  expect_error(create_github_repo("test", org = NA_character_), "'org'")
  expect_error(create_github_repo("test", org = ""), "'org'")
  expect_error(create_github_repo("test", host = NA_character_), "'host'")
  expect_error(create_github_repo("test", host = ""), "'host'")
})

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
  fs_path <- "/Users/test/Desktop/rdtest9" # nolint: absolute_path_linter.
  create <- list(html_url = "https://github.com/test/rdtest9")
  with_dependabot <- paste0(
    "^POST /user/repos\\n",
    "PUT /repos/\\{owner\\}/\\{repo\\}/vulnerability-alerts\\n",
    "PUT /repos/\\{owner\\}/\\{repo\\}/automated-security-fixes\\n",
    "PUT /repos/\\{owner\\}/\\{repo\\}/branches/\\{branch\\}/protection\\n",
    "\\nRepository created at: ", create$html_url, "\\n",
    "Open the repository by executing: \\$ github ", fs_path, "\\n",
    "Apply rdev conventions within the new project by running init\\(\\) without committing,\\n",
    "update the Title and Description fields in `DESCRIPTION` without committing,\\n",
    "and run either setup_ananlysis\\(\\) or setup_rdev\\(\\) to finish configuration\\.$"
  )
  without_dependabot <- paste0(
    "^POST /user/repos\\n",
    "PUT /repos/\\{owner\\}/\\{repo\\}/branches/\\{branch\\}/protection\\n",
    "\\nRepository created at: ", create$html_url, "\\n",
    "Open the repository by executing: \\$ github ", fs_path, "\\n",
    "Apply rdev conventions within the new project by running init\\(\\) without committing,\\n",
    "update the Title and Description fields in `DESCRIPTION` without committing,\\n",
    "and run either setup_ananlysis\\(\\) or setup_rdev\\(\\) to finish configuration\\.$"
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
    with_dependabot
  )
  expect_output(
    withr::with_options(
      list(rdev.dependabot = TRUE),
      create_github_repo("rdtest9", "rdev test analysis package 9")
    ),
    with_dependabot
  )
  expect_output(
    withr::with_options(
      list(rdev.dependabot = FALSE),
      create_github_repo("rdtest9", "rdev test analysis package 9")
    ),
    without_dependabot
  )
})

test_that("create_github_repo generates expected output", {
  fs_path <- "/Users/test/Desktop/rdtest9" # nolint: absolute_path_linter.
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
      "Apply rdev conventions within the new project by running init\\(\\) without committing,\\n",
      "update the Title and Description fields in `DESCRIPTION` without committing,\\n",
      "and run either setup_ananlysis\\(\\) or setup_rdev\\(\\) to finish configuration\\.$"
    )
  )
})

# get_server_url

test_that("get_server_url finds the correct server URL", {
  expect_identical(
    withr::with_options(list(rdev.host = NULL), get_server_url()),
    "https://github.com/"
  )
  expect_identical(
    withr::with_options(list(rdev.host = "https://github.com"), get_server_url()),
    "https://github.com/"
  )
  expect_identical(
    withr::with_options(list(rdev.host = "https://github.example.com/api/v3"), get_server_url()),
    "https://github.example.com/"
  )
  expect_identical(
    withr::with_options(list(rdev.host = "https://github.example.com:80/api/v3"), get_server_url()),
    "https://github.example.com:80/"
  )
  expect_identical(
    withr::with_options(list(rdev.host = "https://user@github.com/api/v3"), get_server_url()),
    "https://user@github.com/"
  )
  expect_identical(
    withr::with_options(list(rdev.host = "https://user@github.com:80/api/v3"), get_server_url()),
    "https://user@github.com:80/"
  )
})

# use_rdev_package

test_that("use_rdev_package validates arguments", {
  withr::local_dir(withr::local_tempdir())
  mockery::stub(use_rdev_package, "gh::gh", NULL)

  expect_error(use_rdev_package(quiet = NA), "'quiet'")
})

# use_analysis_package

test_that("use_analysis_package validates arguments", {
  withr::local_dir(withr::local_tempdir())

  expect_error(use_analysis_package(use_quarto = NA), "'use_quarto'")
})

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
  values_quarto <- list(
    dirs = c(
      "analysis", "analysis/assets", "analysis/data", "analysis/import", "analysis/rendered",
      "docs"
    ), rbuildignore = c(
      "^analysis/.*\\.docx$", "^analysis/.*\\.html$", "^analysis/.*\\.md$", "^analysis/.*\\.pdf$",
      "^analysis/.*-figure$", "^analysis/import$", "^analysis/rendered$",
      "^docs$", "^\\.nojekyll$", "^\\.quarto$", "^_freeze$"
    ), gitignore = c(
      "analysis/*.docx", "analysis/*.html", "analysis/*.md", "analysis/*.pdf", "analysis/*-figure/",
      "analysis/import", "analysis/rendered", "/.quarto/"
    )
  )
  desc_urls <- c("https://example.github.io/package/", "https://github.com/example/package")
  author <- structure(list(list(
    given = "John", family = "Benninghoff", role = c("aut", "cre"), class = "person"
  )))
  mockery::stub(use_analysis_package, "fs::dir_create", NULL)
  mockery::stub(use_analysis_package, "usethis::use_git_ignore", NULL)
  mockery::stub(use_analysis_package, "readLines", NULL)
  mockery::stub(use_analysis_package, "writeLines", NULL)
  mockery::stub(use_analysis_package, "usethis::use_build_ignore", NULL)
  mockery::stub(use_analysis_package, "sort_rbuildignore", NULL)
  mockery::stub(use_analysis_package, "desc::desc_get_urls", desc_urls)
  mockery::stub(use_analysis_package, "get_github_repo", NULL)
  mockery::stub(use_analysis_package, "desc::desc_get_field", "Description")
  mockery::stub(use_analysis_package, "desc::desc_get_author", author)
  mockery::stub(use_analysis_package, "fs::file_create", NULL)
  mockery::stub(use_analysis_package, "fs::file_exists", FALSE)
  mockery::stub(use_analysis_package, "yaml::write_yaml", NULL)
  mockery::stub(use_analysis_package, "usethis::use_template", NULL)
  mockery::stub(use_analysis_package, "renv::install", NULL)
  mockery::stub(use_analysis_package, "usethis::use_package", NULL)
  mockery::stub(use_analysis_package, "renv::snapshot", NULL)

  expect_identical(use_analysis_package(use_quarto = FALSE), values)
  expect_identical(use_analysis_package(use_quarto = TRUE), values_quarto)
})

# use_rdev_pkgdown

test_that("use_rdev_pkgdown adds customizations", {
  withr::local_options(
    .new = list(rdev.license = NULL, rdev.license.copyright = NULL, rdev.github.actions = NULL)
  )
  usethis::ui_silence(local_temppkg(type = "rdev"))
  usethis::ui_silence(use_rdev_pkgdown())
  pkg <- yaml::read_yaml("_pkgdown.yml")

  expect_true(fs::file_exists("pkgdown/extra.css"))
  expect_identical(pkg$template$bootstrap, 5L)
})

test_that("use_rdev_pkgdown pauses when running interactively", {
  pkg <- list(url = NULL, template = list(bootstrap = 5L))
  desc_urls <- c("https://example.github.io/package/", "https://github.com/example/package")
  mockery::stub(use_rdev_pkgdown, "usethis::use_pkgdown", NULL)
  mockery::stub(use_rdev_pkgdown, "usethis::use_package", NULL)
  mockery::stub(use_rdev_pkgdown, "fs::dir_create", NULL)
  mockery::stub(use_rdev_pkgdown, "usethis::use_template", NULL)
  mockery::stub(use_rdev_pkgdown, "yaml::read_yaml", pkg)
  mockery::stub(use_rdev_pkgdown, "desc::desc_get_urls", desc_urls)
  mockery::stub(use_rdev_pkgdown, "yaml::write_yaml", NULL)
  mockery::stub(use_rdev_pkgdown, "sort_rbuildignore", NULL)

  expect_output(
    rlang::with_interactive(use_rdev_pkgdown(config_file = "_pkgdown.yml"), TRUE),
    "^\\nupdating _pkgdown\\.yml\\.\\.\\.done!$"
  )
  expect_silent(rlang::with_interactive(use_rdev_pkgdown(), FALSE))
})
