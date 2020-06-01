#!/bin/bash

#***************************************************************#
#    		 	 Generate the SALMON Index               	    #
#                STEP 1 IN SALMON PIPELINE   	                #
#***************************************************************#

#--------------------------sbatch header------------------------#

#SBATCH --job-name=Salmon_index
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=80GB
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francisca.samsingpedrals@csiro.au
#SBATCH --output=../Logs/salmon_%A.out

module load salmon/1.1.0

# Working Dictories 
INPDIR=/scratch1/sam079/RAL_hemoRNAseq/P_monodon
OUTDIR=/scratch1/sam079/RAL_hemoRNAseq/Salmon/Index

salmon index \
-t ${INPDIR}/GGLH01.1.fsa_nt \
-i ${OUTDIR}/P_monodon_index \
-p 8 




