# FootprintPipeline
This is a pipeline to find transcription factor footprints in DNase-seq or ATAC-seq datasets.

## Requirements

* R version '2.15.' or higher
* R libraries ‘mixtools’, ‘gtools’ and ‘GenomicRanges’
* Perl
* SAMtools version 1.1
* BEDTools version 2.17.0


## Download

Linux users can download the pipeline [here][link].

[link]: http://bimsbstatic.mdc-berlin.de/ohler/asli/footprint-pipeline-1.0.1.tar.gz


## Installation

Extract the contents of the downloaded archive:  
tar -xvzf footprint-pipeline-1.0.1.tar.gz

Change into the pipeline's directory and configure:  
cd footprint-pipeline-1.0.1  
./configure --prefix=/tmp/my-test  

Note: If the necessary executables are not in the path, or their versions are incompatible with the pipeline (see the requirements section above), the full paths of the correct executables can be specified for the configuration. See below an example containing all BEDTools executables used by the pipeline, alongside SAMtools:
./configure COVERAGEBED=/path/to/coverageBed FASTAFROMBED=/path/to/fastaFromBed BAMTOBED=/path/to/bamToBed BEDTOBAM=/path/to/bedToBam BEDTOOLS=/path/to/bedtools SAMTOOLS=/path/to/samtools --prefix=/tmp/my-test

Make, run the test and install:  
make  
make check  
make install

Note: This will install the pipeline to /tmp/my-test directory. This can be changed by supplying the desired directory to the --prefix argument in the configuration step.


## Usage

The main executable find_footprints.sh can be found in /bin, under the specified installation directory.   
Running "bash find_footprints.sh" will list the expected inputs.

To run the pipeline, find_footprints.sh is executed in the following way:

bash find_footprints.sh bam_file chrom_sizes motif_coords genome_fasta factor_name bias_file peak_file no_of_components background fixed_bg 

The arguments are explained below:

    bam_file:
        The bam file from the ATAC-seq or DNase-seq experiment.

    chrom_sizes:
        A tab delimited file with 2 columns, where the first column is
        the chromosome name and the second column is the chromosome
        length for the appropriate organism and genome build.

    motif_coords:
        A 6-column file with the coordinates of motif matches (eg
        resulting from scanning the genome with a PWM) for the
        transcription factor of interest. The 6 columns should contain
        chromosome, start coordinate, end coordinate, name, score and
        strand information in this order. There should not be any additional
        columns.The coordinates should be closed (1-based).

    genome_fasta:
        A multi-fasta format file that contains the whole genome
        sequence for the appropriate organism and genome build. This
        file should be indexed (eg by using samtools faidx) and placed
        in the same directory.

    factor_name:
        The name of the transcription factor of interest supplied by
        the user. This is used in the naming of the output files.

    bias_file:
        A file listing the cleavage/transposition bias of the
        different protocols, for all 6-mers. Provided options: ATAC,
        DNase double hit or DNase single hit protocols.

    peak_file:
        A file with the coordinates of the ChIP-seq peaks for the
        transcription factor of interest. The format is flexible as
        long as the first 3 columns (chromosome, start coordinate, end
        coordinate) are present.

    no_of_components:
        Total number of footprint and background components that
        should be learned from the data. Options are 2 (1 fp and 1 bg)
        and 3 (2 fp and 1 bg) components.

    background:
        The mode of initialization for the background
        component. Options are "Flat" or "Seq". Choosing "Flat"
        initializes this component as a uniform distribution. Choosing
        "Seq" initializes it as the signal profile that would be
        expected solely due to the protocol bias (given by the
        bias_file parameter).

     fixed_bg:
        Whether the background component should be kept fixed. Options
        are TRUE/T or FALSE/F. Setting "TRUE" keeps this component
        fixed, whereas setting "FALSE" lets it be reestimated during
        training. In general, if the background is estimated from bias 
        (option "Seq"), it is recommended to keep it fixed.
                       

For instance to run the pipeline on the test data with 2 components, estimating the background from the protocol bias and keeping it fixed, execute the following command:

bash find_footprints.sh test_data/ATAC_HEK293_hg19_chr1.bam test_data/hg19.chr1.chrom.size test_data/CTCF_motifs_hg19_chr1.bed test_data/hg19_chr1.fa CTCF SeqBias_ATAC.txt test_data/CTCF_HEK293_chip_hg19_chr1.bed 2 Seq T


Important note: Please make sure that the "bam_file" and the "motif_coords" inputs are the only files in their respective directories. This is recommended to avoid overwriting any existing files, as the pipeline generates temporary files in these directories.


The pipeline outputs 4 files (in the same directory as the input "bam_file"):

    File with the ".RESULTS" extension: 
        Gives the results of the footprinting analysis. The first 6 
        columns harbor the motif information (identical to the motif_coords 
        input file). The 7th column has the footprint score (log-odds of 
        footprint versus background) for each motif instance. The following 
        columns show the probabilities for the individual footprint and 
        background components.

    File with the ".PARAM" extension: 
        Gives the trained parameters for the footprint and background 
        components. It includes as many lines as components (eg the first 
        line has the parameters for the first component).
   
    Png file named "plot1": 
        A plot with two panels, showing the initial components above 
        and the final trained components below. The plotted values for the 
        final components are given in the .PARAM output file explained above.

    Png file named "plot2": 
        A plot only with the final trained components. In a model where 2 
        components are used, this plot is identical to the bottom panel in 
        plot1. When 3 components are used, this plot shows the weighted average 
        of the 2 footprint components as the final footprint profile. 
