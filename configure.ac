dnl -*- Autoconf -*-

AC_INIT(footprint-pipeline, [m4_translit(m4_esyscmd([cat VERSION]),m4_newline)])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([gnu color-tests -Wall -Wno-portability foreign])
AM_SILENT_RULES([yes])

dnl Check for any variant of "awk" and store path in "AWK" variable
AC_PROG_AWK
dnl Check for any variant of "sed" and store path in "SED" variable
AC_PROG_SED

dnl Check for required programmes and store their full path in the
dnl given variables.  The variables are used to substitute
dnl placeholders in the scripts.

dnl The variables only need to be set manually when they cannot be
dnl found via the PATH environment variable.
AC_DEFUN([find_or_override_prog],
[AC_ARG_VAR($1, override location of $2 executable)dnl
AS_IF([test -z "$$1"],dnl
      [AC_PATH_PROG([$1], [$2], no)dnl
      if test x"$$1" == x"no" ; then
        AC_MSG_ERROR([Could not find $2.])
      fi
      ],dnl
      [AC_MSG_NOTICE([Using $$1 as $2 executable.])])])

find_or_override_prog([GNUBASH],       [bash])
find_or_override_prog([SAMTOOLS],      [samtools])

find_or_override_prog([BEDTOOLS],      [bedtools])

BEDTOOLS_VERSION_MAX=2.18.0
BEDTOOLS_VERSION=$($BEDTOOLS --version | $SED 's/^bedtools v//')
AX_COMPARE_VERSION([$BEDTOOLS_VERSION], [gt], [$BEDTOOLS_VERSION_MAX],
      [AC_MSG_ERROR([The output format of your version of bedtools is not compatible with what this pipeline expects.  Please install Bedtools $BEDTOOLS_VERSION_MAX or lower.])])

find_or_override_prog([BEDTOBAM],      [bedToBam])
find_or_override_prog([BAMTOBED],      [bamToBed])
find_or_override_prog([FASTAFROMBED],  [fastaFromBed])
find_or_override_prog([COVERAGEBED],   [coverageBed])

find_or_override_prog([R],             [R])
find_or_override_prog([RSCRIPT],       [Rscript])
find_or_override_prog([PERL],          [perl])

if test "x$R" == x
then
  AC_MSG_ERROR([R could not be found, so we cannot test for R packages.])
else
  AX_R_PACKAGE([gtools])
  AX_R_PACKAGE([GenomicRanges])
  AX_R_PACKAGE([mixtools])
fi

AC_CONFIG_FILES([Makefile
                 generate_cut_matrix.sh.in
                 get_cut_matrix.R
                 make_1bp_bam_for_fp.sh
                 make_coord_seq_files.sh
                 run_footprinting.R.in])

AC_CONFIG_FILES([test.sh], [chmod +x test.sh])
AC_CONFIG_FILES([find_footprints.sh.in], [chmod +x find_footprints.sh.in])
AC_CONFIG_FILES([RebuildSignal.pl], [chmod +x RebuildSignal.pl])

AC_OUTPUT
