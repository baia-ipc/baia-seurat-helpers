testthat::test_that('expected exported helpers are functions in the namespace', {
  ns <- asNamespace('baia.seurat.helpers')
  exports <- c('boxplot_n_genes', 'boxplot_n_umis', 'compute_percent_mito', 'density_plot_complexity', 'density_plot_mito_ratio', 'density_plot_n_genes', 'density_plot_n_umis', 'dotplot_n_umis_genes_mito', 'factor_resolution', 'get_sample_IDs', 'histogram_n_cells', 'plot_basic_qc', 'plot_highest_expressed', 'prepare_so_merging', 'prepare_so_merging_Seurat4', 'qc_distri_plot', 'read_samples_sheet', 'scater_qc', 'show_qc_plots', 'so_version', 'split_print_legend', 'test_cell_cycle_effect', 'two_groups_dimplot')
  for (nm in exports) {
    testthat::expect_true(exists(nm, envir = ns, mode = 'function'))
  }
})
