(c) Hasiba Asma

# CheckSameLocus for Simulation

This is a Python script that processes the output files generated by the bedtools closest command. It analyzes the files in a specified directory to extract relevant information and generate a new output file for each input file.

  ## Prerequisites

Python 3.x

  ## Usage

`python checkSameLocus_ForSimulation.py <directory>`

directory: The directory that contains all the output files from the bedtools closest command. Make sure there are no other files in this directory.

  ## Functionality

The script loops over all the files in the specified directory and performs the following operations for each file:

- Initializes dictionaries and lists for storing data.
- Reads the input file line by line and extracts relevant information.
- Calculates the size of the locus based on the extracted information.
- Creates a list of unique loci and updates the dictionaries accordingly.
- Saves the locus hits, size, and intron information in the output file.

The output file is named HitsAndSizePerLocus_<input_file_name>.

  ## Output Format

The output file contains the following columns:

- Flanked Genes: Names of the left and right flanking genes separated by a hyphen.
- Hit Count: Number of hits in the locus.
- Locus Size: Size of the locus.
- Intron Status: Indicates whether the locus is intronic or not.
- Input File: Name of the input file from which the data was extracted.
