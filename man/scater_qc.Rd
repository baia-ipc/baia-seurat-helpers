\name{scater_qc}
\alias{scater_qc}
\title{scater_qc}
\description{
Compute `scater`-style per-cell QC metrics and outlier flags and append them to Seurat metadata.
}
\details{
Compute `scater`-style per-cell QC metrics and outlier flags and append them to Seurat metadata. It belongs to the QC annotation and diagnostics family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



scater_qc(so)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
}
\value{
An updated object of the same general class as the input, with the requested annotations or structural changes applied.
}
\examples{
\dontrun{
  scater_qc(so)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
