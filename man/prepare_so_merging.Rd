\name{prepare_so_merging}
\alias{prepare_so_merging}
\title{prepare_so_merging}
\description{
Strip a Seurat object down to RNA counts and metadata needed for later merging, removing assays, embeddings, graphs, and SCT leftovers.
}
\details{
Strip a Seurat object down to RNA counts and metadata needed for later merging, removing assays, embeddings, graphs, and SCT leftovers. It belongs to the Seurat object compatibility and merge preparation family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



prepare_so_merging(so)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
}
\value{
An updated object of the same general class as the input, with the requested annotations or structural changes applied.
}
\examples{
\dontrun{
  prepare_so_merging(so)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
