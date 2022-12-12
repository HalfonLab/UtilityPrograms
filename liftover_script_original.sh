#!/bin/bash

####################################################################
#script for liftOver to get sequences for SCRMshaw training sets   #
# (c) Marc S. Halfon November 28, 2017                             #
#Takes a BED file of CRMs and gets aligned sequences from other    #
#Drosophila species. To do this must first convert to Dm3          #
#coordinates. This is done using liftOver. Other species           #
#coordinates are then obtained also using liftOver.                #
#The log file lists how many unmapped sequences from each.         #
#Coordinates for other species are fed to bedtools getfasta to get #
#actual FASTA files.                                               #
#Finally, the FASTA headers are modified to contain the species    #
#and genome build.                                                 #
# **NOTE that the chain file names and header modifications are    #
#hard-coded and need to be changed when changing species and/or    #
#builds.                                                           #
#NOTE: if you get this error: “Can’t do inplace edit on test.bed.fa#
# File exists”  to change the “-i” to “-i.orig” and then just      #
#optionally delete the “.orig” file when finished..		   #
#								   #	
#revision history:                                                 #
#version 1: November 28 2017                                       #
####################################################################


#Usage: cmd line provide (1) Dm6 bed file (2) path to liftOver (3) path to chain files (4) path to genome fastas

#check number of arguments
if [ "$#" -ne 4 ]; then
	echo "Usage: $0 Dm6_bed_file path_to_liftOver path_to_chain_files path_to_genome_fastas"
	exit 1
fi	

Dm6BED=$1
LIFTOVERDIR=$2
CHAINDIR=$3
FASTADIR=$4


#check file and directory types
if [ ! -f "$Dm6BED" ]; then
	echo "$Dm6BED not a file"
	exit 1
fi

if [ ! -d "$LIFTOVERDIR" ]; then
	echo "$LIFTOVERDIR not a valid directory"
	exit 1
fi	

if [ ! -d "$CHAINDIR" ]; then
	echo "$CHAINDIR not a valid directory"
	exit 1
fi

if [ ! -d "$FASTADIR" ]; then
	echo "$FASTADIR not a valid directory"
	exit 1
fi

# echo $LIFTOVERDIR
# echo $CHAINDIR
# echo $FASTADIR


date=`date +%m%d%Y`

#create output directory
#outdir="output.$date"
#mkdir $outdir

#create log file
logfile="log.liftover.$date"
echo "liftOver log $date" 1>$logfile

echo "Input file: $Dm6BED" 1>>$logfile

totalstarting=`wc -l $Dm6BED`
echo "number of input sequences: $totalstarting" 1>>$logfile

#----------------------------------------#
#convert Dm6 coordinates BED file to Dm3 to use with liftOver
DM3BED="dm3.$Dm6BED"
#echo $DM3BED

$LIFTOVERDIR/liftOver -minMatch=0.25 $Dm6BED $CHAINDIR/dm6ToDm3.over.chain $DM3BED $DM3BED.unmapped  ##1>>$logfile

NUM=`grep -vc '#' dm3.$Dm6BED.unmapped`
echo "Dm3 unmapped: $NUM" 1>>$logfile

totalconverted=`wc -l $DM3BED`
echo "number of dm3 sequences: $totalconverted" 1>>$logfile

#===================================================#
#species loop:
# species: Dana Dere Dgri Dmoj Dper Dpse Dsec Dsim Dvir Dyak
#this section loops through the species and performs both liftOver and getfasta
#to add/delete species, need to:
# (1) add/delete from "FOR" statement and
# (2) add/delete "CASE" with appropriate file names
# (3) add/delete header correction in following section

for SPECIES in Dana Dere Dgri Dmoj Dper Dpse Dsec Dsim Dvir Dyak
do

#----------------------------------------#
#case to set species-specific variables
case $SPECIES in
Dana)
	chainfile="dm3ToDroAna3.over.chain"
	fastafile="droAna3.fa"
	;;
Dere)
	chainfile="dm3ToDroEre2.over.chain"
	fastafile="droEre2.fa"
	;;
Dgri)
	chainfile="dm3ToDroGri2.over.chain"
	fastafile="droGri2.fa"
	;;
Dmoj)
	chainfile="dm3ToDroMoj3.over.chain"
	fastafile="droMoj3.fa"
	;;
Dper)
	chainfile="dm3ToDroPer1.over.chain "
	fastafile="Per1scaffoldFa"
	;;
Dpse)
	chainfile="dm3ToDp4.over.chain"
	fastafile="dp4.fa"
	;;
Dsec)
	chainfile="dm3ToDroSec1.over.chain"
	fastafile="Sec1scaffoldFa"
	;;
Dsim)
	chainfile="dm3ToDroSim1.over.chain"
	fastafile="Sim1.all.fa"
	;;
Dvir)
	chainfile="dm3ToDroVir3.over.chain"
	fastafile="droVir3.fa"
	;;
Dyak)
	chainfile="dm3ToDroYak2.over.chain"
	fastafile="yak2.all.fa"
	;;
esac

#----------------------------------------#								
#liftover and bedtools 'getfasta'
echo Starting $SPECIES

$LIFTOVERDIR/liftOver -minMatch=0.25 $DM3BED $CHAINDIR/$chainfile $SPECIES.$DM3BED $SPECIES.$DM3BED.unmapped 
echo ""

NUM=`grep -vc '#' $SPECIES.$DM3BED.unmapped`
echo "$SPECIES unmapped: $NUM" 1>>$logfile

bedtools getfasta -name -fi $FASTADIR/$fastafile -bed $SPECIES.$DM3BED -fo $SPECIES.$Dm6BED.fa

done   #end of loop

#===================================================#
#header correction
#this section puts the species name and build into the FASTA header
#must check proper syntax for each species/build

perl -i -pe 's/\:scaffold/Dana3\:scaffold/' Dana.$Dm6BED.fa
perl -i -pe 's/\:scaffold/Dere2\:scaffold/' Dere.$Dm6BED.fa
perl -i -pe 's/\:scaffold/Dgri2\:scaffold/' Dgri.$Dm6BED.fa
perl -i -pe 's/\:scaffold/Dmoj3\:scaffold/' Dmoj.$Dm6BED.fa
perl -i -pe 's/\:super/Dper\:super/' Dper.$Dm6BED.fa
perl -i -pe 's/\:chr/Dpse4\:chr/' Dpse.$Dm6BED.fa
perl -i -pe 's/\:super/DSec1\:super/' Dsec.$Dm6BED.fa
perl -i -pe 's/\:chr/DSim1\:chr/' Dsim.$Dm6BED.fa
perl -i -pe 's/\:scaffold/Dvir3\:scaffold/' Dvir.$Dm6BED.fa
perl -i -pe 's/\:chr/Dyak2\:chr/' Dyak.$Dm6BED.fa


################################
#notes:
# can use grep to extract desired subset of FASTA sequences. Code is:
# grep -h -A 1 '[name(s) of CRM]' *.fa > outfile
# perl -i -pe 's/^--\n//' outfile




