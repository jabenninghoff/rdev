#' Quo Theme
#'
#' An opinionated [ggplot2][ggplot2::ggplot2-package] theme based on [ggplot2::theme_bw()]. Quo can
#'   be added to individual plots or set as the default theme using [viridis_quo()].
#'
#' Quo requires [Lato](https://www.latofonts.com), which can be installed on macOS using
#'   `brew install font-lato`.
#'
#' @export
#'
#' @examples
#' # adapted from ggplot2::theme_bw()
#' library(ggplot2)
#' library(showtext)
#'
#' font_add_google("Lato", "Lato")
#' showtext_auto()
#'
#' ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
#'   geom_point() +
#'   labs(
#'     title = "Fuel economy declines as weight increases",
#'     subtitle = "(1973-74)",
#'     caption = "Data from the 1974 Motor Trend US magazine.",
#'     tag = "Figure 1",
#'     x = "Weight (1000 lbs)",
#'     y = "Fuel economy (mpg)",
#'     color = "Gears"
#'   ) +
#'   theme_quo()
theme_quo <- function() {
  ggplot2::theme_bw() +
    ggplot2::theme(
      text = ggplot2::element_text(family = "Lato"),
      plot.title = ggplot2::element_text(face = "bold"),
      plot.subtitle = ggplot2::element_text(face = "bold"),
      plot.caption = ggplot2::element_text(hjust = 0)
    )
}

#' Viridis Quo
#'
#' Sets the default theme to [theme_quo()] and the default color scales to
#'   [`viridis`][ggplot2::scale_colour_viridis_d()].
#'
#' To reset the default theme and color scales, restart the R session.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' viridis_quo()
#' }
viridis_quo <- function() {
  ggplot2::theme_set(theme_quo())

  options(ggplot2.continuous.colour = "viridis")
  options(ggplot2.continuous.fill = "viridis")
  options(ggplot2.discrete.colour = ggplot2::scale_colour_viridis_d)
  options(ggplot2.discrete.fill = ggplot2::scale_fill_viridis_d)
}
