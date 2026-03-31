\name{split_print_legend}
\alias{split_print_legend}
\title{split_print_legend}
\description{
Print a ggplot without its legend and then draw the legend separately, useful for manual report layout.
}
\details{
Print a ggplot without its legend and then draw the legend separately, useful for manual report layout. It belongs to the Visualization utilities family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



split_print_legend(plt)
}
\arguments{
  \item{plt}{Plot object to modify, print, or draw.}
}
\value{
An R object implementing the behavior described for split_print_legend .
}
\examples{
\dontrun{
  split_print_legend(plt)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
