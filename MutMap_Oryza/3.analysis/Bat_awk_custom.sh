#! /bin/sh		
		
# ==================================================		
# Those keys enable users to customize this script		
# ==================================================		
BULK_NAME=""		
MISs=""		

DEPTHs=""		
QVAL=""		
PVAL=""		
	
# --------------------------------------------------		
	
MIN_CONSENSUS_QUALITY=""		
MIN_SNP_INDEX=""		
	
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
#--		
		
if [ -z ${MISs} ]; then		
	MISs=`Set_MISs`	
fi		
		
if [ -z ${DEPTHs} ]; then		
	DEPTHs=`Set_DEPTHs`	
fi		
		
if [ -z ${MIN_CONSENSUS_QUALITY} ]; then		
	MIN_CONSENSUS_QUALITY=`Set_MIN_CONSENSUS_QUALITY`	
fi		
		
if [ -z ${MIN_SNP_INDEX} ]; then		
	MIN_SNP_INDEX=`Set_MIN_SNP_INDEX`	
fi		
		
# ==================================================		
NAME="${BULK_NAME}"		
QNAME="${NAME}_q${QVAL}p${PVAL}"		
	
SRCPATH="60.awk_depth"		
OUTPATH="70.awk_custom"		
	
CMD0="cat"		
CMD1="awk '\$5 >= ${MIN_CONSENSUS_QUALITY}'"		
CMD2="awk '\$9 >= ${MIN_SNP_INDEX}'"		

for mis in ${MISs}		
do		
		
		
		
	DESTPATH="mut_index_${mis}"	
	echo "mkdir -p ${OUTPATH}/${DESTPATH}"	
	eval "mkdir -p ${OUTPATH}/${DESTPATH}"	
		
	for dep in ${DEPTHs}	
	do	
		INPILEUP="${SRCPATH}/mut_index_${mis}/${QNAME}_cov${mis}_co${dep}.txt"
		OUTPILEUP="${OUTPATH}/${DESTPATH}/${QNAME}_filtered_cov${mis}_co${dep}.txt"
		echo "${CMD0} ${INPILEUP} | ${CMD1} | ${CMD2} > ${OUTPILEUP}"
		eval "${CMD0} ${INPILEUP} | ${CMD1} | ${CMD2} > ${OUTPILEUP}"
		
	done	
done
