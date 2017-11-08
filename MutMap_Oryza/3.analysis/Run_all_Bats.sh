#! /bin/sh	
	
# --------------------------------------------------	
# load common functions	
. ../0.common/common.fnc	
# --------------------------------------------------	
	
	
	
	
	
MISs=`Set_MISs`	
	
	
	
	
	
	
	
	
	
	
	
# ==================================================	
./Bat_make_symbolic_link_of_qualified_fastq.sh	
	
# ==================================================	
./Bat_bwa2bam.sh	
	
# ==================================================	
for mis in ${MISs}	
do	
	./Bat_run_coval-refine-bam.pl.sh ${mis}
	./Bat_run_coval-call-pileup.pl.sh ${mis}
done	
	
# ==================================================	
./Bat_exclude_common_snps.pl.sh	
	
# ==================================================	
./Bat_awk_refine_GC_AT.sh	
	
# ==================================================	
./Bat_awk_depth.sh	
	
# ==================================================	
./Bat_awk_custom.sh	
	
# ==================================================	
./Bat_cbind_confidence_interval.sh	
	
# ==================================================	
./Bat_slidingwindow.sh

