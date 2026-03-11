#!/bin/bash
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

#module load
module load  bwa/0.7.19
module load  samtools/1.21

# Stop on errors
set -euo pipefail

rawdata="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/data/raw"
reference="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/data/reference"
mappedsam="/gpfs/home/dus21jwu/scratch/DSB-26-Group2/mapped_sam_and_bam"

# Create directories if they don't exist
mkdir -p "$rawdata"
mkdir -p "$reference"
mkdir -p "$mappedsam"

# Download FASTQ files into rawdata directory
for id in ERR145618 ERR145620 ERR145622 ERR145624; do
    wget -nc -P "$rawdata" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR145/${id}/${id}_1.fastq.gz
    wget -nc -P "$rawdata" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR145/${id}/${id}_2.fastq.gz
done

for id in ERR145618 ERR145620 ERR145622 ERR145624; do
#align reads to reference
    bwa mem "/gpfs/data/BIO-DSB/Session4/ref/human-ref-GRCh38.fasta" "${rawdata}/${id}_1.fastq.gz" "${rawdata}/${id}_2.fastq.gz" > "${mappedsam}/${id}.sam"
#convert SAM to BAM
    samtools view -b "${mappedsam}/${id}.sam" > "${mappedsam}/${id}.bam"
#sort BAM
    samtools sort -@ 4 -o "${mappedsam}/${id}.sorted.bam" "${mappedsam}/${id}.bam"
#index BAM
    samtools index "${mappedsam}/${id}.sorted.bam"
#extract mapping statistics
    samtools flagstat "${mappedsam}/${id}.sorted.bam"
#coverage and sex karyotype determination
    samtools coverage "${mappedsam}/${id}.sorted.bam" | sort -k7r | column -t > "${mappedsam}/${id}_coverage.txt"
done
