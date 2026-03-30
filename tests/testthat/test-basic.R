testthat::test_that('sample sheet helpers read and return IDs', {
  path <- tempfile(fileext = '.tsv')
  writeLines(c('#SampleID\tGroup', 'S1\tA', 'S2\tB'), path)
  tbl <- read_samples_sheet(path, verbose = FALSE)
  testthat::expect_equal(tbl$SampleID, c('S1', 'S2'))
  testthat::expect_equal(get_sample_IDs(tbl, verbose = FALSE), c('S1', 'S2'))
})

testthat::test_that('factor_resolution factors matching resolution columns', {
  methods::setClass('MockSO', slots = c(meta.data = 'data.frame'))
  so <- methods::new('MockSO', meta.data = data.frame(RNA_snn_res.0.4 = c('0', '1'), wsnn_res.0.8 = c('1', '2'), check.names = FALSE))
  out <- factor_resolution(so)
  testthat::expect_true(is.factor(out@meta.data[['RNA_snn_res.0.4']]))
  testthat::expect_true(is.factor(out@meta.data[['wsnn_res.0.8']]))
})
