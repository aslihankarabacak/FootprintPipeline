ACLOCAL_AMFLAGS = -I m4

nodist_bin_SCRIPTS = \
  find_footprints.sh

nodist_libexec_SCRIPTS =	\
  MixtureModel.r			\
  RebuildSignal.pl			\
  generate_cut_matrix.sh	\
  get_cut_matrix.R			\
  make_1bp_bam_for_fp.sh	\
  make_coord_seq_files.sh	\
  run_footprinting.R

dist_pkgdata_DATA =				\
  SeqBias_ATAC.txt				\
  SeqBias_DNase_doublehit.txt	\
  SeqBias_DNase_singlehit.txt

EXTRA_DIST = 				\
  guix.scm					\
  MixtureModel.r.in			\
  test_data/ATAC_HEK293_hg19_chr1.bam		\
  test_data/hg19.chr1.chrom.size			\
  test_data/hg19_chr1.fa					\
  test_data/hg19_chr1.fa.fai				\
  test_data/CTCF_motifs_hg19_chr1.bed		\
  test_data/CTCF_HEK293_chip_hg19_chr1.bed

dist_doc_DATA =				\
  README

CLEANFILES = $(nodist_libexec_SCRIPTS) $(nodist_bin_SCRIPTS)

TESTS = test.sh

# This is a hack to let the scripts know where to find the pipeline
# scripts after installation.
find_footprints.sh: find_footprints.sh.in
	sed -e "s|#:MAKE|$(libexecdir)|" -i $<
	mv $< $@

generate_cut_matrix.sh: generate_cut_matrix.sh.in
	sed -e "s|#:MAKE|$(libexecdir)|" -i $<
	mv $< $@

run_footprinting.R: run_footprinting.R.in
	sed -e "s|#:MAKE|\nlibexecdir <- Sys.getenv(\"FOOTPRINT_UNINSTALLED\", \"$(libexecdir)\")|" $< > $@

MixtureModel.r: MixtureModel.r.in
	sed -e "s|#:MAKE|\nlibexecdir <- Sys.getenv(\"FOOTPRINT_UNINSTALLED\", \"$(libexecdir)\")|" $< > $@
