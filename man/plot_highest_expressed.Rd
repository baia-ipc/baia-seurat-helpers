\name{plot_highest_expressed}
\alias{plot_highest_expressed}
\title{plot_highest_expressed}
\description{
Show the highest-expressed genes as horizontal boxplots to identify dominating features.
}
\details{
Show the highest-expressed genes as horizontal boxplots to identify dominating features. It belongs to the QC plot constructors family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



plot_highest_expressed(so, nfeat2plot, boxplot_alpha, ylab_txt, colors)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
  \item{nfeat2plot}{Number of top features to include in the plot.}
  \item{boxplot_alpha}{Alpha transparency used for boxplot fills.}
  \item{ylab_txt}{Y-axis label to use in the rendered plot.}
  \item{colors}{Vector of colors used for plot aesthetics.}
}
\value{
A plot object or rendered plot representation suitable for interactive use or saving to disk.
}
\examples{
\dontrun{
  plot_highest_expressed(so, nfeat2plot = 20)
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
