#' @keywords internal
"_PACKAGE"

# Per https://rdatatable.gitlab.io/data.table/articles/datatable-importing.html, rdev must be
# data.table aware. Otherwise, running build_analysis_site() with notebooks containing data.table
# will fail with errors described in the links below:
# https://stackoverflow.com/questions/30601332/data-table-assignment-by-reference-within-function
# https://stackoverflow.com/questions/10527072/using-data-table-package-inside-my-own-package
# https://github.com/Rdatatable/data.table/blob/master/R/cedta.R explicitly allows packages like
# knitr and rmarkdown that run user code. One option would be to add rdev to cedta.pkgEvalsUserCode,
# but it's easier and simpler to just use .datatable.aware here.
.datatable.aware <- TRUE # nolint: object_name_linter.

# Suppress R CMD check note
#' @importFrom miniUI miniPage
NULL
