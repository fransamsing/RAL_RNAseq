#!/bin/bash

# Cut the md5sum column from METADATA_final.csv, sort and save as an intermediate file
cut -d , -f1 ../METADATA.csv | grep -v md5sum > ../Results/md5sum_from_provider.txt

# Run md5sum command on data files in Bowen
md5sum /OSM/CBR/AF_RIDLEYWP4/work/ral_hemoRNAseq_rawDATA/*.gz > ../Results/md5sum_from_data.txt

md5sum /scratch1/sam079/RAL_hemoRNAseq/Data/*.gz > ../Results/md5sum_from_data_in_scractch1.txt
