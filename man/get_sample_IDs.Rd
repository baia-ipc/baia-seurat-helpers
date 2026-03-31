\name{get_sample_IDs}
\alias{get_sample_IDs}
\title{get_sample_IDs}
\description{
Extract sample IDs from a sample sheet data frame or directly from the TSV path.
}
\details{
Extract sample IDs from a sample sheet data frame or directly from the TSV path. It belongs to the Sample-sheet helpers family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



get_sample_IDs(samples_sheet, column, verbose)
}
\arguments{
  \item{samples_sheet}{Sample sheet data frame or path to a sample sheet TSV file.}
  \item{column}{Name of the column containing sample IDs or another key field.}
  \item{verbose}{Logical flag controlling progress messages or method-level verbosity.}
}
\value{
An R object implementing the behavior described for get_sample_IDs .
}
\examples{
\dontrun{
  get_sample_IDs("metadata/samples.tsv", verbose = FALSE)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
