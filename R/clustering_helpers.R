#
# Note: the code of these function was originally written by S.Mella
#

#' Per-cluster purity against a reference label
#'
#' For each cluster, finds the majority reference label among its cells and
#' reports how many cells carry it, out of the cluster's total - a simple
#' concordance metric between an unsupervised clustering and an independent
#' cell-type/reference classifier.
#'
#' @param cluster_vec Vector of cluster assignments, one per cell.
#' @param label_vec Vector of reference labels (e.g. a cell-type classifier
#'   call), one per cell, same length/order as `cluster_vec`. `NA` entries in
#'   either vector are dropped before computing purity.
#'
#' @return A data frame with one row per cluster: `cluster`, `n_cells`,
#'   `majority_label`, `n_majority`, and `purity` (`n_majority / n_cells`).
#'   Summing `n_majority`/`n_cells` across rows gives a dataset-wide
#'   weighted-average purity.
#' @export
cluster_purity <- function(cluster_vec, label_vec) {
  keep <- !is.na(cluster_vec) & !is.na(label_vec)
  df <- data.frame(cluster = cluster_vec[keep], label = label_vec[keep])
  do.call(rbind, lapply(split(df, df$cluster), function(sub) {
    tab <- sort(table(sub$label), decreasing = TRUE)
    data.frame(
      cluster        = sub$cluster[1],
      n_cells        = nrow(sub),
      majority_label = names(tab)[1],
      n_majority     = as.integer(tab[1]),
      purity         = round(as.integer(tab[1]) / nrow(sub), 3),
      stringsAsFactors = FALSE
    )
  }))
}

#' Batch-mixing R² of a 2D embedding against a grouping variable
#'
#' Fits `embedding[, 1] ~ group` and `embedding[, 2] ~ group` as simple
#' linear models and averages their R². A well-mixed embedding (e.g. after
#' successful batch integration) should show close to zero R² - the
#' embedding coordinates should not be predictable from batch/sample
#' identity; a high R² indicates residual batch structure.
#'
#' @param embedding A numeric matrix or data frame with at least 2 columns
#'   (e.g. `Embeddings(so, "umap")`), one row per cell.
#' @param group Grouping vector (e.g. sample or batch id), same length/order
#'   as `nrow(embedding)`.
#'
#' @return A single numeric value: the mean R² across the two embedding
#'   dimensions, or `NA` if `group` has fewer than 2 distinct levels.
#' @export
mixing_r2 <- function(embedding, group) {
  group <- factor(group)
  if (nlevels(group) < 2) return(NA_real_)
  mean(c(summary(lm(embedding[, 1] ~ group))$r.squared,
        summary(lm(embedding[, 2] ~ group))$r.squared))
}

#' Keep only cell-type labels belonging to a lineage of interest
#'
#' Generalizes the common "drop off-target lineages from a per-celltype
#' experiment/result table" pattern (e.g. a T-cell-sorted dataset dropping
#' incidental B cell/NK/Monocyte/Platelet labels) to an arbitrary exclusion
#' regex, so it isn't hardcoded per project.
#'
#' @param x Character vector of cell-type labels.
#' @param exclude_pattern Regex (passed to `grepl()`) matching labels to
#'   exclude; default excludes common non-T lineages (B cells, NK cells,
#'   monocytes, platelets).
#'
#' @return Logical vector, `TRUE` for labels NOT matching `exclude_pattern`.
#' @export
is_lineage_label <- function(x, exclude_pattern = "B cell|\\bNK\\b|Natural killer|Monocyte|Platelet") {
  !grepl(exclude_pattern, x, ignore.case = TRUE)
}

factor_resolution <- function(so){
  tmp_df <- so@meta.data
  ind <- grep("res.", colnames(tmp_df))
  for(i in ind){
    tmp_df[,i] <- factor(tmp_df[,i])
    tmp_df[,i] <- factor(tmp_df[,i],
                         levels = 0 : (length(levels(tmp_df[,i])) - 1) )
  }
  so@meta.data <- tmp_df
  return(so)
}
