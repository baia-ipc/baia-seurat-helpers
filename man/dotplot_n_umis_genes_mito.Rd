\name{dotplot_n_umis_genes_mito}
\alias{dotplot_n_umis_genes_mito}
\title{dotplot_n_umis_genes_mito}
\description{
Plot UMIs versus genes, colored by mitochondrial ratio, as a compact joint QC view.
}
\details{
Plot UMIs versus genes, colored by mitochondrial ratio, as a compact joint QC view. It belongs to the QC plot constructors family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



dotplot_n_umis_genes_mito(so, plot_nrows)
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
  dotplot_n_umis_genes_mito(so)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
