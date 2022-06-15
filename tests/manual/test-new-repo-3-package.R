# Test script to validate creating a new rdev package or R analysis package
# Create repository and source this script from the new project after test-new-repo-2

repo_name <- "rdtest1"
repo_desc <- "rdev test package 1"

# validate usethis::use_pkgdown()
usethis::use_pkgdown()
sort_rbuildignore()
stopifnot(
  identical(
    gert::git_status(),
    structure(
      list(
        file = c("_pkgdown.yml", ".gitignore", ".Rbuildignore"),
        status = c("new", "modified", "modified"),
        staged = c(FALSE, FALSE, FALSE)
      ),
      row.names = c(NA, -3L), class = c("tbl_df", "tbl", "data.frame")
    )
  ),
  tail(readLines(".gitignore"), 1) == "docs"
)
writeLines("4p. usethis::use_pkgdown() changes")

# validate ci() and commit changes
gert::git_add(".")
gert::git_commit("usethis::use_pkgdown()")
ci()

# validate use_spelling()
use_spelling()
stopifnot(
  identical(
    gert::git_status(),
    structure(
      list(
        file = c(
          "DESCRIPTION", "inst/", "renv.lock", "tests/spelling.R", "tests/testthat/test-spelling.R"
        ),
        status = c("modified", "new", "modified", "new", "new"),
        staged = c(FALSE, FALSE, FALSE, FALSE, FALSE)
      ),
      row.names = c(NA, -5L), class = c("tbl_df", "tbl", "data.frame")
    )
  ),
  desc::desc_get_field("Language") == "en-US",
  readLines("inst/WORDLIST") == c("CMD", "Changelog", "ORCID", "rdtest", "renv"),
  readLines("tests/spelling.R") == c(
    "if (requireNamespace(\"spelling\", quietly = TRUE)) {",
    "  spelling::spell_check_test(vignettes = TRUE, error = TRUE, skip_on_cran = TRUE)",
    "}"
  )
)
writeLines("5p. rdev::use_spelling() changes")

# validate ci() and commit changes
check_renv()
gert::git_add(".")
gert::git_commit("rdev::use_spelling()")
ci()

# validate use_codecov()
use_codecov()
stopifnot(
  identical(
    gert::git_status(),
    structure(
      list(
        file = c(
          ".github/workflows/test-coverage.yaml", ".Rbuildignore", "codecov.yml", "DESCRIPTION",
          "README.Rmd", "renv.lock"
        ),
        status = c("new", "modified", "new", "modified", "modified", "modified"),
        staged = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
      ),
      row.names = c(NA, -6L), class = c("tbl_df", "tbl", "data.frame")
    )
  ),
  readLines(".github/workflows/test-coverage.yaml") == c(
    "# Workflow derived from https://github.com/r-lib/actions/tree/v2/examples",
    "# Need help debugging build failures? Start at https://github.com/r-lib/actions#where-to-find-help", # nolint: line_length_linter.
    "on:", "  push:", "    branches: [main, master]", "  pull_request:",
    "    branches: [main, master]", "", "name: test-coverage", "", "jobs:", "  test-coverage:",
    "    runs-on: macOS-latest", "    env:", "      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}", "",
    "    steps:", "      - uses: actions/checkout@v2", "", "      - uses: r-lib/actions/setup-r@v2",
    "", "      - uses: r-lib/actions/setup-renv@v2", "",
    "      - uses: r-lib/actions/setup-pandoc@v2", "", "      - name: Test coverage",
    "        run: covr::codecov()", "        shell: Rscript {0}"
  )
)
writeLines("6p. rdev::use_codecov() changes")

# validate ci() and commit changes
check_renv()
gert::git_add(".")
gert::git_commit("rdev::use_codecov()")
ci()
