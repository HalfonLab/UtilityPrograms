#!/usr/bin/env python

#(c) Hasiba Asma
#November 2022


#This script can be used to find hits per locus and size of locus
#input file should be the output of bedtools closest command

# e.g.,
#./checkSameLocus.py shuffle_closest_dmel.bed

import os
import sys
import argparse
import pprint
import re
import csv

diction={}
locusList=[]
sizeOfLocusDict={}
intronDict={}
file=sys.argv[1]

#read bed file and create output file with HitsAndSizePerLocus_ beginning
with open(file,'r') as infile:
	for line in infile:
		#print(line)
		cols=line.split('\t')
		schr=cols[0]
		sstart=cols[1]
		send=cols[2]
		leftF=cols[14]
		rightF=cols[19]
		
		sizeOfSCRM=int(send)-int(sstart)
		#sizeOfLocus=sizeOfSCRM+abs(int(cols[15]))+abs(int(cols[20]))
		sizeOfLocus= (int(cols[17]))-(int(cols[13]))
		
		

		coord=schr+':'+sstart+'-'+send
		#left and right flanked gene names- saving them together and calling this locus as 'flankedGenes'
		flankedGenes=leftF+'-'+rightF
		#creating locuslist
		if flankedGenes not in locusList:
			locusList.append(flankedGenes)
			#locusList.append(flankedGenes+':'+str(abs(sizeOfLocus)))
			#creating dictionary to save size of locus, flanked gene as a key
			if flankedGenes not in sizeOfLocusDict:
				sizeOfLocusDict[flankedGenes]=str(abs(sizeOfLocus))
			
			#adding intron information
			if leftF==rightF:
				intronDict[flankedGenes]='intronic'
			else:
				intronDict[flankedGenes]='not-intronic'

		#if locus not in dictionary add it now
		if flankedGenes not in diction:
			#print('flankedgenes not in dictionary yet')
			diction[flankedGenes]=coord
			
		#and if it is already there add it in
		else:
			if coord not in diction[flankedGenes]:
				#print('flanking genes are ',flankedGenes,' butcoord ',coord,' not in dict ',diction[flankedGenes])
				diction[flankedGenes]=diction[flankedGenes]+','+coord
				#print('added now? ',diction[flankedGenes] )



#pprint.pprint(diction)
#print(locusList)

with open('HitsAndSizePerLocus_'+file,'w') as outfile:
	for item in diction.keys():
		#print(item)
		scrms=diction[item].split(',')
		#print(item,' ',str(len(scrms)),' ',sizeOfLocusDict[item])
		outfile.write(item+'\t'+str(len(scrms))+'\t'+sizeOfLocusDict[item]+'\t'+intronDict[item]+'\n')
	
