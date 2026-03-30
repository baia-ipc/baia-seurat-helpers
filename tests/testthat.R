if (!requireNamespace('testthat', quietly = TRUE)) {
  message('testthat not installed; skipping package tests')
  quit(save = 'no', status = 0)
}
library(testthat)
library(baia.seurat.helpers)
test_check('baia.seurat.helpers')
