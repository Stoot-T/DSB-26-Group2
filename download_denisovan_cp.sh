#!/bin/bash
#SBATCH -p bio-ds
#SBATCH --qos=bio-ds

#SBATCH --job-name=denisovan_readalign
#SBATCH --time=36:00:00
#SBATCH --mem=15G
#SBATCH --cpus-per-task=4
#SBATCH -o /gpfs/home/dus21jwu/scratch/DSB-26-Group2/Output_Messages/download_%j.out
#SBATCH -e /gpfs/home/dus21jwu/scratch/DSB-26-Group2/Error_Messages/download_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dus21jwu@uea.ac.uk

#this sbatch file needs renaming- we should carefully consdier all of our naming conventions
#job names  and other details can definitely be improved
#final script  could have a generic email-  this will avoid me being emailed when they test it lol
#can someone else test the email part as it doesn't work for
#could include further directories for tidier data
#index own reference genome  
#remove these comments for final commit

# Required Output Directories:
# - /DSB-26-Group2/
# - /Output_Messages
# - /Error_Messages


# Load required modules
module load bwa/0.7.19
module load  samtools/1.21

# Stop on errors
set -euo pipefail

# Define input/output directories
OUTPUT_DIR="$HOME/scratch/DSB-26-Group2/Output"
REF_DIR="$OUTPUT_DIR/Reference"
REF_FILE="$REF_DIR/human-ref-GRCh38.fasta"
SOURCE_REF="/gpfs/data/BIO-DSB/Session4/ref/human-ref-GRCh38.fasta"
RAW_DIR="$OUTPUT_DIR/Raw"

# Create directories if they don't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$RAW_DIR"
mkdir -p "$REF_DIR"
echo "Created/checked output directories"

# Check if reference genome file already exists
if [ ! -f "$REF_FILE" ]; then
    cp "$SOURCE_REF" "$REF_FILE"
    echo "Copied reference fasta successfully"
else
    echo "Reference genome file already exists. Skipping copy."
fi

# Ensure BWA index exists for the local reference
if [ ! -f "${REF_FILE}.bwt" ]; then
    echo "BWA index not found. Building index for $REF_FILE"
    bwa index "$REF_FILE"
    echo "BWA index build complete"
else
    echo "BWA index already exists. Skipping indexing."
fi

# Download Raw files into rawdata directory
echo "Starting FASTQ downloads..."
for id in ERR145618 ERR145620 ERR145622 ERR145624; do
    echo "Downloading reads for ${id}"
    wget -nc -P "$RAW_DIR" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR145/${id}/${id}_1.fastq.gz
    wget -nc -P "$RAW_DIR" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR145/${id}/${id}_2.fastq.gz
done
echo "FASTQ download step complete"

echo "Starting alignment and BAM processing..."
for id in ERR145618 ERR145620 ERR145622 ERR145624; do
    echo "Processing sample ${id}"
# Align reads to the reference genome
    bwa mem "$REF_FILE" "${RAW_DIR}/${id}_1.fastq.gz" "${RAW_DIR}/${id}_2.fastq.gz" > "${OUTPUT_DIR}/${id}.sam"
# Convert SAM to BAM format
    samtools view -b "${OUTPUT_DIR}/${id}.sam" > "${OUTPUT_DIR}/${id}.bam"
# Sort the BAM file
    samtools sort -@ 4 -o "${OUTPUT_DIR}/${id}.sorted.bam" "${OUTPUT_DIR}/${id}.bam"
# Index the sorted BAM file
    samtools index "${OUTPUT_DIR}/${id}.sorted.bam"
# Extract mapping statistics
    samtools flagstat "${OUTPUT_DIR}/${id}.sorted.bam"
# Study coverage and Determine sex karyotype 
    samtools coverage "${OUTPUT_DIR}/${id}.sorted.bam" | sort -k7r | column -t > "${OUTPUT_DIR}/${id}_coverage.txt"
    echo "Completed sample ${id}"
done

echo "All samples processed successfully. Outputs are in: $OUTPUT_DIR"
