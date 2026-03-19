# Read-mapping | DSB-26-Group2 Project

This repository documents the read-mapping workflow used to identify the biological sex of a Denisovan individual. The sequencing data for this project were downloaded from the European Nucleotide Archive (ENA) under project PRJEB3092.

*`Source
Human Reference: Homo sapiens GRCh38
Denisovan Sequencing Reads: https://www.ebi.ac.uk/ena/browser/view/ERP001519`*

---


## Objectives

- Write a reproducible SLURM-based bash script to process Denisovan paired-end sequencing reads on the UEA HPC system.

- Download and manage raw FASTQ files and the reference genome from trusted public repositories (ENA and Ensembl).

- Apply a reference-based read-mapping approach to identify the sex chromosome karyotype of the sample.
	- Align the Denisovan reads to the human GRCh38 genome using `bwa mem`.
	- Convert SAM to BAM, then sort and index alignment outputs using `samtools` for efficient downstream analysis.
	- Generate per-sample mapping quality and coverage summaries (`flagstat` and `coverage` reports).

- Compare chromosome X and Y coverage against autosomal coverage to infer likely biological sex (XX vs XY karyotype).

- Visualise chromosome coverage patterns in R for better result interpretation.

---

## Background

This project uses paired-end Illumina short-read data from a Denisovan individual. The DNA was recovered from a finger bone found in Denisova Cave in southern Siberia, and the sequencing data was downloaded from the European Nucleotide Archive (ENA) under project PRJEB3092.

The dataset is reported to be the first high-coverage (30x) Denisovan genome sequence, but the biological sex of the sampled individual is not provided in the metadata. To address this, the project uses a reference-based mapping approach to determine the sex chromosome karyotype of the sample.

Although 26 samples are available on the ENA website, this project focuses on 4 paired-end sequencing datasets: ERR145618, ERR145620, ERR145622, and ERR145624. These are used to infer the biological sex of the Denisovan individual and to check whether the result is consistent across samples.

The workflow is designed to run on the UEA HPC system using a Slurm batch script, because the analysis is too computationally intensive to run reliably in an interactive session.

The results are written to tab-delimited coverage files and are visualised graphically in RStudio.

---

