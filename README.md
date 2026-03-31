# baia.seurat.helpers

`baia.seurat.helpers` is the base BAIA package for reusable Seurat-oriented
single-cell infrastructure. Its role is intentionally broad but still focused:
it owns generic helper code that is useful across many scRNA-seq and
multi-omics projects before the analysis branches into domain-specific layers
such as CITE-seq, pseudobulk DE, pathway analysis, or CellChat.

In practice, the package provides four kinds of functionality:

- sample-sheet handling for project metadata tables
- Seurat object compatibility and merge preparation helpers
- reusable QC annotation and diagnostics
- small plotting utilities used repeatedly across BAIA analyses

It does not own CITE-seq-specific ingestion, demultiplexing, pathway analysis,
or cell-cell communication logic. Those belong in the other BAIA packages.

## Installation

Install from GitHub:

```r
remotes::install_github("baia-ipc/baia-seurat-helpers")
```

For active local BAIA development:

```r
remotes::install_local("/srv/baia/prj/scRNAseq-helpers/baia-seurat-helpers")
```

## Typical Workflow

```r
library(baia.seurat.helpers)

samples <- read_samples_sheet("metadata/samples.tsv")
sample_ids <- get_sample_IDs(samples, verbose = FALSE)

so <- compute_percent_mito(so, mitoGenes = grep("^MT-", rownames(so), value = TRUE))
so <- scater_qc(so)
so <- factor_resolution(so)

qc_plot <- qc_distri_plot(so, "nCount_RNA")
merge_ready <- prepare_so_merging(so)
```

## Package Semantics

Use this package when you need helpers that should remain valid across multiple
single-cell projects regardless of the final analysis endpoint. The package is
especially appropriate for:

- reading project sample sheets into a predictable shape
- adding generic QC metadata to Seurat objects
- generating common diagnostic plots during preprocessing
- stripping Seurat objects down to a merge-safe state
- drawing small utility plots that are not tied to a downstream biology module

Several QC plotting helpers are legacy BAIA utilities and assume the object
metadata already contains columns such as `sample`, `nCount_RNA`,
`nFeature_RNA`, `mitoRatio`, or `log10GenesPerUMI` as produced by the upstream
workflow.

## Function Reference

### New rmdreportdeck-compatible helpers

The package now also includes subclustering and integrated-visualization
helpers collected from older BAIA Rmds. These do not print report assets or
write files as their primary behavior. Plot-return helpers instead return
structured bundles with fields such as `plot`, `data`, `filename_stub`,
`default_width`, and `default_height`.

Representative examples:

| Function | Intended purpose | Minimal example |
| --- | --- | --- |
| `celltype_highlight_info()` | Return highlighted cells, cluster distribution, and a DimPlot bundle for one cell type. | `celltype_highlight_info(so, "B cells", celltype_col = "celltype")` |
| `multi_celltype_dimplot()` | Generalize the old two-, three-, four-, and five-cell-type highlight plots into one reusable helper. | `multi_celltype_dimplot(so, c("B cells", "T cells"))` |
| `feature_dimplot()` | Return a FeaturePlot bundle with a suggested filename stub. | `feature_dimplot(so, "MS4A1")` |
| `compare_celltype_markers()` | Compare markers between two metadata-defined cell-type groups. | `compare_celltype_markers(so, "B cells", "Plasmablasts")` |
| `filter_variable_features_scimmune()` | Remove TCR, Ig, mito, ribosomal, and configured unwanted genes from a variable-feature set. | `filter_variable_features_scimmune(VariableFeatures(so))` |
| `with_reduction_axes()` | Relabel a reduction plot with explicit axis labels. | `with_reduction_axes(plt, reduction_name = "UMAP Harmony")` |
| `build_cluster_metric_violin_plot()` | Return a report-ready cluster QC violin bundle with both plot and source data. | `build_cluster_metric_violin_plot(so, "harmsnn_res.1.2", cluster_colors)` |

### Sample-sheet helpers

| Function | Intended purpose | Minimal example |
| --- | --- | --- |
| `read_samples_sheet()` | Read a BAIA TSV sample sheet whose first header line may start with `#`, returning a plain data frame with character sample IDs preserved. | `read_samples_sheet("metadata/samples.tsv")` |
| `get_sample_IDs()` | Extract sample IDs from a sample sheet data frame or directly from the TSV path. | `get_sample_IDs("metadata/samples.tsv", verbose = FALSE)` |

### Seurat object compatibility and merge preparation

