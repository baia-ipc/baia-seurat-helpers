\name{test_cell_cycle_effect}
\alias{test_cell_cycle_effect}
\title{test_cell_cycle_effect}
\description{
Run BAIA's standard cell-cycle scoring and PCA diagnostic workflow to judge whether cell-cycle effects need explicit handling.
}
\details{
Run BAIA's standard cell-cycle scoring and PCA diagnostic workflow to judge whether cell-cycle effects need explicit handling. It belongs to the QC annotation and diagnostics family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



test_cell_cycle_effect(so, so_label, s_genes, g2m_genes, verbose, showplots)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
  \item{so_label}{Short label used in console output and plot titles.}
  \item{s_genes}{Character vector of S-phase genes present in the dataset namespace.}
  \item{g2m_genes}{Character vector of G2/M-phase genes present in the dataset namespace.}
  \item{verbose}{Logical flag controlling progress messages or method-level verbosity.}
  \item{showplots}{Logical flag indicating whether diagnostic plots should be shown.}
}
\value{
An R object implementing the behavior described for test_cell_cycle_effect .
}
\examples{
\dontrun{
  test_cell_cycle_effect(so, "sampleA", s_genes, g2m_genes, showplots = TRUE)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
