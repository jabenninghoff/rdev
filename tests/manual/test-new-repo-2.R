# Test script to validate creating a new rdev package or R analysis package
# Create repository and source this script from the new project after test-new-repo-1

repo_name <- "rdtest1"
repo_desc <- "rdev test package 1"

# assumes default options
host <- NULL
# assume the repo created under the currently logged in user
gh_login <- gh::gh_whoami(.api_url = host)$login
gh_server <- "github.com"
gh_pages_server <- paste0(gh_login, ".github.io")

# validate use_rdev_package() changes
gh_repo <- gh::gh(
  "GET /repos/{owner}/{repo}",
  owner = gh_login,
  repo = repo_name,
  .api_url = host
)
gh_pages <- gh::gh(
  "GET /repos/{owner}/{repo}/pages",
  owner = gh_login,
  repo = repo_name,
  .api_url = host
)
stopifnot(
  identical(
    gert::git_status(),
    structure(
      list(
        file = c(
          ".github/", ".gitignore", ".lintr", ".Rbuildignore", ".Rprofile", "DESCRIPTION",
          "LICENSE.md", "man/", "NEWS.md", "R/", "README.md", "README.Rmd", "renv.lock", "renv/",
          "tests/", "TODO.md"
        ),
        status = c(
          "new", "modified", "new", "modified", "new", "modified", "new", "new", "new", "new",
          "new", "new", "new", "new", "new", "new"
        ),
        staged = c(
          FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
          FALSE, FALSE, FALSE
        )
      ),
      row.names = c(NA, -16L),
      class = c("tbl_df", "tbl", "data.frame")
    )
  ),
  tail(readLines(".gitignore"), 4) == c("# macOS, vim", ".DS_Store", "*.swp", "~$*"),
  readLines(".Rbuildignore") == c(
    "^renv$", "^renv\\.lock$", "^\\.github$", "^\\.lintr$", "^\\.Rproj\\.user$", "^LICENSE\\.md$",
    "^rdtest1\\.Rproj$", "^README\\.Rmd$", "^TODO\\.md$"
  ),
  desc::desc_get(c("License", "URL", "BugReports", "Remotes")) == c(
    License = "MIT + file LICENSE",
    URL = paste0(
      "https://", gh_pages_server, "/", repo_name, ",\n    https://", gh_server, "/", gh_login, "/",
      repo_name
    ),
    BugReports = paste0("https://", gh_server, "/", gh_login, "/", repo_name, "/issues"),
    Remotes = "\n    jabenninghoff/rdev"
  ),
  gh_pages$source$branch == gh_repo$default_branch,
  gh_pages$source$path == "/docs",
  gh_repo$homepage == paste0("https://", gh_pages_server, "/rdtest1"),
  fs::file_info(".git/hooks/pre-commit")$permissions == structure(33252L, class = "fs_perms"),
  readLines(".git/hooks/pre-commit") == c(
    "#!/bin/bash",
    "# forked from https://github.com/r-lib/usethis/blob/main/inst/templates/readme-rmd-pre-commit.sh", # nolint: line_length_linter
    "README=($(git diff --cached --name-only | grep -Ei '^README\\.[R]?md$'))",
    "MSG=\"use 'git commit --no-verify' to override this check\"", "",
    "if [[ ${#README[@]} == 0 ]]; then", "  exit 0", "fi", "",
    "if [[ README.Rmd -nt README.md ]]; then",
    "  echo -e \"README.md is out of date; please re-knit README.Rmd\\n$MSG\"", "  exit 1", "fi"
  ),
  identical(
    gert::git_add("."),
    structure(
      list(
        file = c(
          ".github/.gitignore", ".github/workflows/check-standard.yaml",
          ".github/workflows/lint.yaml", ".gitignore", ".lintr", ".Rbuildignore", ".Rprofile",
          "DESCRIPTION", "LICENSE.md", "man/rdtest1-package.Rd", "NEWS.md", "R/package.R",
          "README.md", "README.Rmd", "renv.lock", "renv/.gitignore", "renv/activate.R",
          "renv/settings.dcf", "tests/testthat.R", "tests/testthat/test-package.R", "TODO.md"
        ),
        status = c(
          "new", "new", "new", "modified", "new", "modified", "new", "modified", "new", "new",
          "new", "new", "new", "new", "new", "new", "new", "new", "new", "new", "new"
        ),
        staged = c(
          TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
          TRUE, TRUE, TRUE, TRUE, TRUE, TRUE
        )
      ),
      row.names = c(NA, -21L), class = c("tbl_df", "tbl", "data.frame")
    )
  )
)
writeLines("3. use_rdev_package() changes")

# validate ci() and commit changes
gert::git_commit("rdev::use_rdev_package()")
ci()
gert::git_push()
