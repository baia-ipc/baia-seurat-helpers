#
# CellTypist annotation against the Allen Institute AIFI Immune Health Atlas
# models (L1/L2/L3). General-purpose Seurat annotation helpers - not
# specific to TCR/VDJ projects.
#

#' AIFI Immune Health Atlas CellTypist model assets (L1/L2/L3)
#'
#' Filenames and download URLs for the Allen Institute AIFI Immune Health
#' Atlas CellTypist models (10x 3' versions), shared across BAIA projects
#' that annotate PBMC scRNA-seq against this reference.
#'
#' @return A named list (`L1`/`L2`/`L3`), each `list(filename = , url = )`.
#' @export
aifi_celltypist_models <- function() list(
  L1 = list(
    filename = "ref_pbmc_clean_celltypist_model_AIFI_L1_2024-04-18.pkl",
    url = paste0(
      "https://allenimmunology.org/public/publication/download/",
      "84792154-cdfb-42d0-8e42-39e210e980b4/filesets/",
      "c5300f8b-f5ff-4010-9371-edc33d489143/",
      "ref_pbmc_clean_celltypist_model_AIFI_L1_2024-04-18.pkl")
  ),
  L2 = list(
    filename = "ref_pbmc_clean_celltypist_model_AIFI_L2_2024-04-19.pkl",
    url = paste0(
      "https://allenimmunology.org/public/publication/download/",
      "84792154-cdfb-42d0-8e42-39e210e980b4/filesets/",
      "c5300f8b-f5ff-4010-9371-edc33d489143/",
      "ref_pbmc_clean_celltypist_model_AIFI_L2_2024-04-19.pkl")
  ),
  L3 = list(
    filename = "ref_pbmc_clean_celltypist_model_AIFI_L3_2024-04-19.pkl",
    url = paste0(
      "https://allenimmunology.org/public/publication/download/",
      "84792154-cdfb-42d0-8e42-39e210e980b4/filesets/",
      "c5300f8b-f5ff-4010-9371-edc33d489143/",
      "ref_pbmc_clean_celltypist_model_AIFI_L3_2024-04-19.pkl")
  )
)

#' AIFI Immune Health Atlas color/order palette assets (combined + L1/L2/L3)
#'
#' @return A named list (`combined`/`L1`/`L2`/`L3`), each
#'   `list(filename = , url = )`.
#' @export
aifi_celltypist_palettes <- function() list(
  combined = list(
    filename = "AIFI_imm_health_atlas_type_order_colors.csv",
    url = paste0(
      "https://allenimmunology.org/public/publication/download/",
      "84792154-cdfb-42d0-8e42-39e210e980b4/filesets/",
      "1299bf6a-220d-4289-b23f-6ab0c17f669f/",
      "AIFI_imm_health_atlas_type_order_colors.csv")
  ),
  L1 = list(
    filename = "AIFI_L1_imm_health_atlas_type_order_colors.csv",
    url = paste0(
      "https://allenimmunology.org/public/publication/download/",
      "84792154-cdfb-42d0-8e42-39e210e980b4/filesets/",
      "1299bf6a-220d-4289-b23f-6ab0c17f669f/",
      "AIFI_L1_imm_health_atlas_type_order_colors.csv")
  ),
  L2 = list(
    filename = "AIFI_L2_imm_health_atlas_type_order_colors.csv",
    url = paste0(
      "https://allenimmunology.org/public/publication/download/",
      "84792154-cdfb-42d0-8e42-39e210e980b4/filesets/",
      "1299bf6a-220d-4289-b23f-6ab0c17f669f/",
      "AIFI_L2_imm_health_atlas_type_order_colors.csv")
  ),
  L3 = list(
    filename = "AIFI_L3_imm_health_atlas_type_order_colors.csv",
    url = paste0(
      "https://allenimmunology.org/public/publication/download/",
      "84792154-cdfb-42d0-8e42-39e210e980b4/filesets/",
      "1299bf6a-220d-4289-b23f-6ab0c17f669f/",
      "AIFI_L3_imm_health_atlas_type_order_colors.csv")
  )
)

