#PBS -l walltime=18:00:00,nodes=1:ppn=6,mem=40gb
#PBS -o /scratch.global/sna/errors/st_o
#PBS -e /scratch.global/sna/errors/st_e
#PBS -V
#PBS -N st
#PBS -r n
#PBS -m abe

# qsub -t 2,3,4,14,15,16 -v LIST=imprint_samples.txt   /home/springer/sna/scripts/shell/imprint_concat_BW.sh

cd /home/springer/sna/te_expression/imprinting

SAMPLE="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 1)"
DIRECTORY="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 4)"
FILE="$(/bin/sed -n ${PBS_ARRAYID}p ${LIST} | cut -f 5)"

cd /scratch.global/sna/expression

module load cutadapt/1.8.1
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT -f fastq -m 30 -q 10 --quality-base=33 -o ${SAMPLE}1.trimmed.fastq -p ${SAMPLE}2.trimmed.fastq  ${DIRECTORY}/${FILE}_R1_001.fastq.gz ${DIRECTORY}/${FILE}_R2_001.fastq.gz

module load bowtie2/2.2.4
module load tophat/2.0.13
module load hisat2/2.1.0

hisat2 -p 6 -k 20  -S /scratch.global/sna/expression/${SAMPLE}.sam -x /scratch.global/sna/intermediate/concatenated_B73_W22.all -1 ${SAMPLE}1.trimmed.fastq -2 ${SAMPLE}2.trimmed.fastq

module load samtools/1.9
module load bamtools/20120608
module load python/3.6.3
module load htseq/0.5.3

python -m HTSeq.scripts.count -s no -t all -i ID -m union -a 0 -o ${SAMPLE}.edited2.sam /scratch.global/sna/expression/${SAMPLE}.sam /scratch.global/sna/intermediate/concatenated_B73_W22chr_filteredTE.subtractexon.plusgenes.chr.sort.gff3 > counts_${SAMPLE}_to_BW_concat.txt

# To view B73 alignments on IGV
grep -v chr ${SAMPLE}.sam | samtools view -S -b - > ${SAMPLE}_b73.bam

samtools sort ${SAMPLE}_b73.bam -o ${SAMPLE}_b73.sorted.bam

samtools index ${SAMPLE}_b73.sorted.bam

