# Read-mapping | DSB-26-Group2 Project

This repository documents the read-mapping scripts used to determine the biological sex of  the mysterious Denisovan population. The genomic sequence in this project was downloaded from the European Nucleotide Archive (ENA) under Project PRJEB3092.

*`Source: https://www.ebi.ac.uk/ena/browser/view/ERP001519`*

---


## Objectives

- Download datasets of Illumina genome sequencing reads from bone fragment  of the Denisovan individual (26 datasets in total.)

- Apply reference-based read-mapping technique to identify the sex
chromosome karyotype in the dataset.

- Run batch scripts to automatically replicate the same set of commands for every dataset in
turn.

---

## Background

This project uses paired-end Illumina short-read data from a Denisovan individual. The dataset represents a high-coverage ancient genome sequence, but the biological sex of the sampled individual is not provided in the metadata.

To address this, reads are aligned to the human reference genome (GRCh38) using a reference-based mapping technique. After alignment, per-chromosome coverage is calculated from the sorted BAM files.

*The used reference genome is at //gpfs/data/BIO-DSB/Session4/ref/human-ref-GRCh38.fasta.*

---

## Workflow
Step 0. [Repo Fork & Clone](#step-0-fork-this-dsb-26-group2-repo-to-your-own-github-account-and-clone-your-forked-copy-to-somewhere-on-your-local-machine-use-ssh-link-when-cloning-via-ssh-key-use-https-when-cloning-via-access-token)

Step 1. [HPC Login](#step-1-log-into-the-hpc-start-an-interactive-slurm-session)

Step 2. [Create required directories](#step-2-create-required-directories-on-hpc)

Step 3. [Copy sbatch script to HPC](#step-3-copy-the-sbatch-script-from-local-to-hpc-workspace)

Step 4. [Adjust script on HPC](#step-4-adjust-the-script-on-the-hpc-workspace)

Step 5. [Run sbatch and monitor job](#step-5-run-the-batch-script-to-study-the-coverage-of-the-sex-karyotype-on-hpc)

Step 6. [Determine biological sex from coverage](#step-6-identify-biological-sex-from-coverage-files-and-conclusion)

Step 7. [Optional plotting in R](#step-7-optional---plotting-the-output-in-r-programming-langugue)

---
### Step 0. Fork this DSB-26-Group2 repo to your own GitHub account and Clone your forked copy to somewhere on your local machine

```bash
cd <where_you_want_it>
git clone git@github.com:<your-username>/DSB-26-Group2.git
cd DSB-26-Group2
```
*Replace <your-username> with your GitHub username.*

### Step 1.  Log into the HPC, start an interactive Slurm session
The whole process takes place on the UEA HPC server. Log onto the HPC as followed:

```bash
ssh <abc12xyz>@hali.uea.ac.uk
interactive-bio-ds
```
*Replace `abc12xyz` with your UEA username.*

### Step 2. Create required directories on HPC
Create the required directories in your HPC scratchh workspace **before** running the job script:

```bash
cd ~/scratch
mkdir -p DSB-26-Group2/Output_Messages
mkdir -p DSB-26-Group2/Error_Messages
mkdir -p DSB-26-Group2/Output/Raw
mkdir -p DSB-26-Group2/Output/Reference
```

### Step 3. Copy the sbatch script from local to HPC workspace
Copy the download_denisovan_cp script downloaded in Step 0 from local to the HPC workspace:

```bash
cd /<where_you_want_them/> 
pwd # Print current working location
# `scp` is secure copy protocol, and allows you to `cp` between HPC and local workspaces:
scp download_denisovan_cp.sh abc12xyz@hali.uea.ac.uk:~/<where_you_want_them>
# Enter your UEA HPC password when prompted and Wait for download to complete before closing the shell.
```
*Run this on your laptop, not on hali*
*Use `~/scratch/DSB-26-Group2` as the recommended location so the script runs without requiring path changes.*


### Step 4. Adjust the script on the HPC workspace
Update fields in the script (for example: paths, email, and job name).

```bash
cd ~/scratch/DSB-26-Group2
nano download_denisovan_cp.sh
```
- - **Save** your changes to the download_denisovan_cp.sh script using `Ctrl+X`


### Step 5. Run the batch script to study the coverage of the sex karyotype on HPC:

```bash
cd /<where_you_put_the_script/>
sbatch download_denisovan_cp.sh
squeue -u <abc12xyz>          # watch your job
```
*Replace `abc12xyz` with your UEA username.*

### Step 6. Identify biological sex from coverage files and Conclusion

After the job finishes, your coverage outputs are in:
```bash
~/scratch/DSB-26-Group2/Output/*_coverage.txt
```
Based on the coverage output, make a conclusion about the Denisovan sex:
*Biological females have two X chromosomes (XX karyotype), while biological males have one X and one Y chromosome (XY karyotype). 
- If coverage on chromosome X is close to autosomal coverage and coverage on chromosome Y is near zero, the sample is likely XX; 
- If coverage on chromosome X is about half of autosomal coverage and chromosome Y has clear non-zero coverage, the sample is likely XY.*

### Step 7. Optional - Plotting the output in R programming langugue
Scipt:

Data: Output from step 5.

Output: Figure of the distribution of coverage per sex chromosome karyotype.

---

## Contact & Questions
For questions about this project, contact:

**Stuart Thompson** - School of Biological Sciences  
University of East Anglia  
Stuart.Thompson@uea.ac.uk
