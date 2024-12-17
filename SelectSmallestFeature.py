#!/usr/bin/env python
# @author jbard@buffalo.edu,julienka@buffalo.edu
# @date 07-20-17
# Purpose: cluster overlapping sequences and select the set of shortest non-overlapping intervals from each cluster.
# Input: Sorted bed3+1 file (no header) : bedtools sorted -i [input.bed] > input.sorted.bed
# To run: python SelectSmallestFeature.py -i [input.sorted.bed] -d [desired basepair overlap allowed] > clustered.sort.bed

import pandas as pd
import sys
import argparse

#function to remove the largest feature from the group based on length.
def removeLargestFeature(df):
    data = df.loc[[df['length'].idxmax()]]

    if(args.unused != False ):
        data.to_csv(args.unused,mode='a', header=False, index=False, sep="\t", columns=("chrom", "start", "stop", "name"))

    df = df.drop(df['length'].idxmax())
    return df

# This section of code was sampled from bedtools cluster
def generate_new_cluster(df):
    #setting up variables to use during reclustering
    cluster_index = 0
    end = -1
    maxDistance = args.distance
    chrom = "NA"

    #for every line in the dataframe
    for index, row in df.iterrows():
        if(row.start - end > maxDistance) or (row.chrom != chrom):
            cluster_index = cluster_index + 1
            end = row.stop
            chrom = row.chrom
            df.at[index, "cluster"] = cluster_index
        else:
            if (row.stop > end):
                end = row.stop
                chrom = row.chrom
        df.at[index, "cluster"] = cluster_index

    return df # return the reclustered dataframe for further processing

def processGroup(df):
    #Step one, recluster the dataFrame
    newDF = generate_new_cluster(df)

    #Case 1: If more than one cluster exists in this dataFrame, iterate through the clusters and process again
    if newDF['cluster'].nunique() > 1:
        #iterate through each group's new DF separately and reduce
        tempDF = newDF.groupby(['cluster'])
        for index, group in tempDF:
            processGroup(tempDF.get_group(index))

    # Case 2: If the number of clusters is equal to 1 left, remove the largest feature and send it back for processing
    elif (newDF['cluster'].nunique() == 1) and (len(newDF.index) > 1):
        newDF = removeLargestFeature(newDF)
        processGroup(newDF)

    # Base case, 1 cluster, 1 row, print the feature out to stdout and be done
    else:
        newDF.to_csv(args.output,mode='a', header=False, index=False, sep="\t", columns=("chrom", "start", "stop", "name"))

##### Main processing starts here, read in the file
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input',required=True,help='Sorted bed3+1 file required: bedtools sort -i [input.bed] > input.sorted.bed')
    parser.add_argument('-o', '--output',default=sys.stdout,required=False,help='Writes to output file of selected features. (defaults to std.out (optional)')
    parser.add_argument('-u', '--unused',default=False,required=False,help='Writes to output file unselected features. (Suppressed by default (optional)')
    parser.add_argument('-d', '--distance',default=0,type=int,required=False,help='Minimum distance (bp) allowed between intervals (default 0 allows a 1bp overlap between reported features). Negative values allow for overlapping features to be reported.\n -1 requires features to have separation')
    args = parser.parse_args()

    # Prepare the output files if needed (overwrites existing files)
    if(args.output != sys.stdout):
        open(args.output,"w")

    if (args.unused != False):
        open(args.unused,"w")

    # Step one: take in the initial bedtools clustered file
    my_file = pd.read_csv(args.input,sep="\t",names = ['chrom','start','stop','name'])
    # Step two: pre-compute lengths of all features
    my_file['length'] = my_file.stop - my_file.start
    # Step three: Start the initial recursive method
    processGroup(my_file)
