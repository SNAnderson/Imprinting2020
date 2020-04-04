#PBS -l walltime=8:00:00,nodes=1:ppn=1,mem=40gb
#PBS -o /scratch.global/sna/errors/concat3_o
#PBS -e /scratch.global/sna/errors/concat3_e
#PBS -V
#PBS -N concat3
#PBS -r n
#PBS -m abe

# qsub /home/springer/sna/scripts/shell/concat_3pairs.sh

module load samtools/1.9
cd /scratch.global/sna/intermediate/

# B73 and W22

cat /home/maize/shared/databases/genomes/Zea_mays/B73/Zea_mays.AGPv4.dna.toplevel.fa /home/maize/shared/databases/genomes/Zea_mays/W22/W22__Ver12.genome.normalized.fasta > concatenated_B73_W22.all.fa

sed 's/^/chr/' ~/W22/W22.structuralTEv2.10.08.2018.filteredTE.subtractexon.plusgenes.chr.sort.gff3 | cat ~/B73/B73.structuralTEv2.1.07.2019.filteredTE.subtractexon.plusgenes.chr.sort.gff3 - > concatenated_B73_W22chr_filteredTE.subtractexon.plusgenes.chr.sort.gff3

module load hisat2/2.1.0
hisat2-build concatenated_B73_W22.all.fa concatenated_B73_W22.all

# B73 and PH207
cd /scratch.global/sna/expression/

cat ~/PH207/ZmaysPH207_443_v1.0.fa /home/maize/shared/databases/genomes/Zea_mays/B73/Zea_mays.AGPv4.dna.toplevel.fa  > concatenated_B73_PH207.all.fa

cat ~/PH207/PH207.structuralTEv2.10.08.2018.filteredTE.subtractexon.plusgenes.chr.sort.gff3 ~/B73/B73.structuralTEv2.1.07.2019.filteredTE.subtractexon.plusgenes.chr.sort.gff3 > concatenated_B73_PH207chr_filteredTE.subtractexon.plusgenes.chr.sort.gff3

hisat2-build concatenated_B73_PH207.all.fa concatenated_B73_PH207.all


# W22 and PH207

cd /scratch.global/sna/expression/

cp /home/maize/shared/databases/genomes/Zea_mays/W22/W22__Ver12.genome.normalized.fasta .

sed 's/chr//' W22__Ver12.genome.normalized.fasta > W22__Ver12.genome.normalized.edited.fasta

cat W22__Ver12.genome.normalized.edited.fasta ~/PH207/ZmaysPH207_443_v1.0.fa  > concatenated_W22_PH207.all.fa

cat ~/W22/W22.structuralTEv2.10.08.2018.filteredTE.subtractexon.plusgenes.chr.sort.gff3 ~/PH207/PH207.structuralTEv2.10.08.2018.filteredTE.subtractexon.plusgenes.chr.sort.gff3  > concatenated_W22_PH207chr_filteredTE.subtractexon.plusgenes.chr.sort.gff3

hisat2-build concatenated_W22_PH207.all.fa concatenated_W22_PH207.all

