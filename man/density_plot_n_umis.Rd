\name{density_plot_n_umis}
\alias{density_plot_n_umis}
\title{density_plot_n_umis}
\description{
Plot the distribution of UMIs per cell, split by sample.
}
\details{
Plot the distribution of UMIs per cell, split by sample. It belongs to the QC plot constructors family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



density_plot_n_umis(so, plot_nrows)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
  \item{plot_nrows}{Number of facet rows used when the plot is split by sample.}
}
\value{
A plot object or rendered plot representation suitable for interactive use or saving to disk.
}
\examples{
\dontrun{
  density_plot_n_umis(so)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
