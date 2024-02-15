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
          "_quarto.yml", ".gitignore", ".nojekyll", ".Rbuildignore", "analysis/", "changelog.qmd",
          "DESCRIPTION", "index.qmd", "README.Rmd", "renv.lock"
        ),
        status = c(
          "new", "modified", "new", "modified", "new", "new",
          "modified", "new", "modified", "modified"
        ),
        staged = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
      ),
      row.names = c(NA, -10L), class = c("tbl_df", "tbl", "data.frame")
    )
  ),
  tail(readLines(".gitignore"), 10) == c(
    "# analysis package generated files",
    "# see: https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html",
    "analysis/*.docx", "analysis/*.html", "analysis/*.md", "analysis/*.pdf", "analysis/*-figure/",
    "analysis/import", "analysis/rendered", "/.quarto/"
  ),
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
  head(readLines(".github/workflows/test-coverage.yaml"), 1) ==
    "# Workflow derived from https://github.com/r-lib/actions/tree/v2/examples"
)
writeLines("6a. rdev::use_codecov() changes")

# validate ci() and commit changes
check_renv()
gert::git_add(".")
gert::git_commit("rdev::use_codecov()")
ci()

# validate build_quarto_site()
stopifnot(
  testthat::expect_error(build_quarto_site())$message == "no *.Rmd files in analysis directory"
)
writeLines(
  c(
    "---", "title: \"R Notebook\"", "output: html_notebook", "date: '2022-04-07'", "---", "",
    "This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. ",
    "", "```{r}", "plot(cars)", "```"
  ),
  "analysis/test.Rmd"
)
build_quarto_site()
fs::dir_delete("docs")
fs::dir_delete("_freeze")
fs::file_delete("analysis/test.Rmd")
gert::git_reset_hard()
writeLines("7a. build_quarto_site() works")
