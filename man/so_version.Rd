\name{so_version}
\alias{so_version}
\title{so_version}
\description{
Return the major Seurat object version as `"4"` or `"5"` and fail early on unsupported objects.
}
\details{
Return the major Seurat object version as `"4"` or `"5"` and fail early on unsupported objects. It belongs to the Seurat object compatibility and merge preparation family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



so_version(so)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
}
\value{
An R object implementing the behavior described for so_version .
}
\examples{
\dontrun{
  so_version(so)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
