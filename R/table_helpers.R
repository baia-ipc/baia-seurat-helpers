#
# Generic table-shaping helpers used across BAIA summary (Sxx) reports.
#

#' Per-gene, per-group expression summary statistics
#'
#' For each gene, computes the number of cells, percent expressing (value >
#' 0), mean and median expression within each level of `group_col`. The
#' standard "is this marker expressed where expected" summary used across QC
#' and marker-expression panels.
#'
#' @param so Seurat object.
#' @param genes Character vector of gene names; silently intersected with
#'   `rownames(so)` (missing genes are dropped, not errored on).
#' @param group_col Metadata column to group cells by.
#' @param assay,layer Assay/layer to pull expression from.
#'
#' @return A data frame with columns `gene`, `group`, `n_cells`,
#'   `pct_positive`, `mean_expr`, `median_expr` - one row per gene x group
#'   combination - or `NULL` if none of `genes` are present in `so`.
#' @export
expr_stats <- function(so, genes, group_col, assay = "RNA", layer = "data") {
  genes <- intersect(genes, rownames(so))
  if (!length(genes)) return(NULL)
  expr <- SeuratObject::LayerData(so, assay = assay, layer = layer)[genes, , drop = FALSE]
  as.data.frame(do.call(rbind, lapply(genes, function(g) {
    d <- data.frame(gene = g, group = so@meta.data[[group_col]], value = as.numeric(expr[g, ]))
    dplyr::summarise(dplyr::group_by(d, gene, group),
                     n_cells      = dplyr::n(),
                     pct_positive = round(100 * mean(value > 0), 1),
                     mean_expr    = round(mean(value), 3),
                     median_expr  = round(median(value), 3),
                     .groups = "drop")
  })))
}

#' Pivot a long-format table to a wide "value (pct%)"-style display table
#'
#' Formats `value_col`/`pct_col` into a single display string per row, then
#' pivots to one row per `id_cols` combination and one column per
#' `names_from` category - the "horizontalize for easy row-scanning"
#' convention used throughout BAIA summary reports for gene-usage and
#' marker-expression tables. A category with no corresponding long-format
#' row for a given `id_cols` combination (e.g. a gene never observed in a
#' group) becomes `NA` after pivoting; this is replaced with an explicit
#' `fill_value` (default `"0"`) so "not observed" reads as zero rather than
#' missing.
#'
#' @param df Long-format data frame.
#' @param id_cols Character vector of columns identifying each output row.
#' @param names_from Column whose distinct values become new columns.
#' @param value_col Column with the primary value to display.
#' @param pct_col Optional column with a percentage to append as
#'   `"value (pct%)"`; if `NULL`, `value_col` is used verbatim.
#' @param fill_value String used in place of `NA` after pivoting.
#'
#' @return A data frame: one row per `id_cols` combination, one column per
#'   `names_from` category, plus the `id_cols` columns.
#' @export
long_to_wide_display <- function(df, id_cols, names_from, value_col, pct_col = NULL,
                                 fill_value = "0") {
  df$.cell_value <- if (is.null(pct_col)) as.character(df[[value_col]]) else
    sprintf("%s (%s%%)", df[[value_col]], df[[pct_col]])
  wide <- tidyr::pivot_wider(
    df[, c(id_cols, names_from, ".cell_value")],
    id_cols = id_cols, names_from = names_from, values_from = ".cell_value"
  )
  wide <- as.data.frame(wide)
  wide[is.na(wide)] <- fill_value
  wide
}
