#!/bin/bash

#***************************************************************#
#    		 		Generate the STAR Index              	    #
#               	STEP 1 IN STAR PIPELINE   	                #
#***************************************************************#

#--------------------------sbatch header------------------------#

#SBATCH --job-name=STAR_index
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=80GB
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francisca.samsingpedrals@csiro.au
#SBATCH --output=../Logs/star_%A.out

module load star/2.5.3a

# Working Dictories 
INPDIR=/scratch1/sam079/RAL_hemoRNAseq/P_monodon
OUTDIR=/scratch1/sam079/RAL_hemoRNAseq/Star


STAR \
--runMode genomeGenerate \
--genomeDir ${OUTDIR}/Index_V2_trans \
--runThreadN 8 \
--genomeFastaFiles ${INPDIR}/GGLH01.1.fsa_nt \
--genomeChrBinNbits 10 \
--outFileNamePrefix ../Logs/star_ 


## --genomeChrBinNbits 10 because 
# log2(GenomeLength/NumberOfReferences) = 9.9
# Genome Length = 225712489 (grep -v '^>' GGLH01.1.fsa_nt | tr -d '\n' | wc -c)
# NumberOfReferences = 236085 (grep -c '^>' GGLH01.1.fsa_nt)

