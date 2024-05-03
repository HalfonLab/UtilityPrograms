#Before running this script, please make sure you are in the Project_OM folder, and the folder looks exactly like step 27 with only those files in a similar naming style, including file types

#This script will run the following processes:
#-Create a mapping file that associates gene-ids with protein IDs, since SCRMshaw predictions have associated gene-ids and not protein-ids.
#-Run the OM Mapping scripts that map D. melanogaster orthologs to each SCRMshaw prediction

#Puts all the files in the orthologer_output folder
mv *gff* orthologer_output
mv scrmshaw*.bed orthologer_output
cd orthologer_output


#finding the scrmshaw file
scrmshawbed=($(find . -name "*.bed" -print))
re=$(echo ${scrmshawbed[@]} | cut -c3-)
if [ ${#scrmshawbed[@]} -gt 0 ]; then
    echo "SCRMshaw result found: $re"
else
    echo "SCRMshaw file not found."
fi




#finding the mydata.og document
mydata=($(find . -name "mydata*" -print))
mynewdata=${mydata[@]}
if [ ${#mydata[@]} -gt 0 ]; then
    echo "mydata result found: ${mydata[@]}"
else
    echo "Mydata file not found."
fi




#finding the gff file
gff_file=($(find . -name "*.gff*" -print))
if [ ${#gff_file[@]} -gt 0 ]; then
    echo "Genomic gff result found: ${gff_file[@]}"
else
    echo "Genomic gff file not found."
fi




#finding the maptxt files
#Note: one of them has to be named DMEL_PROTEIN.fs.maptxt




file_with_dmel=$(find . -maxdepth 1 -type f -name '*DMEL*.maptxt' -print)




if [ -n "$file_with_dmel" ]; then
    echo "DMEL protein maptxt file found: $file_with_dmel"
    
    file_without_dmel=$(find . -maxdepth 1 -type f -name '*.maptxt' -not -name "*DMEL*.maptxt" -print)
    
    if [ -n "$file_without_dmel" ]; then
        echo "Species protein maptxt': $file_without_dmel"
    else
        echo "Species protein maptxt not found"
    fi
else
    echo "DMEL protein maptxt file not found."
fi








#This code will create the mapping file from the gff file.
awk -F'[=;]' '/CDS/ && !/#/ {gene_id=""; protein_id=""; for(i=1; i<NF; i+=2) { if($i=="gene") gene_id="gene-" $(i+1); if($i=="protein_id") protein_id=$(i+1) } } {if(gene_id && protein_id) print gene_id "\t" protein_id}' ${gff_file[@]} | sort -u > speciesX_genomic_finalMapped.gff




#Clone and run the scripts that would map fly orthologs to each SCRMshaw prediction
git clone https://github.com/HalfonLab/Mapping-D.mel-Orthologs.git




mv speciesX_genomic_finalMapped.gff Mapping-D.mel-Orthologs/
mv $re Mapping-D.mel-Orthologs/
mv $file_with_dmel Mapping-D.mel-Orthologs/
mv $file_without_dmel Mapping-D.mel-Orthologs/
mv $mynewdata Mapping-D.mel-Orthologs/
cd Mapping-D.mel-Orthologs/




python /panasas/scratch/grp-mshalfon/Luna/Anopheles_gambiae/Mapping-D.mel-Orthologs/ommapping.py -sp1id speciesX_genomic_finalMapped.gff -ft GCF_000001215.4_Release_6_plus_ISO1_MT_feature_table.txt -so $re -mD $file_with_dmel -mX $file_without_dmel -og $mynewdata
echo Done
