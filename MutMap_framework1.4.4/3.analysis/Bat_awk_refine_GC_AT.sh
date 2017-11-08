#! /bin/sh	
	
# ==================================================	
# Those keys enable users to customize this script	
# ==================================================	
BULK_NAME=""	
MISs=""
QVAL=""	
PVAL=""	
# ==================================================	
# --------------------------------------------------	
# load common functions	
. ../0.common/common.fnc	
	
# --------------------------------------------------	
	
if [ -z ${BULK_NAME} ]; then	
	BULK_NAME=`Set_BULK_NAME`
fi	
	
if [ -z ${QVAL} ]; then	
	QVAL=`Set_READ_QVAL`
fi	
	
if [ -z ${PVAL} ]; then	
	PVAL=`Set_READ_PVAL`
fi	
	
if [ -z ${MISs} ]; then	
	MISs=`Set_MISs`
fi	

NAME="${BULK_NAME}"	
QNAME="${NAME}_q${QVAL}p${PVAL}"	
# ==================================================	
SRCPATH="40.exclude_common_snps"	
INNAMEHEAD="${SRCPATH}/${QNAME}_MSR_Cov"	
INNAMETAIL="S-snp-rmc2snp.pileup"	
	
OUTPATH="50.awk_GC_AT"	
	
CMD0="cat"	
CMD1="awk '(\$3~/[Gg]/ && \$4~/[AaRr]/) || (\$3~/[Cc]/ && \$4~/[TtYy]/)'"	
	
for mis in ${MISs}	
do	
	INPILEUP="${INNAMEHEAD}_${mis}_${INNAMETAIL}"
	OUTPILEUP=`basename ${INPILEUP} .pileup`
	OUTPILEUP="${OUTPATH}/${OUTPILEUP}_GC2AT.pileup"
	
	echo "${CMD0} ${INPILEUP} | ${CMD1} > ${OUTPILEUP}"
	eval "${CMD0} ${INPILEUP} | ${CMD1} > ${OUTPILEUP}"
done
