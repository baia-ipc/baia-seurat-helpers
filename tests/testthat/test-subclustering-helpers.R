testthat::test_that('feature filtering and grep helpers behave predictably', {
  vf <- c('TRAV1', 'IGHM', 'MT-CO1', 'RPL3', 'MALAT1', 'CXCL8')
  filtered <- filter_variable_features_scimmune(vf)
  testthat::expect_equal(filtered, 'CXCL8')
  markers <- data.frame(pct.1 = 0.8, pct.2 = 0.1, row.names = 'CXCL8')
  testthat::expect_equal(rownames(grep_markers(markers, '^CX')), 'CXCL8')
})

testthat::test_that('plot-return helpers provide structured bundles', {
  methods::setClass('MockSOAxes', slots = c(meta.data = 'data.frame'))
  so <- methods::new(
    'MockSOAxes',
    meta.data = data.frame(
      cluster = factor(c('0', '1')),
      nCount_RNA = c(100, 200),
      nFeature_RNA = c(50, 80),
      percent.mito = c(2, 3),
      row.names = c('c1', 'c2')
    )
  )
  bundle <- build_cluster_metric_violin_plot(
    so = so,
    group_by = 'cluster',
    cluster_colors = c('0' = '#111111', '1' = '#222222'),
    resolution_label = '1.2'
  )
  testthat::expect_type(bundle, 'list')
  testthat::expect_s3_class(bundle$plot, 'ggplot')
  testthat::expect_true(all(c('plot', 'data', 'filename_stub', 'default_width', 'default_height', 'kind') %in% names(bundle)))
  relabeled <- with_reduction_axes(bundle$plot, reduction_name = 'UMAP Harmony')
  testthat::expect_equal(relabeled$labels$x, 'UMAP Harmony 1')
})
