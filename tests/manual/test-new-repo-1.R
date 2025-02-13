# Test script to validate creating a new rdev package or R analysis package
# Create repository and source this script from the new project

repo_name <- "rdtest1"
repo_desc <- "rdev test package 1"

# assumes default options
host <- NULL
# assume the repo created under the currently logged in user
gh_login <- gh::gh_whoami(.api_url = host)$login
gh_server <- "github.com"

# validate that repository is created and opened in RStudio, GitHub Desktop, and default browser
preconditions <- c(
  "Given:",
  "- rdev and dependencies are installed in the R site library (using `setup-r`)",
  "- Running in a session with no project open",
  "When:",
  "- Creating a new GitHub repository with the following command:",
  paste0('  `rdev::create_github_repo("', repo_name, '", "', repo_desc, '")`'),
  "Then:",
  paste0(
    '- A new rdev package named "', repo_name,
    '" is created in the active GitHub account, downloaded to the'
  ),
  "  local system, and populated with package files using usethis options in `~/.Rprofile`",
  "- The repository is opened as a new project in RStudio",
  "- On macOS, the repository is opened in GitHub Desktop",
  paste0(
    "- On macOS, the repository settings on ", gh_server, " are opened in the default browser"
  ),
  "- Re-running the create_github_repo command returns an error\n"
)
writeLines(preconditions)
writeLines("Manually validated?")
if (utils::menu(c("Yes", "No")) != 1) {
  stop("terminating script", call. = FALSE)
}
writeLines("\nValidated:")
writeLines("1. repository is created and opened in RStudio, GitHub Desktop, and default browser")

# validate branch protection, dependabot settings, git commits, git status
# assume that only the default branch is returned because the repo was just created
gh_branches <- gh::gh(
  "GET /repos/{owner}/{repo}/branches",
  owner = gh_login,
  repo = repo_name,
  .api_url = host
)
stopifnot(
  gh_branches[[1]]$protected,
  identical(
    gh_branches[[1]]$protection,
    list(
      enabled = TRUE,
      required_status_checks = list(
        enforcement_level = "non_admins",
        contexts = list(
          "lint", "macos-latest (release)", "missing-deps", "windows-latest (release)"
        ),
        checks = list(
          list(context = "lint", app_id = 15368L),
          list(context = "macos-latest (release)", app_id = 15368L),
          list(context = "missing-deps", app_id = 15368L),
          list(context = "windows-latest (release)", app_id = 15368L)
        )
      )
    )
  ),
  # returns 404 if vulnerability-alerts are not enabled
  gh::gh(
    "GET /repos/{owner}/{repo}/vulnerability-alerts",
    owner = gh_login,
    repo = repo_name,
    .api_url = host
  ) == "",
  # no method to check if automated-security-fixes are enabled
  nrow(gert::git_log()) == 1,
  gert::git_log()$message == "Initial commit",
  gert::git_ls()$path == c(".gitignore", "LICENSE"),
  identical(
    gert::git_status(),
    structure(
      list(
        file = c(".Rbuildignore", "DESCRIPTION", "NAMESPACE", "rdtest1.Rproj"),
        status = c("new", "new", "new", "new"),
        staged = c(FALSE, FALSE, FALSE, FALSE)
      ),
      row.names = c(NA, -4L),
      class = c("tbl_df", "tbl", "data.frame")
    )
  )
)
writeLines("2. branch protection, dependabot settings, git commits, git status")

# commit changes, run use_rdev_package()
gert::git_branch_create("package-setup")
gert::git_add(".")
gert::git_commit("rdev::create_github_repo()")
rdev::use_rdev_package()
