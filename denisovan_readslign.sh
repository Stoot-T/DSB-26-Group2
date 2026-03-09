#!/bin/bash

#SBATCH --job-name=read_mapping_denisovan      #Name of job
#SBATCH --time=36:00:00                        #Max. runtime (36 hours)
#SBATCH --mem=36G                              #Total memory requested
#SBATCH --cpus-per-task=8                      # Number of CPU cores
#SBATCH -o /gpfs/home/dus21jwu/scratch/DSB-26-Group2/Output_Messages/download_%j.out      #-o flag captures everything printed to standard .out file %j is a slurm variable that replaces job name with id  helpful to troubleshooting code
#SBATCH -e /gpfs/home/dus21jwu/scratch/DSB-26-Group2/Error_Messages/download_%j.err       #-e  captures error messages and saves them to a .err file
#SBATCH --mail-type=ALL                        #Receive emails when the job starts, ends or fails 
#SBATCH --mail-user=dus21jwu@uea.ac.uk


#reanme sbatch it has a typo
#this script needs proofreading to remove my extra comments, spellchecking and ensuring comment format is consistent
#script also needs to run completely to ensure it functions correctly
#final script  could have a generic email-  this will avoid me being emailed when they test it lol
#can someone else test the email part as it doesn't work for me
#should we make it all snake case
#remove these comments for final commit

# Required Output Directories:
# - /DSB-26-Group2/
# - /Output_Messages
# - /Error_Messages
# - /mapped_sam
# - /mapped_bam
# - /sorted_files
# - /txt_output

# Load required modules for sequence alignment and analysis of sex chromosome karyotype
module load  bwa/0.7.19
module load  samtools/1.21

# Bash scriptmode: forces script to exit immediately on error to help troubleshooting
# -e= exit immidietely if command fails
# -u= treat undefined variables as errors
# -o pipefail= if any command in the pipe fails the whole pipe will fail
set -euo pipefail

# Defining variables containing paths to file locations for raw data, samtools outputs and a final .txt summary of samtools coverage
rawdata="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/data/raw"
reference="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/data/reference"
mappedsam="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/mapped_sam"
mappedbam="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/mapped_bam"
sortedfiles="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/sorted_files"
txtout="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/txt_output"

# Create directories if they do not already exist
# -p specifies the absolute file path using the variables created to ensure directories created in correct location D
mkdir -p "$rawdata"
mkdir -p "$reference"
mkdir -p "$mappedsam"
mkdir -p "$mappedbam"
mkdir -p "$sortedfiles"
mkdir -p "$txtout"
echo "Created/checked output directories"

# Download zip files into rawdata directory for our four chosen paired-end read files
# -nc prevents redownloading existing files (no clobber)
# -P tells the script to download files in the rawdata directory
echo "Starting FASTQ downloads..."
for id in ERR145618 ERR145620 ERR145622 ERR145624; do
    wget -nc -P "$rawdata" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR145/${id}/${id}_1.fastq.gz
    wget -nc -P "$rawdata" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR145/${id}/${id}_2.fastq.gz
done
echo "FASTQ download step complete"

# Download the human reference genome (GRCh38) from Ensembl
echo "Downloading human reference genome..."
# -nc prevents redownloading existing files (no clobber)
# -P tells the script to download files in the reference directory
wget -nc -P "$reference" https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

# Decompress the reference genome
# -k tells gunzip to retain the original zip file
# -f forces overwrite of existing file to prevent error causing the job to terminate
echo "Decompressing reference genome..."
gunzip -kf "${reference}/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"

# Index the reference genome with BWA (required before alignment)
# This creates several index files used by bwa mem during alignment
echo "Indexing reference genome..."
bwa index "${reference}/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

echo "Reference genome ready"


# Sample analysis
echo "Starting alignment and BAM processing..."
for id in ERR145618 ERR145620 ERR145622 ERR145624; do
# Align paired-end reads to the human reference genome using BWA-MEM
    bwa mem "${reference}/Homo_sapiens.GRCh38.dna.primary_assembly.fa" "${rawdata}/${id}_1.fastq.gz" "${rawdata}/${id}_2.fastq.gz" > "${mappedsam}/${id}.sam"

# Convert SAM to BAM
# -b= output in BAM format (binary) rather than SAM (text)
    samtools view -b "${mappedsam}/${id}.sam" > "${mappedbam}/${id}.bam"

# Sort BAM file by genomic coordinates using 4 threads
# -@ 4= specifices 4 additional threads
# -o= specifies output file name
    samtools sort -@ 4 -o "${sortedfiles}/${id}.sorted.bam" "${mappedbam}/${id}.bam"

# Index sorted BAM for fast random access
    samtools index "${sortedfiles}/${id}.sorted.bam"

# Generate alignment statistics (mapped, unmapped, duplicates, etc.)
    samtools flagstat "${sortedfiles}/${id}.sorted.bam" > "${txtout}/${id}_flagstat.txt"

# Compute per‑contig coverage, sort by coverage column (7th), and format output
# -k7= sorts by coverage column
# -r= sort in descending order
# -t= tabular output format
    samtools coverage "${sortedfiles}/${id}.sorted.bam" | sort -k7r | column -t > "${txtout}/${id}_coverage.txt"
done

echo "All samples processed successfully"
