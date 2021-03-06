% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lint_all.R
\name{lint_all}
\alias{lint_all}
\title{Lint all files}
\usage{
lint_all(path = ".", exclusions = list(".git", ".github", "packrat", "renv"))
}
\arguments{
\item{path}{the path to the base directory, by default,
it will be searched in the parent directories of the current directory.}

\item{exclusions}{exclusions for \code{\link[lintr:exclude]{lintr::exclude()}}, relative to the
package path.}
}
\value{
A list of lint objects.
}
\description{
Lint all files in a project. Implemented as a wrapper for \code{\link[lintr:lint_dir]{lintr::lint_dir()}} that excludes
\code{.git}, \code{.github}, \code{packrat}, and \code{renv} by default.
}
\examples{
\dontrun{
lint_all()
lint_all("notebooks")
lint_all(
  path = "./inst",
  exclusions = list("inst/example/bad.R")
)
}
}
