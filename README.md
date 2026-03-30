# baia.seurat.helpers

Provides reusable Seurat-centric quality-control, clustering, merging, sample-sheet, and plotting helpers used across BAIA scRNA-seq projects.

## Installation

```r
remotes::install_github("baia-ipc/baia-seurat-helpers")
```

## Exported Helpers

- `boxplot_n_genes`
- `boxplot_n_umis`
- `compute_percent_mito`
- `density_plot_complexity`
- `density_plot_mito_ratio`
- `density_plot_n_genes`
- `density_plot_n_umis`
- `dotplot_n_umis_genes_mito`
- `factor_resolution`
- `get_sample_IDs`
- `histogram_n_cells`
- `plot_basic_qc`
- `plot_highest_expressed`
- `prepare_so_merging`
- `prepare_so_merging_Seurat4`
- `qc_distri_plot`
- `read_samples_sheet`
- `scater_qc`
- `show_qc_plots`
- `so_version`
- `split_print_legend`
- `test_cell_cycle_effect`
- `two_groups_dimplot`

## Example Calls

- `read_samples_sheet('samples.tsv')`
- `get_sample_IDs(data.frame(SampleID = c('S1', 'S2')), verbose = FALSE)`

## Development

The package source is intended to live under `/srv/baia/prj/scRNAseq-helpers` and be versioned in the `baia-ipc` GitHub organization.
