# Test script to validate creating a new rdev package or R analysis package
# Create repository and run this script from the new project

# validate that repository is created and opened in RStudio, GitHub Desktop, and default browser
preconditions <- c(
  "Given:",
  "- rdev and dependencies are installed in the R site library (using `setup-r`)",
  "- Running in a session with no project open",
  "When:",
  "- Creating a new GitHub repository with the following command:",
  '  `rdev::create_github_repo("rdtest1", "rdev test package 1")`',
  "Then:",
  '- A new rdev package named "rdtest1" is created in the active GitHub account, downloaded to the',
  "  local system, and populated with package files using usethis options in `~/.Rprofile`",
  "- The repository is opened as a new project in RStudio",
  "- On macOS, the repository is opened in GitHub Desktop",
  "- On macOS, the repository settings on github.com are opened in the default browser",
  "- Re-running the create_github_repo command returns an error"
)
writeLines(preconditions)
writeLines("\nManually validated?")
if (utils::menu(c("Yes", "No")) != 1) {
  stop("terminating script")
}
