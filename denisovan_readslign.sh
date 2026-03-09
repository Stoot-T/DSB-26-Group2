#!/bin/bash

#SBATCH -p bio-ds
#SBATCH --qos=bio-ds
#simple code is better- are these necessary?

#SBATCH --job-name=read_mapping_denisovan
#SBATCH --time=36:00:00
#SBATCH --mem=36G
#SBATCH --cpus-per-task=8
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

# Load required modules
module load  bwa/0.7.19
module load  samtools/1.21

# Bash scriptmode: forces script to fail immediately and explicitly when error occurs in script
set -euo pipefail

# Defining variables contining paths to file locations
rawdata="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/data/raw"
reference="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/data/reference"
mappedsam="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/mapped_sam"
mappedbam="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/mapped_bam"
sortedfiles="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/sorted_files"
txtout="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/txt_output"

# Create directories if they don't exist
mkdir -p "$rawdata"
mkdir -p "$reference"
mkdir -p "$mappedsam"
mkdir -p "$mappedbam"
mkdir -p "$sortedfiles"
mkdir -p "$txtout"
echo "Created/checked output directories"

# Download zip files into rawdata directory
echo "Starting FASTQ downloads..."
for id in ERR145618 ERR145620 ERR145622 ERR145624; do
    wget -nc -P "$rawdata" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR145/${id}/${id}_1.fastq.gz
    wget -nc -P "$rawdata" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR145/${id}/${id}_2.fastq.gz
done
echo "FASTQ download step complete"

echo "Starting alignment and BAM processing..."
for id in ERR145618 ERR145620 ERR145622 ERR145624; do
#align reads to reference
    bwa mem "/gpfs/data/BIO-DSB/Session4/ref/human-ref-GRCh38.fasta" "${rawdata}/${id}_1.fastq.gz" "${rawdata}/${id}_2.fastq.gz" > "${mappedsam}/${id}.sam"
#convert SAM to BAM
    samtools view -b "${mappedsam}/${id}.sam" > "${mappedbam}/${id}.bam"
#sort BAM
    samtools sort -@ 4 -o "${sortedfiles}/${id}.sorted.bam" "${mappedbam}/${id}.bam"
#index BAM
    samtools index "${sortedfiles}/${id}.sorted.bam"
#extract mapping statistics
    samtools flagstat "${sortedfiles}/${id}.sorted.bam"
#coverage and sex karyotype determination
    samtools coverage "${sortedfiles}/${id}.sorted.bam" | sort -k7r | column -t > "${txtout}/${id}_coverage.txt"
done

echo "All samples processed successfully. Outputs are in: $OUTPUT_DIR"
