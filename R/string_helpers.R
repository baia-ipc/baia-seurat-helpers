#'
#' String helper functions.
#'

# Licence: CC-BY-SA
# (c) Giorgio Gonnella, 2023-2026

#' Sanitize a string for filesystem-friendly names
#'
#' Replaces non-alphanumeric characters with underscores, then replaces spaces
#' with underscores.
#'
#' @param s Character vector to sanitize.
#'
#' @return A character vector with sanitized strings.
#' @export
strsanitize <- function(s) {
  gsub(" ", "_", gsub("[^[:alnum:]]", "_", s))
}
