testthat::test_that('expected exported helpers are functions in the namespace', {
  ns <- asNamespace('baia.seurat.helpers')
  exports <- c('boxplot_n_genes', 'boxplot_n_umis', 'build_cluster_metric_violin_plot', 'cell_cycle_phase_stats', 'celltype_expression_stats', 'celltype_feature_dimplot', 'celltype_highlight_info', 'celltype_highlight_info_meta', 'compare_celltype_markers', 'compute_percent_mito', 'density_plot_complexity', 'density_plot_mito_ratio', 'density_plot_n_genes', 'density_plot_n_umis', 'dotplot_n_umis_genes_mito', 'factor_resolution', 'feature_dimplot', 'filter_variable_features_scimmune', 'get_sample_IDs', 'grep_features', 'grep_markers', 'histogram_n_cells', 'multi_celltype_dimplot', 'plot_basic_qc', 'plot_highest_expressed', 'prepare_so_merging', 'prepare_so_merging_Seurat4', 'qc_distri_plot', 'read_samples_sheet', 'reorder_markers_by_pct_delta', 'scater_qc', 'show_qc_plots', 'so_version', 'split_print_legend', 'strsanitize', 'test_cell_cycle_effect', 'two_groups_dimplot', 'with_reduction_axes')
  for (nm in exports) {
    testthat::expect_true(exists(nm, envir = ns, mode = 'function'))
  }
})
