\name{subclustering_helpers}
\alias{celltype_highlight_info}
\alias{celltype_highlight_info_meta}
\alias{multi_celltype_dimplot}
\alias{feature_dimplot}
\alias{celltype_feature_dimplot}
\alias{grep_features}
\alias{compare_celltype_markers}
\alias{reorder_markers_by_pct_delta}
\alias{grep_markers}
\alias{celltype_expression_stats}
\alias{cell_cycle_phase_stats}
\alias{filter_variable_features_scimmune}
\alias{with_reduction_axes}
\alias{build_cluster_metric_violin_plot}
\title{Subclustering And Report-Ready Seurat Helpers}
\description{
Helpers collected from BAIA subclustering and integrated-visualization Rmds.
The pure helpers return vectors, tables, or summary statistics. The plotting
helpers return structured bundles with the plot object, suggested filename
stub, and default dimensions so that R Markdown code can assemble
`rmdreportdeck` assets without the package printing or exporting them
directly.
}
\usage{
celltype_highlight_info(so, celltype, celltype_col = "celltype",
  cluster_col = "harmsnn_res.1.2", reduction = "umapharm",
  highlight_color = "darkblue", other_color = "grey")

celltype_highlight_info_meta(so, celltype, metadata_col,
  cluster_col = "harmsnn_res.1.2", reduction = "umapharm",
  highlight_color = "darkblue", other_color = "grey")

multi_celltype_dimplot(so, celltypes, celltype_col = "celltype_m",
  reduction = "umapharm", colors_highlight = NULL,
  other_color = "lightgrey")

feature_dimplot(so, feature, reduction = "umapharm", order = TRUE)

celltype_feature_dimplot(so, celltype, feature,
  celltype_col = "celltype_m", reduction = "umapharm", order = TRUE)

grep_features(so, pattern, ignore.case = FALSE, fixed = FALSE)

compare_celltype_markers(so, celltype_a, celltype_b,
  celltype_col = "celltype_m", min.pct = 0.25,
  logfc.threshold = 1, p_adj_cutoff = 0.05)

reorder_markers_by_pct_delta(markers, pct_cols = c("pct.1", "pct.2"))

grep_markers(markers, pattern, rowname_col = NULL,
  ignore.case = FALSE, fixed = FALSE)

celltype_expression_stats(so, celltype, feature,
  celltype_col = "celltype_m")

cell_cycle_phase_stats(so, celltype, celltype_col = "celltype_m",
  phase_col = "Phase")

filter_variable_features_scimmune(variable_features,
  tcr_pattern = "^TR[AB][VC]", ig_pattern = "^IG[HLK][VDJ]",
  mito_pattern = "^MT", ribo_pattern = "^RP[LS]",
  immunoglobulin_extra = c("IGHM", "IGHD", "IGHE", "IGHA[12]",
    "IGHG[1234]", "IGKC", "IGLC[1234567]", "AC233755.1"),
  additional_exclude = "MALAT1")

with_reduction_axes(plot_obj, reduction_name = "UMAP", dims = c(1, 2))

build_cluster_metric_violin_plot(so, group_by, cluster_colors,
  resolution_label = NULL,
  metrics = c("nCount_RNA", "nFeature_RNA", "percent.mito"))
}
\arguments{
  \item{so}{Seurat object.}
  \item{celltype, celltype_a, celltype_b}{Cell-type value(s) to inspect or compare.}
  \item{celltype_col, metadata_col, cluster_col, group_by, phase_col}{Metadata columns used by the helper.}
  \item{reduction, reduction_name}{Reduction name used for plot labeling or feature plots.}
  \item{feature, pattern}{Feature name or grep pattern.}
  \item{markers, pct_cols}{Marker table and percentage columns for ranking/filtering.}
  \item{plot_obj}{Existing ggplot object to relabel.}
  \item{cluster_colors}{Named color vector for cluster-level violin plots.}
}
\value{
Either a pure R object such as a vector/data frame/numeric summary, or a list
containing plot-ready data with fields such as `plot`, `data`,
`filename_stub`, `default_width`, `default_height`, and `kind`.
}
\examples{
\dontrun{
info <- celltype_highlight_info(so, "B cells", celltype_col = "celltype")
bundle <- build_cluster_metric_violin_plot(so, "harmsnn_res.1.2", cluster_colors)
labels <- with_reduction_axes(bundle$plot, reduction_name = "UMAP Harmony")
}
}
