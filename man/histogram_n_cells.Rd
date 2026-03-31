\name{histogram_n_cells}
\alias{histogram_n_cells}
\title{histogram_n_cells}
\description{
Plot the number of cells per sample.
}
\details{
Plot the number of cells per sample. It belongs to the QC plot constructors family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



histogram_n_cells(so)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
}
\value{
An R object implementing the behavior described for histogram_n_cells .
}
\examples{
\dontrun{
  histogram_n_cells(so)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
