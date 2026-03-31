.validate_metadata_column <- function(so, column) {
  if (!column %in% colnames(so@meta.data)) {
    stop("Metadata column not found: ", column, call. = FALSE)
  }
}

.validate_feature_name <- function(so, feature) {
  if (!feature %in% rownames(so)) {
    stop("Feature not found in Seurat object: ", feature, call. = FALSE)
  }
}

.matching_cells <- function(so, column, value) {
  .validate_metadata_column(so, column)
  rownames(so@meta.data)[so@meta.data[[column]] == value]
}

.build_filename_stub <- function(prefix, values) {
  values <- gsub("[^A-Za-z0-9]+", "_", values)
  values <- gsub("_+", "_", values)
  values <- gsub("^_|_$", "", values)
  paste(c(prefix, values), collapse = ".")
}

celltype_highlight_info <- function(
    so,
    celltype,
    celltype_col = "celltype",
    cluster_col = "harmsnn_res.1.2",
    reduction = "umapharm",
    highlight_color = "darkblue",
    other_color = "grey"
) {
  .validate_metadata_column(so, celltype_col)
  .validate_metadata_column(so, cluster_col)
  cells <- .matching_cells(so, celltype_col, celltype)
  if (!length(cells)) {
    stop("No cells found for cell type: ", celltype, call. = FALSE)
  }
  plot_obj <- Seurat::DimPlot(
    so,
    reduction = reduction,
    cells.highlight = setNames(list(cells), celltype),
    cols.highlight = highlight_color,
    cols = other_color
  )
  list(
    celltype = celltype,
    celltype_col = celltype_col,
    cluster_col = cluster_col,
    cells = cells,
    cluster_table = as.data.frame(table(so@meta.data[cells, cluster_col, drop = TRUE])),
    plot = plot_obj,
    filename_stub = .build_filename_stub("celltype_highlight", c(celltype_col, celltype)),
    default_width = 8,
    default_height = 6,
    kind = "dimplot"
  )
}

celltype_highlight_info_meta <- function(
    so,
    celltype,
    metadata_col,
    cluster_col = "harmsnn_res.1.2",
    reduction = "umapharm",
    highlight_color = "darkblue",
    other_color = "grey"
) {
  celltype_highlight_info(
    so = so,
    celltype = celltype,
    celltype_col = metadata_col,
    cluster_col = cluster_col,
    reduction = reduction,
    highlight_color = highlight_color,
    other_color = other_color
  )
}

multi_celltype_dimplot <- function(
    so,
    celltypes,
    celltype_col = "celltype_m",
    reduction = "umapharm",
    colors_highlight = NULL,
    other_color = "lightgrey"
) {
  .validate_metadata_column(so, celltype_col)
  if (is.null(colors_highlight)) {
    palette_size <- max(length(celltypes), 3)
    colors_highlight <- grDevices::colorRampPalette(
      c("darkred", "darkblue", "darkgreen", "darkorange", "darkcyan")
    )(palette_size)[seq_along(celltypes)]
  }
  highlight_cells <- lapply(celltypes, function(ct) .matching_cells(so, celltype_col, ct))
  if (any(!vapply(highlight_cells, length, integer(1)))) {
    missing <- celltypes[!vapply(highlight_cells, length, integer(1))]
    stop("No cells found for: ", paste(missing, collapse = ", "), call. = FALSE)
  }
  names(highlight_cells) <- celltypes
  plot_obj <- Seurat::DimPlot(
    so,
    reduction = reduction,
    cells.highlight = highlight_cells,
    cols.highlight = colors_highlight,
    cols = other_color
  )
  list(
    plot = plot_obj,
    highlight_cells = highlight_cells,
    celltype_col = celltype_col,
    celltypes = celltypes,
    colors_highlight = stats::setNames(colors_highlight, celltypes),
    filename_stub = .build_filename_stub("multi_celltype_dimplot", celltypes),
    default_width = 9,
    default_height = 6,
    kind = "dimplot"
  )
}

feature_dimplot <- function(
    so,
    feature,
    reduction = "umapharm",
    order = TRUE
) {
  .validate_feature_name(so, feature)
  plot_obj <- Seurat::FeaturePlot(so, feature, reduction = reduction, order = order)
  list(
    plot = plot_obj,
    feature = feature,
    reduction = reduction,
    filename_stub = .build_filename_stub("feature_dimplot", feature),
    default_width = 8,
    default_height = 6,
    kind = "featureplot"
  )
}

