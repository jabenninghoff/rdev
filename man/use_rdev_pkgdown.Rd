% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setup.R
\name{use_rdev_pkgdown}
\alias{use_rdev_pkgdown}
\title{Use rdev pkgdown}
\usage{
use_rdev_pkgdown(config_file = "_pkgdown.yml", destdir = "docs")
}
\arguments{
\item{config_file}{Path to the pkgdown yaml config file, relative to the
project.}

\item{destdir}{Target directory for pkgdown docs.}
}
\description{
Add pkgdown with rdev customizations. Implemented as a wrapper for \code{\link[usethis:use_pkgdown]{usethis::use_pkgdown()}}.
}
\details{
In addition to running \code{\link[usethis:use_pkgdown]{usethis::use_pkgdown()}}, \code{use_rdev_pkgdown} adds \code{extra.css} to
\code{pkgdown} to fix rendering of GitHub-style
\href{https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/about-task-lists}{task lists},
adds the GitHub Pages URL, and enables
\href{https://pkgdown.r-lib.org/articles/customise.html#light-switch}{\code{template.light-switch}}.
}
