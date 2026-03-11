sbatch -J wget --time=360 --mem=4G -o out_wget.ERR%j.o -e out_wget.ERR%j.e --wrap="cut -f6 filereport_read_run_ERP001519.tsv | tr ';' '\n' | grep '.fastq.gz' | sed -n '9,16p' | sed 's|^|ftp://|' | xargs -n1 wget -c"


wget -O filereport_read_run_ERP001519.tsv "https://www.ebi.ac.uk/ena/portal/api/filereport?result=read_run&accession=ERP001519&offset=0&limit=0&format=tsv&fields=run_accession,sample_accession,experiment_accession,tax_id,scientific_name,fastq_ftp,submitted_ftp"