## Workflow
Step 0. [Repo Fork & Clone](#step-0-fork-this-dsb-26-group2-repo-to-your-own-github-account-and-clone-your-forked-copy-to-somewhere-on-your-local-machine-use-ssh-link-when-cloning-via-ssh-key-use-https-when-cloning-via-access-token)

Step 1. [HPC Login](#step-1-log-into-the-uea-hpc)

Step 2. [Create required directories](#step-2-create-required-directories-on-hpc)

Step 3. [Copy sbatch script to HPC](#step-3-copy-the-sbatch-script-from-local-to-hpc-workspace)

Step 4. [Adjust script on HPC](#step-4-adjust-the-script-on-the-hpc-workspace)

Step 5. [Run sbatch and monitor job](#step-5-run-the-batch-script-to-study-the-coverage-of-the-sex-karyotype-on-hpc)

Step 6. [Determine biological sex from coverage](#step-6-identify-biological-sex-from-coverage-files-and-conclude)

Step 7. [Optional plotting in R](#step-7-optional---plotting-the-output-in-r-programming-language)

---
### Step 0. Fork this DSB-26-Group2 repo to your own GitHub account and Clone your forked copy to somewhere on your local machine

```bash
cd <where_you_want_it>
git clone git@github.com:<your-username>/DSB-26-Group2.git
cd DSB-26-Group2
```
*Replace `<your-username>` with your GitHub username.*

### Step 1.  Log into the UEA HPC
The whole process takes place on the UEA HPC server. Log into the HPC as follows:

```bash
# Connect to the UEA HPC login node via SSH (Secure Shell)
ssh <abc12xyz>@hali.uea.ac.uk
# Enter your UEA password when prompted
# Note: if working off-campus on a personal laptop, connect to GlobalProtect VPN first

#Start an interactive job with bioinformatics resources available. 
#Do NOT run computationally intensive commands on the login node
interactive-bio-ds
```
*Replace `abc12xyz` with your UEA username.*



### Step 2. Create required directories on HPC
Create the required directories in your HPC scratch workspace before running the job script:
Optional: only required if not establishing GitHub repository onto the HPC
```bash
# Move into your HPC scratch workspace
cd ~/scratch

# Create the project directory
# -p creates parent directories as needed and does not error if the directory already exists
mkdir -p DSB-26-Group2
```

### Step 3. Copy the sbatch script from local to HPC workspace
Copy the `denisovan_readalignment.sh` script downloaded in Step 0 from your local machine to the HPC workspace. Use `~/scratch/DSB-26-Group2` as the recommended location so the script runs without requiring path changes.

```bash
# Move into your local folder containing denisovan_readalignment.sh
cd /<where_you_have_the_script/>

# scp (Secure Copy Protocol) transfers files between your local machine and the HPC over SSH
# Replace abc12xyz with your UEA username
scp denisovan_readalignment.sh abc12xyz@hali.uea.ac.uk:~/scratch/DSB-26-Group2
# Enter your UEA HPC password when prompted
# Wait for the transfer to complete before closing the terminal
```
*Run this on your local terminal, not on hali*

### Alternatively, on the HPC:

If the GitHub repository has already been established then the denisovan_readalignment.sh file should already be accessible to run on the HPC. To ensure the sbatch file is present, move into the correct directory and run git pull:

```bash
# Move into your local folder containing denisovan_readalignment.sh
cd /DSB-26-Group2
#git pull to pull any changes from the GitHub branch into the HPC directory 
git pull origin main
```

### Step 4. Adjust the script on the HPC workspace
Update fields in the script (for example: username and job name).

```bash
# Move into your project directory on the HPC
cd ~/scratch/DSB-26-Group2

# Open the script in the nano text editor
# Fields to update: file paths (replace USER with your HPC username), email address
nano denisovan_readalignment.sh

# To save and exit nano:
# Press Ctrl+X, then Y to confirm saving, then Enter to keep the filename
```

### Step 5. Run the batch script to study the coverage of the sex karyotype on HPC:

```bash
# Submit the script to the Slurm job scheduler
# Slurm will queue the job and run it when resources are available
sbatch denisovan_readalignment.sh

# Check the status of your submitted job:
squeue -u <abc12xyz>
# Replace abc12xyz with your UEA username

# Alternatively, view detailed accounting info for a specific job after it finishes
sacct -j <job_number>
# Replace <job_number> with the job ID printed when you ran sbatch
```
The job may take more than 24 hours to complete. Once finished, your mapping statistics (`flagstat`) and coverage files for each of the four samples will be in the `txt_output` directory. If the job fails, check the error log in `~/scratch/DSB-26-Group2/error_messages/` for details.

### Step 6. Identify biological sex from coverage files and Conclude

After the job finishes, your coverage outputs are in:
```bash
# Move into your output directory
cd ~/scratch/DSB-26-Group2/txt_output/
```
Based on the `samtools coverage` output, compare chromosome X and Y mean depth against the autosomes to infer biological sex:
- Biological females have two X chromosomes (XX karyotype), while biological males have one X and one Y chromosome (XY karyotype).
	- If chromosome X coverage is similar to autosomal coverage and chromosome Y coverage is near zero, the sample is likely **XX** (female).
	- If chromosome X coverage is approximately half of autosomal coverage and chromosome Y has clear non-zero coverage, the sample is likely **XY** (male).


### Step 7. Plotting the output in R programming language
# To interpret the results, we use R to compare the sequencing depth of sex chromosomes (X and Y) against the autosomes (1-22).

**Tools**: RStudio (v2026.1+)

**Packages**: ggplot2 4.0.2, dplyr 1.2.0, readr 2.2.0

**Input**: *_coverage.txt files generated in Step 5.

**Script**: `RStudio_Code.txt`

**Data**: Outputs from step 5 or `*_coverage.txt` files in `txt_output` folder.

1. Transfer results to your local machine
Since RStudio is typically run on your personal computer, you first need to download the results from the HPC. Run this command on your local terminal:

```Bash
# Create a local folder for the results
mkdir ~/Desktop/denisovan_results

# Copy the coverage files from HPC to your computer
# Replace abc12xyz with your UEA username
scp abc12xyz@hali.uea.ac.uk:~/scratch/DSB-26-Group2/txt_output/*_coverage.txt ~/Desktop/denisovan_results/
```

Alternatively, to access the .R script using the GitHub repo follow these instructions:

Open RStudio.

Go to File > New Project...

Select Version Control > Git.

In Repository URL, paste your fork's link: https://github.com/<your-username>/DSB-26-Group2.git

Click Create Project.

RStudio will now download the entire repo, including RStudio_Code.R, to your computer.

Open the file from the Files pane (bottom right) and run your analysis.


2. Run the R Script
Open RStudio and follow these steps:

**Set Working Directory:** Go to Session > Set Working Directory > Choose Directory and select your denisovan_results folder.

**Load the Script:** Open RStudio_Code.R (also available in the repo).

**Execute:** Highlight the code and press Ctrl+Enter (Windows) or Cmd+Enter (Mac).

**Output**: Figures summarising sequencing depth across all chromosomes for each ERR sample. The bars represent coverage per chromosome and the overlaid line represents mean depth, allowing quick comparison of X/Y coverage versus autosomes to infer the sex karyotype XX vs XY.

--- 
**Git Troubleshooting:** 
Commands for GitHub are run in the terminal of .RStudio

To verify GitHub is installed, run command:
```Bash
git status

```
`Git` must be installed and available in RStudio to access GitHub from within RStudio.

---

## Contact & Questions
For questions about this project, contact:

**Stuart Thompson** - School of Biological Sciences  
University of East Anglia  
Stuart.Thompson@uea.ac.uk
