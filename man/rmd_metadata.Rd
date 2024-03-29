% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/to_document.R
\name{rmd_metadata}
\alias{rmd_metadata}
\title{Get analysis notebook metadata}
\usage{
rmd_metadata(file_path)
}
\arguments{
\item{file_path}{Path to analysis notebook}
}
\value{
Named list containing analysis notebook title, URL, date, and description
}
\description{
Extract the YAML front matter and 'description' line from an
\href{https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.html}{analysis notebook},
and construct a URL to the notebook's location on GitHub pages.
}
\details{
The 'description' line is the the first non-blank line in the body of an R notebook that serves
as a brief description of the work.

If \verb{_quarto.yml} is present, \code{rmd_metadata()} will extract the YAML front matter and description
from Quarto format (\code{.qmd}) notebooks.
}
