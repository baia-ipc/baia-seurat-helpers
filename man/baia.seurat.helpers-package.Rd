\name{baia.seurat.helpers-package}
\alias{baia.seurat.helpers}
\alias{baia.seurat.helpers-package}
\title{Reusable Seurat helper functions for BAIA scRNA-seq analyses}
\description{
`baia.seurat.helpers` is the base BAIA package for reusable Seurat-oriented
single-cell infrastructure. Its role is intentionally broad but still focused:
it owns generic helper code that is useful across many scRNA-seq and
multi-omics projects before the analysis branches into domain-specific layers
such as CITE-seq, pseudobulk DE, pathway analysis, or CellChat.

In practice, the package provides four kinds of functionality:

- sample-sheet handling for project metadata tables
- Seurat object compatibility and merge preparation helpers
- reusable QC annotation and diagnostics
- small plotting utilities used repeatedly across BAIA analyses

It does not own CITE-seq-specific ingestion, demultiplexing, pathway analysis,
or cell-cell communication logic. Those belong in the other BAIA packages.
}
\details{
This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.

Function families covered by this package include:
- Sample-sheet helpers
- Seurat object compatibility and merge preparation
- QC annotation and diagnostics
- QC plot constructors
- Visualization utilities
}
\docType{package}
\examples{
vignette("getting-started", package = "baia.seurat.helpers")
vignette("workflow", package = "baia.seurat.helpers")
}
