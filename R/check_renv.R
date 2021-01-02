#' Check renv
#'
#' Checks [`renv`][renv::renv-package] [`status()`][renv::status()], [`clean()`][renv::clean()], and
#'   optionally [`update()`][renv::update()]
#'
#' @param update run [renv::update()]
#' @export check_renv
#' @examples
#' \dontrun{
#' check_renv()
#' check_renv(update = FALSE)
#' }
check_renv <- function(update = TRUE) {
  writeLines("renv::status()")
  renv::status()

  writeLines("\nrenv::clean()")
  renv::clean()

  if (update) {
    writeLines("\nrenv::update()")
    renv::update()
  }
}