celltype_feature_dimplot <- function(
    so,
    celltype,
    feature,
    celltype_col = "celltype_m",
    reduction = "umapharm",
    order = TRUE
) {
  .validate_metadata_column(so, celltype_col)
  .validate_feature_name(so, feature)
  subset_obj <- Seurat::subset(so, cells = .matching_cells(so, celltype_col, celltype))
  plot_obj <- Seurat::FeaturePlot(subset_obj, feature, reduction = reduction, order = order)
  list(
    plot = plot_obj,
    subset = subset_obj,
    feature = feature,
    celltype = celltype,
    celltype_col = celltype_col,
    filename_stub = .build_filename_stub("celltype_feature_dimplot", c(celltype, feature)),
    default_width = 8,
    default_height = 6,
    kind = "featureplot"
  )
}

grep_features <- function(so, pattern, ignore.case = FALSE, fixed = FALSE) {
  grep(pattern = pattern, rownames(so), value = TRUE, ignore.case = ignore.case, fixed = fixed)
}

compare_celltype_markers <- function(
    so,
    celltype_a,
    celltype_b,
    celltype_col = "celltype_m",
    min.pct = 0.25,
    logfc.threshold = 1,
    p_adj_cutoff = 0.05
) {
  .validate_metadata_column(so, celltype_col)
  idents_original <- Seurat::Idents(so)
  on.exit(Seurat::Idents(so) <- idents_original, add = TRUE)
  Seurat::Idents(so) <- so@meta.data[[celltype_col]]
  markers <- Seurat::FindMarkers(
    so,
    ident.1 = celltype_a,
    ident.2 = celltype_b,
    min.pct = min.pct,
    logfc.threshold = logfc.threshold
  )
  markers <- markers[markers$p_val_adj < p_adj_cutoff, , drop = FALSE]
  markers[order(abs(markers$avg_log2FC), decreasing = TRUE), , drop = FALSE]
}

reorder_markers_by_pct_delta <- function(markers, pct_cols = c("pct.1", "pct.2")) {
  if (!all(pct_cols %in% colnames(markers))) {
    stop("Missing percentage columns in markers table.", call. = FALSE)
  }
  markers[order(abs(markers[[pct_cols[[1]]]] - markers[[pct_cols[[2]]]]), decreasing = TRUE), , drop = FALSE]
}

grep_markers <- function(markers, pattern, rowname_col = NULL, ignore.case = FALSE, fixed = FALSE) {
  if (!is.null(rowname_col)) {
    if (!rowname_col %in% colnames(markers)) {
      stop("Marker column not found: ", rowname_col, call. = FALSE)
    }
    values <- markers[[rowname_col]]
    return(markers[grep(pattern = pattern, values, ignore.case = ignore.case, fixed = fixed), , drop = FALSE])
  }
  markers[grep(pattern = pattern, rownames(markers), ignore.case = ignore.case, fixed = fixed), , drop = FALSE]
}

celltype_expression_stats <- function(
    so,
    celltype,
    feature,
    celltype_col = "celltype_m"
) {
  .validate_metadata_column(so, celltype_col)
  .validate_feature_name(so, feature)
  cells <- .matching_cells(so, celltype_col, celltype)
  counts <- Seurat::GetAssayData(so, assay = "RNA", slot = "counts")[feature, cells, drop = TRUE]
  avg_data <- Seurat::AverageExpression(
    Seurat::subset(so, cells = cells),
    features = feature
  )
  c(
    pct = mean(counts > 0) * 100,
    avg = as.numeric(avg_data$RNA[feature, 1])
  )
}

cell_cycle_phase_stats <- function(
    so,
    celltype,
    celltype_col = "celltype_m",
    phase_col = "Phase"
) {
  .validate_metadata_column(so, celltype_col)
  .validate_metadata_column(so, phase_col)
  cells <- .matching_cells(so, celltype_col, celltype)
  phase_table <- table(so@meta.data[cells, phase_col, drop = TRUE])
  phase_table / sum(phase_table)
}

