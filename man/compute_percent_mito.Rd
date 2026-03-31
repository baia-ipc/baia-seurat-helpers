\name{compute_percent_mito}
\alias{compute_percent_mito}
\title{compute_percent_mito}
\description{
Add `percent.mito` and `percent.mito.cl` metadata based on a supplied vector of mitochondrial gene names.
}
\details{
Add `percent.mito` and `percent.mito.cl` metadata based on a supplied vector of mitochondrial gene names. It belongs to the QC annotation and diagnostics family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



compute_percent_mito(so, mitoGenes)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
  \item{mitoGenes}{Character vector of mitochondrial gene names used to compute mitochondrial percentage.}
}
\value{
An updated object of the same general class as the input, with the requested annotations or structural changes applied.
}
\examples{
\dontrun{
  compute_percent_mito(so, mitoGenes = grep("^MT-", rownames(so), value = TRUE))
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