| Function | Intended purpose | Minimal example |
| --- | --- | --- |
| `so_version()` | Return the major Seurat object version as `"4"` or `"5"` and fail early on unsupported objects. | `so_version(so)` |
| `prepare_so_merging()` | Strip a Seurat object down to RNA counts and metadata needed for later merging, removing assays, embeddings, graphs, and SCT leftovers. | `prepare_so_merging(so)` |
| `prepare_so_merging_Seurat4()` | Legacy Seurat v4-specific merge preparation helper with optional verbose logging. | `prepare_so_merging_Seurat4(so, verbose = TRUE)` |
| `factor_resolution()` | Convert clustering resolution columns in `meta.data` into ordered factors for cleaner downstream plotting and table handling. | `factor_resolution(so)` |

### QC annotation and diagnostics

| Function | Intended purpose | Minimal example |
| --- | --- | --- |
| `compute_percent_mito()` | Add `percent.mito` and `percent.mito.cl` metadata based on a supplied vector of mitochondrial gene names. | `compute_percent_mito(so, mitoGenes = grep("^MT-", rownames(so), value = TRUE))` |
| `scater_qc()` | Compute `scater`-style per-cell QC metrics and outlier flags and append them to Seurat metadata. | `scater_qc(so)` |
| `test_cell_cycle_effect()` | Run BAIA's standard cell-cycle scoring and PCA diagnostic workflow to judge whether cell-cycle effects need explicit handling. | `test_cell_cycle_effect(so, "sampleA", s_genes, g2m_genes, showplots = TRUE)` |

### QC plot constructors

| Function | Intended purpose | Minimal example |
| --- | --- | --- |
| `histogram_n_cells()` | Plot the number of cells per sample. | `histogram_n_cells(so)` |
| `density_plot_n_umis()` | Plot the distribution of UMIs per cell, split by sample. | `density_plot_n_umis(so)` |
| `boxplot_n_umis()` | Plot sample-wise boxplots of log10 UMIs per cell. | `boxplot_n_umis(so)` |
| `density_plot_n_genes()` | Plot the distribution of detected genes per cell across samples. | `density_plot_n_genes(so)` |
| `boxplot_n_genes()` | Plot sample-wise boxplots of log10 detected genes per cell. | `boxplot_n_genes(so)` |
| `density_plot_mito_ratio()` | Plot the distribution of mitochondrial ratio across samples. | `density_plot_mito_ratio(so)` |
| `density_plot_complexity()` | Plot transcriptional-complexity distributions such as `log10GenesPerUMI`. | `density_plot_complexity(so)` |
| `dotplot_n_umis_genes_mito()` | Plot UMIs versus genes, colored by mitochondrial ratio, as a compact joint QC view. | `dotplot_n_umis_genes_mito(so)` |
| `qc_distri_plot()` | Build a generic histogram for one named QC metric present in `meta.data`. | `qc_distri_plot(so, "nFeature_RNA")` |
| `plot_basic_qc()` | Draw the BAIA basic QC three-panel violin and jitter view for mitochondrial percentage, genes, and UMIs. | `plot_basic_qc(so, title = "Raw QC")` |
| `plot_highest_expressed()` | Show the highest-expressed genes as horizontal boxplots to identify dominating features. | `plot_highest_expressed(so, nfeat2plot = 20)` |
| `show_qc_plots()` | Print the standard sequence of legacy BAIA QC plots in one call. | `show_qc_plots(so)` |

### Visualization utilities

| Function | Intended purpose | Minimal example |
| --- | --- | --- |
| `two_groups_dimplot()` | Highlight two metadata-defined groups on the same Seurat dimensionality reduction plot. | `two_groups_dimplot(so, grp1 = "DHF", grp2 = "DF", grpcol = "WHO_classification")` |
| `split_print_legend()` | Print a ggplot without its legend and then draw the legend separately, useful for manual report layout. | `split_print_legend(plt)` |

## Relationship To Other BAIA Packages

- `baia.citeseq` builds on this package for generic QC helpers such as
  `compute_percent_mito()`.
- `baia.pseudobulk.deseq` assumes the Seurat objects have already been prepared
  and QCed upstream.
- `baia.ext.cellprop.plots` and `baia.cellchat` consume objects that typically
  originate from this preprocessing layer.

## Development

The package source is intended to live under
`/srv/baia/prj/scRNAseq-helpers/baia-seurat-helpers` and be versioned in the
`baia-ipc` GitHub organization.
