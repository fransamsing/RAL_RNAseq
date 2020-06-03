#!/bin/bash

#***************************************************************#
#        Align Raw Reads Against P_monodon Transcriptome        #
#                  STEP 2 IN SALMON PIPELINE                    #
#***************************************************************#

#--------------------------sbatch header------------------------#

#SBATCH --job-name=Salmon_align
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40GB
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francisca.samsingpedrals@csiro.au
#SBATCH --output=../Logs/salmon_align_%A.out
#SBATCH --array=0-17


module load jemalloc
export OMP_NUM_THREADS=$SLURM_NTASKS_PER_NODE
module load salmon/1.1.0

# Working Dictories 
INPDIR=/scratch1/sam079/RAL_hemoRNAseq/Data
REFDIR=/scratch1/sam079/RAL_hemoRNAseq/Salmon/Index
OUTDIR=/scratch1/sam079/RAL_hemoRNAseq/Salmon/Align

SAMPLES=( $(cut -d , -f 1 ../STARInputList.csv) );
INFILES_R1=( $(cut -d , -f 2 ../STARInputList.csv) );
INFILES_R2=( $(cut -d , -f 3 ../STARInputList.csv) );


if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
then
    i=$SLURM_ARRAY_TASK_ID
    salmon quant \
    -i ${REFDIR}/P_monodon_index \
    --useVBOpt \
    --seqBias \
    -p 8 \
    -l A \
    -1 ${INPDIR}/${INFILES_R1[$i]} \
    -2 ${INPDIR}/${INFILES_R2[$i]} \
    -o ${OUTDIR}/${SAMPLES[$i]}

else
    echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
fi



