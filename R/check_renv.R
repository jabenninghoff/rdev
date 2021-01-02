#' Check renv
#'
#' Checks \code{renv} \code{status()}, \code{clean()}, and optionally \code{update()}
#'
#' @param update run \code{renv::update} (default \code{TRUE})
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
