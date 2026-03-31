\name{qc_distri_plot}
\alias{qc_distri_plot}
\title{qc_distri_plot}
\description{
Build a generic histogram for one named QC metric present in `meta.data`.
}
\details{
Build a generic histogram for one named QC metric present in `meta.data`. It belongs to the QC plot constructors family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



qc_distri_plot(so, measure)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
  \item{measure}{Name of the metadata or QC measure to plot.}
}
\value{
A plot object or rendered plot representation suitable for interactive use or saving to disk.
}
\examples{
\dontrun{
  qc_distri_plot(so, "nFeature_RNA")
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
