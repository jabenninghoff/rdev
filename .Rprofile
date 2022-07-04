source("renv/activate.R")

options(
  warnPartialMatchArgs = TRUE,
  warnPartialMatchAttr = TRUE,
  warnPartialMatchDollar = TRUE,
  styler.cache_root = "styler-perm"
)

# attach devtools and set options per https://r-pkgs.org/setup.html
if (interactive()) {
  suppressMessages(require(devtools))
  if (!suppressMessages(suppressWarnings(require(pkgload::pkg_name("."), character.only = TRUE)))) {
    devtools::load_all(".")
  }
}
