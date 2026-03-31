\name{read_samples_sheet}
\alias{read_samples_sheet}
\title{read_samples_sheet}
\description{
Read a BAIA TSV sample sheet whose first header line may start with `#`, returning a plain data frame with character sample IDs preserved.
}
\details{
Read a BAIA TSV sample sheet whose first header line may start with `#`, returning a plain data frame with character sample IDs preserved. It belongs to the Sample-sheet helpers family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



read_samples_sheet(filename, column, verbose)
}
\arguments{
  \item{filename}{Optional output filename or path used when the helper writes a figure or result to disk.}
  \item{column}{Name of the column containing sample IDs or another key field.}
  \item{verbose}{Logical flag controlling progress messages or method-level verbosity.}
}
\value{
A structured R object such as a data frame, vector, list, or path bundle summarizing the requested information.
}
\examples{
\dontrun{
  read_samples_sheet("metadata/samples.tsv")
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
