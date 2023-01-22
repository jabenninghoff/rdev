# Test script to validate creating a new rdev package or R analysis package
# Create repository and source this script from the new project after test-new-repo-2

repo_name <- "rdtest1"
repo_desc <- "rdev test package 1"

# assumes default options
host <- NULL
# assume the repo created under the currently logged in user
gh_login <- gh::gh_whoami(.api_url = host)$login
gh_server <- "github.com"
gh_pages_server <- paste0(gh_login, ".github.io")

# validate use_analysis_package()
use_analysis_package()
stopifnot(
  identical(
    gert::git_status(),
    structure(
      list(
        file = c(
          ".gitignore", ".Rbuildignore", "DESCRIPTION", "pkgdown/", "README.Rmd", "renv.lock"
        ),
        status = c("modified", "modified", "modified", "new", "modified", "modified"),
        staged = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
      ),
      row.names = c(NA, -6L), class = c("tbl_df", "tbl", "data.frame")
    )
  ),
  tail(readLines(".gitignore"), 9) == c(
    "# analysis package generated files",
    "# see: https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html",
    "analysis/*.docx", "analysis/*.html", "analysis/*.md", "analysis/*.pdf", "analysis/*-figure/",
    "analysis/import", "analysis/rendered"
  ),
  readLines("pkgdown/_base.yml") == paste0("url: https://", gh_pages_server, "/", repo_name),
  readLines("README.Rmd")[[34]] == "## Notebooks"
)
writeLines("4a. usethis::use_analysis_package() changes")

# validate ci() and commit changes
gert::git_add(".")
gert::git_commit("rdev::use_analysis_package()")
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
writeLines("5a. rdev::use_spelling() changes")

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
    "    runs-on: macos-latest", "    env:", "      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}", "",
    "    steps:", "      - uses: actions/checkout@v2", "", "      - uses: r-lib/actions/setup-r@v2",
    "", "      - uses: r-lib/actions/setup-renv@v2", "",
    "      - uses: r-lib/actions/setup-pandoc@v2", "", "      - name: Test coverage",
    "        run: covr::codecov()", "        shell: Rscript {0}"
  )
)
writeLines("6a. rdev::use_codecov() changes")

# validate ci() and commit changes
check_renv()
gert::git_add(".")
gert::git_commit("rdev::use_codecov()")
ci()

# validate build_analysis_site()
stopifnot(
  testthat::expect_error(build_analysis_site())$message == "No *.Rmd files in analysis directory"
)
writeLines(
  c(
    "---", "title: \"R Notebook\"", "output: html_notebook", "date: '2022-04-07'", "---", "",
    "This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. ",
    "", "```{r}", "plot(cars)", "```"
  ),
  "analysis/test.Rmd"
)
build_analysis_site()
fs::dir_delete("docs")
fs::file_delete("_pkgdown.yml")
fs::file_delete("analysis/test.Rmd")
gert::git_reset_hard()
writeLines("7a. build_analysis_site() works")
