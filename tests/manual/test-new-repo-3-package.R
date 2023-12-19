# Test script to validate creating a new rdev package or R analysis package
# Create repository and source this script from the new project after test-new-repo-2

repo_name <- "rdtest1"
repo_desc <- "rdev test package 1"

# validate rdev::use_rdev_pkgdown()
rdev::use_rdev_pkgdown()
stopifnot(
  identical(
    gert::git_status(),
    structure(
      list(
        file = c("_pkgdown.yml", ".gitignore", ".Rbuildignore", "DESCRIPTION", "pkgdown/"),
        status = c("new", "modified", "modified", "modified", "new"),
        staged = c(FALSE, FALSE, FALSE, FALSE, FALSE)
      ),
      row.names = c(NA, -5L), class = c("tbl_df", "tbl", "data.frame")
    )
  ),
  tail(readLines(".gitignore"), 1) == "docs"
)
writeLines("4p. rdev::use_rdev_pkgdown() changes")

# validate ci() and commit changes
gert::git_add(".")
gert::git_commit("rdev::use_rdev_pkgdown()")
ci()

# validate use_spelling()
use_spelling()
stopifnot(
  identical(
    gert::git_status(),
    structure(
      list(
        file = c(
          "DESCRIPTION", "inst/", "tests/spelling.R", "tests/testthat/test-spelling.R"
        ),
        status = c("modified", "new", "new", "new"),
        staged = c(FALSE, FALSE, FALSE, FALSE)
      ),
      row.names = c(NA, -4L), class = c("tbl_df", "tbl", "data.frame")
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
  head(readLines(".github/workflows/test-coverage.yaml"), 1) ==
    "# Workflow derived from https://github.com/r-lib/actions/tree/v2/examples"
)
writeLines("6p. rdev::use_codecov() changes")

# validate ci() and commit changes
check_renv()
gert::git_add(".")
gert::git_commit("rdev::use_codecov()")
ci()
