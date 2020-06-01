#!/bin/bash

#***************************************************************#
#          Generate the Trancriptome Index using Bowtie         #
#               STEP 1 IN BOWTIE-TOPHAT PIPELINE                #
#***************************************************************#

#--------------------------sbatch header------------------------#

#SBATCH --job-name=BOWTIE_index
#SBATCH --time=08:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100GB
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francisca.samsingpedrals@csiro.au
#SBATCH --output=../Logs/bowtie_%A.out

module load bowtie/2.2.9

#Working Directories
INPDIR=/scratch1/sam079/RAL_hemoRNAseq/P_monodon
OUTDIR=/scratch1/sam079/RAL_hemoRNAseq/Bowtie_index

bowtie2-build --threads 8 ${INPDIR}/GGLH01.1.fsa_nt ${OUTDIR}/P_monodon_transcriptome
