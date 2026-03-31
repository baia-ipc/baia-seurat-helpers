\name{density_plot_n_genes}
\alias{density_plot_n_genes}
\title{density_plot_n_genes}
\description{
Plot the distribution of detected genes per cell across samples.
}
\details{
Plot the distribution of detected genes per cell across samples. It belongs to the QC plot constructors family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



density_plot_n_genes(so, plot_nrows)
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
  density_plot_n_genes(so)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