#' Download a set of named remote assets if not already present locally
#'
#' @param assets A named list of `list(filename = , url = )` entries, e.g.
#'   `AIFI_CELLTYPIST_MODELS` or `AIFI_CELLTYPIST_PALETTES`.
#' @param dest_dir Directory the assets should live in; created if missing.
#'
#' @return Invisibly, a named character vector of the local file paths (same
#'   names as `assets`).
#' @export
ensure_downloaded <- function(assets, dest_dir) {
  dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)
  paths <- setNames(character(length(assets)), names(assets))
  for (nm in names(assets)) {
    a <- assets[[nm]]
    path <- file.path(dest_dir, a$filename)
    if (!file.exists(path)) {
      message("Downloading ", a$filename, " ...")
      utils::download.file(a$url, path, quiet = TRUE, mode = "wb")
    } else {
      message("Found: ", a$filename)
    }
    paths[nm] <- path
  }
  invisible(paths)
}

#' Run CellTypist on an expression matrix at one or more label resolutions
#'
#' Writes `expr_mat` (genes x cells) to a temporary h5ad file and invokes
#' CellTypist once per model in `model_paths` via `python_bin`. This is the
#' matrix-in/predictions-out core shared by whole-object annotation
#' (`celltypist_aifi_annotate()`) and small standalone matrices (e.g. a
#' carrier/contaminant-cell QC check that isn't part of the main Seurat
#' object).
#'
#' @param expr_mat Genes x cells expression matrix (log1p-normalized, e.g.
#'   a Seurat `data` layer).
#' @param model_paths Named vector/list of CellTypist `.pkl` model file
#'   paths, one per resolution level (names become the level labels used in
#'   the returned list, e.g. `c(L1 = ..., L2 = ..., L3 = ...)`).
#' @param python_bin Path to a Python executable with `celltypist`,
#'   `anndata` and `scipy` installed.
#' @param majority_voting Passed to `celltypist.annotate()`.
#' @param include_scores If `TRUE`, also return the probability of each
#'   cell's assigned label.
#' @param persist_score_csv Optional named vector/list of destination file
#'   paths (same names as `model_paths`) to copy each level's full
#'   probability matrix CSV to, for callers that need per-label scores
#'   beyond the assigned-label `score` column (e.g. a later re-scoring step
#'   against a label subset). `NULL` (default) discards them.
#' @param tmp_dir Directory for intermediate matrix/h5ad files; cleaned up
#'   on exit.
#'
#' @return A named list (one entry per level in `model_paths`), each a data
#'   frame with columns `barcode`, `predicted_label`, and (if
#'   `include_scores`) `score`.
#' @export
celltypist_aifi_predict_matrix <- function(expr_mat, model_paths, python_bin,
                                           majority_voting = FALSE,
                                           include_scores = TRUE,
                                           persist_score_csv = NULL,
                                           tmp_dir = tempdir()) {
  mtx_dir <- file.path(tmp_dir, paste0("celltypist_mtx_", basename(tempfile())))
  dir.create(mtx_dir, showWarnings = FALSE, recursive = TRUE)
  on.exit(unlink(mtx_dir, recursive = TRUE), add = TRUE)

  Matrix::writeMM(expr_mat, file.path(mtx_dir, "matrix.mtx"))
  writeLines(rownames(expr_mat), file.path(mtx_dir, "features.tsv"))
  writeLines(colnames(expr_mat), file.path(mtx_dir, "barcodes.tsv"))
  write.csv(data.frame(row.names = colnames(expr_mat)),
            file.path(mtx_dir, "cell_meta.csv"))

  h5ad_path <- file.path(mtx_dir, "input.h5ad")
  mtx_to_h5ad_py <- sprintf('
import anndata, scipy.io, pandas as pd
X   = scipy.io.mmread("%s/matrix.mtx").T.tocsr()
obs = pd.read_csv("%s/cell_meta.csv", index_col=0)
var = pd.DataFrame(index=open("%s/features.tsv").read().splitlines())
adata = anndata.AnnData(X=X, obs=obs, var=var)
adata.write_h5ad("%s")
', mtx_dir, mtx_dir, mtx_dir, h5ad_path)
  py_h5ad <- tempfile(fileext = ".py")
  writeLines(mtx_to_h5ad_py, py_h5ad)
  cat(system2(python_bin, py_h5ad, stdout = TRUE, stderr = TRUE), sep = "\n")
  stopifnot(file.exists(h5ad_path))

  pred_csvs  <- setNames(file.path(mtx_dir, paste0("pred_", names(model_paths), ".csv")), names(model_paths))
  score_csvs <- setNames(file.path(mtx_dir, paste0("score_", names(model_paths), ".csv")), names(model_paths))

  jobs_lines <- paste(sprintf(
    '        ("%s", "%s", "%s", "%s")',
    names(model_paths), model_paths, pred_csvs, score_csvs), collapse = ",\n")
  celltypist_py <- sprintf('
import celltypist, warnings
warnings.filterwarnings("ignore")

jobs = [
%s
]
for level, model_path, out_csv, score_csv in jobs:
    model = celltypist.models.Model.load(model=model_path)
    pred  = celltypist.annotate(filename="%s", model=model,
                                majority_voting=%s, over_clustering=None)
    pred.predicted_labels.to_csv(out_csv)
    pred.probability_matrix.to_csv(score_csv)
    print(f"{level}: {len(pred.predicted_labels)} cells -> {out_csv}")
', jobs_lines, h5ad_path, if (majority_voting) "True" else "False")
  py_ct <- tempfile(fileext = ".py")
  writeLines(celltypist_py, py_ct)
  cat(system2(python_bin, py_ct, stdout = TRUE, stderr = TRUE), sep = "\n")
  for (nm in names(pred_csvs)) stopifnot(file.exists(pred_csvs[nm]))

  if (!is.null(persist_score_csv)) {
    for (level in names(persist_score_csv)) {
      file.copy(score_csvs[[level]], persist_score_csv[[level]], overwrite = TRUE)
    }
  }

  setNames(lapply(names(model_paths), function(level) {
    df <- read.csv(pred_csvs[level], row.names = 1, check.names = FALSE)
    out <- data.frame(barcode = rownames(df), predicted_label = df$predicted_labels,
                      stringsAsFactors = FALSE)
    if (include_scores) {
      score_df <- read.csv(score_csvs[level], row.names = 1, check.names = FALSE)
      prob_mat <- as.matrix(score_df)
      row_idx <- match(out$barcode, rownames(prob_mat))
      col_idx <- match(out$predicted_label, colnames(prob_mat))
      ok <- !is.na(row_idx) & !is.na(col_idx)
      out$score <- NA_real_
      out$score[ok] <- prob_mat[cbind(row_idx[ok], col_idx[ok])]
    }
    out
  }), names(model_paths))
}

#' Annotate a Seurat object with CellTypist at one or more label resolutions
#'
#' Exports `assay`/`layer` expression to h5ad, runs CellTypist once per
#' model in `model_paths` (see `celltypist_aifi_predict_matrix()`), and
#' writes `celltypist_label_raw_<level>` / `celltypist_score_<level>`
#' columns back into `so@meta.data` (`NA` for any cell CellTypist did not
#' return a prediction for).
#'
#' @param so Seurat object.
#' @param model_paths Named vector/list of CellTypist `.pkl` model paths.
#' @param python_bin Path to a Python executable with `celltypist` installed.
#' @param assay,layer Assay/layer to pull expression from (must already be
#'   log1p-normalized, e.g. Seurat's `data` layer; join any per-sample-split
#'   layers first if needed).
#' @param majority_voting Passed to `celltypist.annotate()`.
#' @param persist_score_csv Optional named vector/list of destination file
#'   paths (same names as `model_paths`) to save each level's full
#'   probability matrix CSV to; see `celltypist_aifi_predict_matrix()`.
#' @param tmp_dir Directory for intermediate matrix/h5ad files.
#'
#' @return `so` with the new `celltypist_label_raw_<level>` /
#'   `celltypist_score_<level>` metadata columns added, one pair per name in
#'   `model_paths`.
#' @export
celltypist_aifi_annotate <- function(so, model_paths, python_bin,
                                     assay = "RNA", layer = "data",
                                     majority_voting = FALSE,
                                     persist_score_csv = NULL, tmp_dir = tempdir()) {
  expr_mat <- SeuratObject::LayerData(so, assay = assay, layer = layer)
  preds <- celltypist_aifi_predict_matrix(expr_mat, model_paths, python_bin,
                                          majority_voting = majority_voting,
                                          include_scores = TRUE,
                                          persist_score_csv = persist_score_csv,
                                          tmp_dir = tmp_dir)
  for (level in names(preds)) {
    df <- preds[[level]]
    label_col <- paste0("celltypist_label_raw_", level)
    score_col <- paste0("celltypist_score_", level)
    vals <- rep(NA_character_, ncol(so))
    vals[match(df$barcode, colnames(so))] <- df$predicted_label
    so@meta.data[[label_col]] <- vals
    score_vals <- rep(NA_real_, ncol(so))
    score_vals[match(df$barcode, colnames(so))] <- df$score
    so@meta.data[[score_col]] <- score_vals
  }
  so
}

#' Load an AIFI Immune Health Atlas color/order palette for one label level
#'
#' @param level Palette resolution, e.g. `"L1"`, `"L2"`, `"L3"`, or
#'   `"combined"`.
#' @param model_dir Directory the palette CSVs (`AIFI_CELLTYPIST_PALETTES`)
#'   were downloaded into (see `ensure_downloaded()`).
#' @param strict If `TRUE`, error when the palette file is missing; if
#'   `FALSE` (default), return `NULL` so callers can fall back to a gray
#'   scale via `make_ct_cols()`/`order_labels()`.
#'
#' @return A list with `cols_all` (named color vector) and `order` (named
#'   rank vector, giving the Allen/AIFI hierarchy row order), or `NULL`.
#' @export
load_aifi_pal <- function(level, model_dir = path.expand("~/.celltypist/data/models"),
                          strict = FALSE) {
  path <- file.path(model_dir, sprintf("AIFI_%s_imm_health_atlas_type_order_colors.csv", level))
  if (!file.exists(path)) {
    if (strict) stop(sprintf("AIFI %s palette not found: %s", level, path))
    return(NULL)
  }
  pal       <- read.csv(path, stringsAsFactors = FALSE)
  type_col  <- sprintf("AIFI_%s", level)
  color_col <- sprintf("AIFI_%s_color", level)
  list(
    cols_all = setNames(pal[[color_col]], pal[[type_col]]),
    order    = setNames(seq_len(nrow(pal)), pal[[type_col]])
  )
}

#' Build a color vector for a set of labels from an AIFI palette
#'
#' Labels not found in `pal` (or when `pal` is `NULL`, e.g. the palette file
#' was unavailable) fall back to a gray gradient so the plot still renders.
#'
#' @param labels Character vector of labels to color.
#' @param pal A palette as returned by `load_aifi_pal()`, or `NULL`.
#'
#' @return A named color vector, names matching `labels`.
#' @export
make_ct_cols <- function(labels, pal) {
  if (is.null(pal)) return(setNames(colorRampPalette(c("gray40", "gray80"))(length(labels)), labels))
  cols    <- pal$cols_all[labels]
  missing <- labels[is.na(cols)]
  if (length(missing) > 0) cols[missing] <- colorRampPalette(c("gray40", "gray80"))(length(missing))
  setNames(as.character(cols), labels)
}

#' Sort labels by their AIFI Immune Health Atlas hierarchy order
#'
#' @param labels Character vector of labels to sort.
#' @param pal A palette as returned by `load_aifi_pal()`, or `NULL` (in
#'   which case `labels` is returned unchanged).
#'
#' @return `labels`, sorted by palette row order (unranked labels last).
#' @export
order_labels <- function(labels, pal) {
  if (is.null(pal)) return(labels)
  ranks <- sapply(labels, function(l) if (l %in% names(pal$order)) pal$order[[l]] else Inf)
  labels[order(ranks)]
}
