#!/bin/bash

#***************************************************************#
#        Align Raw Reads Against P_monodon Transcriptome        #
#                      STEP 2 IN STAR PIPELINE                  #
#***************************************************************#

#--------------------------sbatch header------------------------#

#SBATCH --job-name=STAR_align
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40GB
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francisca.samsingpedrals@csiro.au
#SBATCH --output=../Logs/star_%A.out
#SBATCH --array=0-17


module load jemalloc
export OMP_NUM_THREADS=$SLURM_NTASKS_PER_NODE
module load star/2.5.3a

# Working Dictories 
INPDIR=/scratch1/sam079/RAL_hemoRNAseq/Data
REFDIR=/scratch1/sam079/RAL_hemoRNAseq/Star/Index_V2_trans
OUTDIR=/scratch1/sam079/RAL_hemoRNAseq/Star/Align_V2_trans

SAMPLES=( $(cut -d , -f 1 ../STARInputList.csv) );
INFILES_R1=( $(cut -d , -f 2 ../STARInputList.csv) );
INFILES_R2=( $(cut -d , -f 3 ../STARInputList.csv) );


if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
then
    i=$SLURM_ARRAY_TASK_ID
    STAR \
    --genomeDir ${REFDIR}/ \
    --runThreadN 8 \
    --readFilesIn ${INPDIR}/${INFILES_R1[$i]} ${INPDIR}/${INFILES_R2[$i]} \
    --readFilesCommand zcat \
    --outFileNamePrefix ${OUTDIR}/${SAMPLES[$i]} \
    --outFilterMismatchNmax 2 \
    --outSAMtype BAM SortedByCoordinate \
    --outReadsUnmapped Fastx \
    --outFilterMismatchNoverLmax 0.05


else
    echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
fi



