options(
  warnPartialMatchArgs = TRUE,
  warnPartialMatchAttr = TRUE,
  warnPartialMatchDollar = TRUE,
  # TODO: workaround for issue fixed in renv 1.2.5+ (https://github.com/rstudio/renv/pull/2348)
  # renv.config.crandb.enabled = TRUE,
  rdev.license.copyright = "John Benninghoff",
  styler.cache_root = "styler-perm"
)

source("renv/activate.R")

# attach devtools and set options per https://r-pkgs.org/setup.html
if (interactive()) {
  suppressMessages(require(devtools))
  if (!suppressMessages(suppressWarnings(require(pkgload::pkg_name("."), character.only = TRUE)))) {
    devtools::load_all(".")
  }
  # install pre-commit git hook when cloning repository
  if (!fs::file_exists(".git/hooks/pre-commit")) {
    cat("git hook pre-commit missing, installing...\n")
    usethis::use_git_hook(
      "pre-commit", readLines(fs::path_package("rdev", "templates", "pre-commit"))
    )
  }
  # warn if pandoc not found in PATH
  if (Sys.which("pandoc") == "") warning("pandoc not found, run `open /Applications/RStudio.app`")
}
