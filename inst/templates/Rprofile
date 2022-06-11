source("renv/activate.R")
options(styler.cache_root = "styler-perm")

# attach devtools and set options per https://r-pkgs.org/setup.html
if (interactive()) {
  suppressMessages(require(devtools))
  suppressMessages(require(rdev))
  if (!suppressMessages(suppressWarnings(require(pkgload::pkg_name("."), character.only = TRUE)))) {
    devtools::load_all(".")
  }
}
