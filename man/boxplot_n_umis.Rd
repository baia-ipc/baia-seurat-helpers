\name{boxplot_n_umis}
\alias{boxplot_n_umis}
\title{boxplot_n_umis}
\description{
Plot sample-wise boxplots of log10 UMIs per cell.
}
\details{
Plot sample-wise boxplots of log10 UMIs per cell. It belongs to the QC plot constructors family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



boxplot_n_umis(so)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
}
\value{
A plot object or rendered plot representation suitable for interactive use or saving to disk.
}
\examples{
\dontrun{
  boxplot_n_umis(so)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
