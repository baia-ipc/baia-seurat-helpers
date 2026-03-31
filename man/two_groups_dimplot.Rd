\name{two_groups_dimplot}
\alias{two_groups_dimplot}
\title{two_groups_dimplot}
\description{
Highlight two metadata-defined groups on the same Seurat dimensionality reduction plot.
}
\details{
Highlight two metadata-defined groups on the same Seurat dimensionality reduction plot. It belongs to the Visualization utilities family in baia.seurat.helpers and follows the package semantics described in the package vignettes. This package is the generic Seurat helper layer for BAIA single-cell projects and should be used before moving into CITE-seq, DE, pathway, or CellChat-specific analysis.
}
\usage{



two_groups_dimplot(so, grp1, grp2, grpcol, group_names, colors_highlight, size_highlight, base_color, pt_size, split_by, title, reduction_method, x_label, y_label, font_size, legend_position)
}
\arguments{
  \item{so}{Seurat object to annotate, summarize, or plot.}
  \item{grp1}{First group value to highlight in the dimensionality reduction plot.}
  \item{grp2}{Second group value to highlight in the dimensionality reduction plot.}
  \item{grpcol}{Metadata column used to define the two highlighted groups.}
  \item{group_names}{Optional display names for the highlighted groups.}
  \item{colors_highlight}{Colors used for the highlighted groups.}
  \item{size_highlight}{Point size for highlighted cells.}
  \item{base_color}{Color used for non-highlighted cells.}
  \item{pt_size}{Base point size for the underlying dimensionality reduction plot.}
  \item{split_by}{Optional metadata column used to split the plot into panels.}
  \item{title}{Human-readable plot title or label used in rendered output.}
  \item{reduction_method}{Name of the dimensionality reduction stored on the Seurat object.}
  \item{x_label}{Label shown on the x-axis.}
  \item{y_label}{Label shown on the y-axis.}
  \item{font_size}{Base font size used in the plot theme.}
  \item{legend_position}{Legend placement used in the plot theme.}
}
\value{
A plot object or rendered plot representation suitable for interactive use or saving to disk.
}
\examples{
\dontrun{
  two_groups_dimplot(so, grp1 = "DHF", grp2 = "DF", grpcol = "WHO_classification")
}
}
\seealso{
\code{\link{baia.seurat.helpers}}.
Use \code{vignette("getting-started", package = "baia.seurat.helpers")} and \code{vignette("workflow", package = "baia.seurat.helpers")} for fuller workflows.
}
