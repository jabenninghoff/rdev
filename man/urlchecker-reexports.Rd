% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/urlchecker.R
\name{urlchecker-reexports}
\alias{urlchecker-reexports}
\alias{url_check}
\alias{url_update}
\title{Functions re-exported from the urlchecker package}
\usage{
url_check(
  path = ".",
  db = NULL,
  parallel = TRUE,
  pool = curl::new_pool(),
  progress = TRUE
)

url_update(path = ".", results = url_check(path))
}
\arguments{
\item{path}{Path to the package}

\item{db}{A url database}

\item{parallel}{If \code{TRUE}, check the URLs in parallel}

\item{pool}{A multi handle created by \code{\link[curl:multi]{curl::new_pool()}}. If \code{NULL} use a global pool.}

\item{progress}{Whether to show the progress bar for parallel checks}

\item{results}{results from \link[urlchecker]{url_check}.}
}
\description{
These functions are re-exported from the urlchecker package.
}
\details{
Follow the links below to see the urlchecker documentation.

\code{\link[urlchecker:url_check]{urlchecker::url_check()}}

\code{\link[urlchecker:url_update]{urlchecker::url_update()}}
}
