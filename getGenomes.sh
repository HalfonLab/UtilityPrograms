#!/bin/bash

####################################################
# script for getting new genomes and annotations   #
# for running SCRMshaw                             #
#												   #
# This script should be run from the directory     #
# in which you want the final files to end up     #
#                                                  #
# e.g. if you want these to be in "~/genomeA"      #
# then "mkdir ~/genomeA" and run from "~/genomeA"  #
#                                                  #
# (c) Marc S. Halfon                               #
# revision history:                                #
# version 1: August 31 2023                        #
####################################################

#Usage: ./getGenome [GCF_xxxxxxxxxx]

#check if accession is on command line, otherwise ask for it:
if [ "$#" -ne 1 ]; then
	echo -n "Enter accession number: "
	read -n ACCESSION
	
else
	 ACCESSION=$1	
	
fi	

#for running @CCR
#download the files using NCBI 'datasets'
/projects/academic/mshalfon/datasets download genome accession $ACCESSION --assembly-source refseq --include genome,protein,gff3

# for running from my desktop
# ~/bioinformatics_software/datasets download genome accession $ACCESSION --assembly-source refseq --include genome,protein,gff3

#uncompress the file
unzip ncbi_dataset

#check that annotation and protein files are present:
if [[ ! -f "ncbi_dataset/data/$ACCESSION/genomic.gff"  || ! -f "ncbi_dataset/data/$ACCESSION/protein.faa" ]];
then
	echo "Warning: no GFFv3 and/or protein.faa file found"
fi
	
	
#move to the current directory:
mv ncbi_dataset/data/$ACCESSION/* .
mv ncbi_dataset/data/assembly_data_report.jsonl .

 
#cleanup:  
rm -r ncbi_dataset/ ncbi_dataset.zip README.md


		
		