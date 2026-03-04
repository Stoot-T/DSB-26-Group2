# Read-mapping | DSB-26-Group2 Project

This repository documents the read-mapping scripts used to determine the biological sex of  the mysterious Denisovan population. The genomic sequence in this project was downloaded from the European Nucleotide Archive (ENA) under Project PRJEB3092  

---


## Objectives

- Download datasets of Illumina genome sequencing reads from bone fragment  of the Denisovan individual (26 datasets in total.)

- Apply reference-based read-mapping technique to identify the sex
chromosome karyotype in the dataset.

- Run batch scripts to automatically replicate the same set of commands for every dataset in
turn.

---

## Background

The given datasets is the first high coverage (30X) genome sequence of a Denisovan individual, an extinct relatives of Neandertals. However, the datasets do not specify the biological sex of the individual sampled.

Male and female genomes have distinctive sex chromosomes: XX
karyotype for female and, XY for male.

We will use the read-mapping output to look at the coverage of the X and Y chromosomes and indentify the sex chromosome karyotype of the dataset.

---

## Workflow
Step 0. [Repo Fork & Clone](#step-0-fork-this-dsb-26-group2-repo-to-your-own-github-account-and-clone-your-forked-copy-to-somewhere-on-your-local-machine-use-ssh-link-when-cloning-via-ssh-key-use-https-when-cloning-via-access-token)

Step 1. [Get Genome Sequence](#2-background)

Step 2. []()

---
### Step 0. Fork this DSB-26-Group2 repo to your own GitHub account and Clone your forked copy to somewhere on your local machine (use SSH link when cloning via SSH key, use HTTPS when cloning via Access Token)

```bash
cd <where_you_want_it>
git clone git@github.com:<your-username>/DSB-26-Group2.git
cd DSB-26-Group2
```
*Replace <your-username> with your GitHub username.*

### Step 1. Dowload the FASTQs from the ENA


### Step 2. Download the reference file from the UEA HPC server

### Step 3. Align reads to the reference genome


### Step 4. Convert SAM to BAM format


### Step 5. Sort the BAM file


### Step 6. Index the BAM file


### Step 7. Study coverage across chromosomes


### Step 8.  Determine sex chromosome karyotype


---

## Contact & Questions
For questions about this project, contact:

**Stuart Thompson** - School of Biological Sciences  
University of East Anglia  
Stuart.Thompson@uea.ac.uk
