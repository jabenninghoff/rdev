% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/release.R
\name{new_branch}
\alias{new_branch}
\title{Start a new branch}
\usage{
new_branch(name, bump_ver = TRUE, current = FALSE)
}
\arguments{
\item{name}{name of the new branch.}

\item{bump_ver}{if \code{TRUE}, bump 'dev' version to 9000, see details.}

\item{current}{create new branch from the currently active branch (\code{TRUE}) or from the default
branch (\code{FALSE}), see details.}
}
\description{
Create a new "feature" branch from the current or default branch of the project git repository
using \code{\link[gert:git_branch]{gert::git_branch_create()}} and bump 'dev' version to 9000 with
\code{\link[desc:desc_bump_version]{desc::desc_bump_version()}}.
}
\details{
The new branch will be created and checked out if it does not exist on local or remote. If the
version in DESCRIPTION has 3 components (a release version) and \code{bump_ver} is \code{TRUE} (the
default), the fourth component, 'dev' will be bumped to 9000 and checked in to the new branch.

If the version already has 4 components, it is not changed.

If \code{current = FALSE} (the default), the new branch will be created from the default branch as
determined by \code{\link[usethis:git-default-branch]{usethis::git_default_branch()}}.
}
