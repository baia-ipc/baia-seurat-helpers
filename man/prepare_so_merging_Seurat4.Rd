\name{prepare_so_merging_Seurat4}
\alias{prepare_so_merging_Seurat4}
\title{prepare_so_merging_Seurat4}
\description{
Legacy Seurat v4-specific merge preparation helper with optional verbose logging.
}
\details{
Legacy Seurat v4-specific merge preparation helper with optional verbose logging. It belongs to the Seurat object compatibility and merge preparation family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



prepare_so_merging_Seurat4(so, verbose)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
  \item{verbose}{Logical flag controlling progress messages or method-level verbosity.}
}
\value{
An updated object of the same general class as the input, with the requested annotations or structural changes applied.
}
\examples{
\dontrun{
  prepare_so_merging_Seurat4(so, verbose = TRUE)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