filter_variable_features_scimmune <- function(
    variable_features,
    tcr_pattern = "^TR[AB][VC]",
    ig_pattern = "^IG[HLK][VDJ]",
    mito_pattern = "^MT",
    ribo_pattern = "^RP[LS]",
    immunoglobulin_extra = c(
      "IGHM", "IGHD", "IGHE", "IGHA[12]", "IGHG[1234]",
      "IGKC", "IGLC[1234567]", "AC233755.1"
    ),
    additional_exclude = "MALAT1"
) {
  unwanted_tcr <- grep(pattern = tcr_pattern, variable_features, value = TRUE)
  unwanted_ig <- c(
    grep(pattern = ig_pattern, variable_features, value = TRUE),
    immunoglobulin_extra
  )
  unwanted_mt <- grep(pattern = mito_pattern, variable_features, value = TRUE)
  unwanted_ribo <- grep(pattern = ribo_pattern, variable_features, value = TRUE)
  unwanted <- unique(c(unwanted_tcr, unwanted_ig, unwanted_mt, unwanted_ribo, additional_exclude))
  variable_features[!variable_features %in% unwanted]
}

with_reduction_axes <- function(plot_obj, reduction_name = "UMAP", dims = c(1, 2)) {
  plot_obj + ggplot2::labs(
    x = paste(reduction_name, dims[[1]]),
    y = paste(reduction_name, dims[[2]])
  )
}

build_cluster_metric_violin_plot <- function(
    so,
    group_by,
    cluster_colors,
    resolution_label = NULL,
    metrics = c("nCount_RNA", "nFeature_RNA", "percent.mito"),
    metric_labels = c(
      nCount_RNA = "RNA counts per cell",
      nFeature_RNA = "Genes per cell",
      "percent.mito" = "Mitochondrial fraction"
    )
) {
  .validate_metadata_column(so, group_by)
  missing_metrics <- setdiff(metrics, colnames(so@meta.data))
  if (length(missing_metrics)) {
    stop("Metrics not found in metadata: ", paste(missing_metrics, collapse = ", "), call. = FALSE)
  }
  cluster_values <- as.factor(so@meta.data[[group_by]])
  cluster_levels <- levels(cluster_values)
  if (is.null(cluster_colors)) {
    cluster_colors <- grDevices::colorRampPalette(RColorBrewer::brewer.pal(8, "Set3"))(length(cluster_levels))
    names(cluster_colors) <- cluster_levels
  }
  violin_df <- do.call(
    rbind,
    lapply(metrics, function(metric) {
      data.frame(
        cluster = factor(cluster_values, levels = cluster_levels),
        cluster_label = factor(
          paste0("Cl_", as.character(cluster_values)),
          levels = paste0("Cl_", cluster_levels)
        ),
        metric = metric,
        value = so@meta.data[[metric]],
        stringsAsFactors = FALSE
      )
    })
  )
  violin_df$metric <- factor(
    violin_df$metric,
    levels = metrics,
    labels = unname(metric_labels[metrics])
  )
  plot_title <- if (is.null(resolution_label)) {
    group_by
  } else {
    paste0("Clustering at resolution ", resolution_label)
  }
  plot_obj <- ggplot2::ggplot(violin_df, ggplot2::aes(x = cluster_label, y = value, fill = cluster)) +
    ggplot2::geom_violin(scale = "width", trim = TRUE, color = NA, alpha = 0.85) +
    ggplot2::geom_boxplot(
      width = 0.16,
      outlier.shape = NA,
      fill = "white",
      color = "grey25",
      alpha = 0.75
    ) +
    ggplot2::facet_wrap(~metric, scales = "free_y", ncol = 1) +
    ggplot2::scale_fill_manual(values = cluster_colors, guide = "none") +
    ggplot2::labs(
      x = "Cluster",
      y = "Value",
      title = plot_title
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, vjust = 1),
      panel.grid.major.x = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "bold"),
      plot.title = ggplot2::element_text(face = "bold")
    )
  list(
    plot = plot_obj,
    data = violin_df,
    filename_stub = .build_filename_stub("cluster_metric_violin", group_by),
    default_width = 12,
    default_height = 10,
    kind = "violin_plot"
  )
}
