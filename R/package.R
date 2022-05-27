#' @keywords internal
"_PACKAGE"

# Per https://rdatatable.gitlab.io/data.table/articles/datatable-importing.html, rdev must be
# data.table aware. Otherwise, running build_analysis_site() with notebooks containing data.table
# will fail with errors described in the links below:
# https://stackoverflow.com/questions/30601332/data-table-assignment-by-reference-within-function
# https://stackoverflow.com/questions/10527072/using-data-table-package-inside-my-own-package
.datatable.aware <- TRUE # nolint: object_name_linter

# Suppress R CMD check note
#' @importFrom markdown renderMarkdown
#' @importFrom miniUI miniPage
NULL
