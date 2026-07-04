
#' FeaturePlot that renders zero-variance features as uniform gray
#'
#' `Seurat::FeaturePlot()` degenerates when a feature has zero variance
#' (every displayed cell has value 0, e.g. a marker gene that is genuinely
#' absent from the shown subset): the low-to-high color scale has no range
#' to map, and Seurat colors every cell with the HIGH end of the gradient
#' instead of the low/gray end - a true "gene not detected anywhere" panel
#' would misleadingly look like "gene detected everywhere at max level".
#' This wrapper checks each feature's value range first and forces an
#' all-gray panel (both ends of the gradient set to the same neutral color)
#' whenever max <= 0, instead of letting `FeaturePlot()`'s own
#' degenerate-scale behavior render it.
#'
#' @param object Seurat object.
#' @param features Character vector of feature names to plot, one panel each.
#' @param ncol Number of columns in the combined panel grid; defaults to
#'   `length(features)` (one row).
#' @param cols Two-color low/high gradient used for features with real
#'   variance, passed through to `FeaturePlot()`.
#' @param zero_color Color used for both ends of the gradient (i.e. solid
#'   fill) when a feature's maximum value is <= 0.
#' @param layer Assay layer/slot to fetch values from for the zero-variance
#'   check (`Seurat::FetchData()` `layer`/`slot` argument, depending on
#'   Seurat version).
#' @param ... Additional arguments passed through to `FeaturePlot()` for
#'   every feature (e.g. `reduction`, `order`, `min.cutoff`).
#'
#' @return A `patchwork` object combining one `FeaturePlot()` panel per
#'   feature.
#' @export
safe_feature_plot <- function(object, features, ncol = NULL,
                              cols = c("grey85", "#8c2d04"),
                              zero_color = "grey85", layer = "data", ...) {
  vals_by_feature <- tryCatch(
    Seurat::FetchData(object, vars = features, layer = layer),
    error = function(e) Seurat::FetchData(object, vars = features, slot = layer)
  )
  panels <- lapply(features, function(feat) {
    vals <- vals_by_feature[[feat]]
    feat_cols <- if (length(vals) == 0 || all(is.na(vals)) || max(vals, na.rm = TRUE) <= 0) {
      c(zero_color, zero_color)
    } else {
      cols
    }
    FeaturePlot(object, features = feat, cols = feat_cols, ...)
  })
  if (is.null(ncol)) ncol <- length(features)
  patchwork::wrap_plots(panels, ncol = ncol)
}

#' Main UMAP plus one per-label highlight panel
#'
#' Draws a single unlabeled UMAP colored by `group_col` (legend omitted -
#' the small per-label panels on the right serve as the legend), followed by
#' one small highlight panel per distinct label showing just that label's
#' cells against all others in gray. This is the "big UMAP + label-strip"
#' layout used for cell-type annotation review.
#'
#' @param so Seurat object.
#' @param group_col Metadata column with the discrete labels to plot.
#' @param title Title for the main (left) UMAP panel.
#' @param reduction Dimensionality-reduction name passed to `DimPlot()`.
#' @param ncol_small Number of columns in the small-panel grid.
#' @param main_pt_size,small_pt_size Point sizes for the main panel and each
#'   small highlight panel, respectively.
#' @param small_title_size Font size for each small panel's title (the
#'   primary place labels are readable, since the main panel has no legend).
#' @param main_width_ratio,small_width_ratio Relative widths passed to
#'   `patchwork::plot_layout(widths = c(main_width_ratio, small_width_ratio))`.
#'
#' @return A `patchwork` object: the main UMAP beside the grid of small
#'   per-label highlight panels.
#' @export
labeled_umap_panel <- function(so, group_col, title, reduction = "umapharm",
                               ncol_small = 4, main_pt_size = 0.8,
                               small_pt_size = 0.2, small_title_size = 10,
                               main_width_ratio = 1, small_width_ratio = 1.8) {
  labels <- sort(unique(as.character(so@meta.data[[group_col]])))
  label_cols <- setNames(scales::hue_pal()(length(labels)), labels)
  p_main <- DimPlot(so, reduction = reduction, group.by = group_col,
                     cols = label_cols, label = FALSE, pt.size = main_pt_size) +
    ggtitle(title) + theme(legend.position = "none")
  small_plots <- lapply(labels, function(lbl) {
    hi_cells <- colnames(so)[so@meta.data[[group_col]] == lbl]
    DimPlot(so, reduction = reduction,
            cells.highlight = list(hi_cells),
            cols.highlight  = label_cols[lbl],
            sizes.highlight = 1,
            pt.size = small_pt_size) +
      ggtitle(lbl) + NoAxes() + NoLegend() +
      theme(plot.title  = element_text(size = small_title_size, hjust = 0.5, face = "plain",
                                        margin = margin(b = 1)),
            plot.margin = margin(2, 2, 2, 2))
  })
  p_panels <- patchwork::wrap_plots(small_plots, ncol = ncol_small)
  p_main + p_panels + patchwork::plot_layout(widths = c(main_width_ratio, small_width_ratio))
}

