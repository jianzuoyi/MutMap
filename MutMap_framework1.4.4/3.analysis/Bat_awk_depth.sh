#! /bin/sh		
		
# ==================================================		
# Those keys enable users to customize this script		
# ==================================================		
BULK_NAME=""		
		
MISs=""		
DEPTHs=""
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
	
if [ -z ${DEPTHs} ]; then		
	DEPTHs=`Set_DEPTHs`	
fi		

# ==================================================		
NAME="${BULK_NAME}"		
QNAME="${NAME}_q${QVAL}p${PVAL}"
	
SRCPATH="50.awk_GC_AT"		
OUTPATH="60.awk_depth"		
	
INNAMEHEAD="${SRCPATH}/${QNAME}_MSR_Cov"		
INNAMETAIL="S-snp-rmc2snp_GC2AT.pileup"		
	
CMD0="cat"		
CMD1="awk '\$8>=${dep}'"		
CMD2="awk '{print \$1\"\\t\"\$2\"\\t\"\$3\"\\t\"\$4\"\\t\"\$5\"\\t\"\$6\"\\t\"\$7\"\\t\"\$8\"\\t\"\$11\"\\t\"\$9\"\\t\"\$10}'"		
	
for mis in ${MISs}		
do		
	INPILEUP="${INNAMEHEAD}_${mis}_${INNAMETAIL}"	
		
	DESTPATH="mut_index_${mis}"	
	echo "mkdir -p ${OUTPATH}/${DESTPATH}"	
	eval "mkdir -p ${OUTPATH}/${DESTPATH}"	
		
	for dep in ${DEPTHs}	
	do	
		CMD1="awk '\$8>=${dep}'"
		OUTPILEUP="${OUTPATH}/${DESTPATH}/${QNAME}_cov${mis}_co${dep}.txt"
		echo "${CMD0} ${INPILEUP} | ${CMD1} | ${CMD2} > ${OUTPILEUP}"
		eval "${CMD0} ${INPILEUP} | ${CMD1} | ${CMD2} > ${OUTPILEUP}"
		
	done	
done
