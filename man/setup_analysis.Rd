% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/init.R
\name{setup_analysis}
\alias{setup_analysis}
\title{Set up analysis package}
\usage{
setup_analysis(use_quarto = TRUE)
}
\arguments{
\item{use_quarto}{If \code{TRUE} (the default), use Quarto for publishing (\code{\link[=build_quarto_site]{build_quarto_site()}}),
otherwise use \code{\link[=build_analysis_site]{build_analysis_site()}}.}
}
\description{
Set up an analysis package within an rdev package newly initialized with \code{\link[=init]{init()}}, after updating
Title and Description in \code{DESCRIPTION}, by committing changes and running
\code{\link[=use_analysis_package]{use_analysis_package()}}, \code{\link[=use_spelling]{use_spelling()}}, and \code{\link[=ci]{ci()}}.
}
\details{
\code{setup_analysis()} will stop if \code{\link[rlang:is_interactive]{rlang::is_interactive()}} is \code{FALSE}, and will run \code{\link[=open_files]{open_files()}}
if running in RStudio.
}
\seealso{
\link{quickstart}
}
