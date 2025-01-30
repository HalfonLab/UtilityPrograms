#!/usr/bin/bash

#version 4: Jan 30 2025, MSH
#fix usage instructions

#version 3: Nov 2022 , HA
#remove scores directory content as well

#version 2: Sept 2019 , Hasiba Asma
#clean up after SCRMhshaw HD

#script for cleaning up unneeded SCRMshaw files
#specifically, what is in the /fasta subdirectory

#Usage: ./cleanup_fastadirectory.sh 
#this script should be run from the SCRMshaw results directory

#created May 11 2017, Marc S. Halfon

#The /fasta directory contains FASTA genome sequence, k-mer frequency files, and FASTA window files.
#Storage requirements for these quickly gets large. If you are only interested in the hits (predicted CRMs), you can use this script to delete the contents of the /fasta directory when finished

	
#make sure that you want to clean this directory:
echo -n "Are you sure you want to delete the contents of the fasta and score directories from all subfolders? [y/n] "

read -n 1 confirmation

echo " "

if [ "$confirmation" != "y" ]; then
	exit 2
else
	for task in task_offset_0_1 task_offset_10_2 task_offset_20_3 task_offset_30_4 task_offset_40_5 task_offset_50_6 task_offset_60_7 task_offset_70_8 task_offset_80_9 task_offset_90_10 task_offset_100_11 task_offset_110_12 task_offset_120_13 task_offset_130_14 task_offset_140_15 task_offset_150_16 task_offset_160_17 task_offset_170_18 task_offset_180_19 task_offset_190_20 task_offset_200_21 task_offset_210_22 task_offset_220_23 task_offset_230_24 task_offset_240_25
	do
		if [ ! -d "$task" ]; then
			echo "$0: invalid directory"
			exit 1
	#	fi
		else
			echo "deleting files in $task/fasta/chr..."
			rm -rf $task*/fasta/chr/*
			echo "deleting files in $task/fasta/kmers..."
			rm -rf $task*/fasta/kmers/*	
			echo "deleting files in $task/fasta/windows..."
			rm -rf $task*/fasta/windows/*
			rm -rf $task*/scores/*
		fi
	done
fi
