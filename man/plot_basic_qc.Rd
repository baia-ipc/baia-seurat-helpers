\name{plot_basic_qc}
\alias{plot_basic_qc}
\title{plot_basic_qc}
\description{
Draw the BAIA basic QC three-panel violin and jitter view for mitochondrial percentage, genes, and UMIs.
}
\details{
Draw the BAIA basic QC three-panel violin and jitter view for mitochondrial percentage, genes, and UMIs. It belongs to the QC plot constructors family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



plot_basic_qc(so, title, colors, alpha)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
  \item{title}{Human-readable plot title or label used in rendered output.}
  \item{colors}{Vector of colors used for plot aesthetics.}
  \item{alpha}{Alpha transparency applied to plotted points or layers.}
}
\value{
A plot object or rendered plot representation suitable for interactive use or saving to disk.
}
\examples{
\dontrun{
  plot_basic_qc(so, title = "Raw QC")
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