#' Invisible-legend trick to add a discrete color legend to any ggplot
#'
#' Adds a fully transparent `geom_point()` layer mapped to `color_col` plus
#' a matching `scale_color_manual()`, so a legend for `color_values` appears
#' without drawing any visible extra points. Useful for adding a legend for
#' an aesthetic that's only encoded via `element_text(color = ...)`
#' elsewhere in the plot (e.g. condition-colored axis tick labels), which
#' ggplot has no native legend for.
#'
#' @param p A ggplot object to add the legend to.
#' @param x_col Name of the (typically discrete x-axis) column already used
#'   as the plot's `x` aesthetic.
#' @param x_levels Character vector of the factor levels/order used for the
#'   plot's x-axis (the dummy legend layer needs one valid x value to attach
#'   to; any value in `x_levels` works since the layer is invisible).
#' @param color_col Name to give the new legend's mapped variable and title.
#' @param color_values Named vector of colors, names matching the categories
#'   the legend should show (also used as `breaks`, in that order).
#'
#' @return `p` with the extra invisible legend layer and color scale added.
#' @export
add_invisible_legend <- function(p, x_col, x_levels, color_col, color_values) {
  legend_df <- setNames(
    data.frame(
      factor(rep(x_levels[1], length(color_values)), levels = x_levels),
      0,
      names(color_values),
      stringsAsFactors = FALSE
    ),
    c(x_col, ".y_dummy", color_col)
  )
  p +
    geom_point(
      data = legend_df,
      mapping = aes(x = .data[[x_col]], y = .data[[".y_dummy"]], color = .data[[color_col]]),
      inherit.aes = FALSE, alpha = 0
    ) +
    scale_color_manual(
      name = color_col, values = color_values, breaks = names(color_values),
      guide = guide_legend(override.aes = list(alpha = 1, size = 4))
    )
}

#' Stack an absolute-count barplot above its matching relative (%) version
#'
#' Builds two `geom_col()` bar charts from the same long-format data frame -
#' one absolute-count, one `position = "fill"` relative - and stacks them
#' with a single collected legend. This is the "absolute on top, relative
#' below, shared legend" composition used throughout BAIA summary reports
#' for cell-type/cluster composition barplots.
#'
#' @param df Long-format data frame with one row per (x, fill) combination.
#' @param x_col,y_col,fill_col Column names (strings) for the x, count/`y`,
#'   and fill aesthetics.
#' @param fill_values Named vector of fill colors, names matching `fill_col`
#'   categories.
#' @param fill_breaks Optional ordering for the fill legend/stack (passed to
#'   `scale_fill_manual(breaks = ...)`); defaults to `names(fill_values)`.
#' @param title_abs,title_rel Titles for the absolute and relative panels.
#' @param x_lab,fill_lab Axis/legend labels shared by both panels.
#' @param x_text_colors Optional vector (same length/order as the x-axis
#'   categories) of colors for `axis.text.x`, e.g. to color sample labels by
#'   condition.
#' @param x_text_angle Rotation angle for x-axis tick labels.
#'
#' @return A `patchwork` object: the absolute panel stacked above the
#'   relative panel, with `plot_layout(guides = "collect")`.
#' @export
abs_over_relative_barplot <- function(df, x_col, y_col, fill_col, fill_values,
                                      fill_breaks = names(fill_values),
                                      title_abs = NULL, title_rel = NULL,
                                      x_lab = NULL, fill_lab = fill_col,
                                      x_text_colors = NULL, x_text_angle = 45) {
  base_theme <- theme_bw()
  if (!is.null(x_text_colors)) {
    base_theme <- base_theme + theme(
      axis.text.x = element_text(angle = x_text_angle, hjust = 1, color = x_text_colors)
    )
  } else if (!is.null(x_text_angle)) {
    base_theme <- base_theme + theme(
      axis.text.x = element_text(angle = x_text_angle, hjust = 1)
    )
  }

  p_abs <- ggplot(df, aes(x = .data[[x_col]], y = .data[[y_col]], fill = .data[[fill_col]])) +
    geom_col() +
    scale_fill_manual(values = fill_values, breaks = fill_breaks) +
    labs(x = x_lab, y = "N cells", fill = fill_lab, title = title_abs) +
    base_theme
  p_rel <- ggplot(df, aes(x = .data[[x_col]], y = .data[[y_col]], fill = .data[[fill_col]])) +
    geom_col(position = "fill") +
    scale_fill_manual(values = fill_values, breaks = fill_breaks) +
    labs(x = x_lab, y = "Proportion of cells", fill = fill_lab, title = title_rel) +
    base_theme

  p_abs / p_rel + patchwork::plot_layout(guides = "collect")
}

split_print_legend <- function(plt) {
  print(plt + theme(legend.position = "none"))
  tmp <- ggplot_gtable(ggplot_build(plt)) 
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
  legend <- tmp$grobs[[leg]] 
  grid.newpage()
  grid.draw(legend) 
}

no_grays_palette <- c(
  brewer.pal(9, "Set1")[c(1:8)],
  brewer.pal(8, "Set2")[c(1:7)],
  brewer.pal(12, "Set3")[c(1:8)],
  brewer.pal(12, "Set3")[c(10:12)],
  brewer.pal(8, "Dark2")[1:7]
)
