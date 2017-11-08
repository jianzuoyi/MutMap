#! /bin/sh		
		
# ==================================================		
# Those keys enable users to customize this script		
# ==================================================		
BULK_NAME=""		
		
MISs=""		
DEPTHs=""		
		
MODE=""		
INDIVIDUALS=""		
NUM_OF_TRIALS=""		
CUTOFF=""		
PREVIOUS_PATH=""		

QVAL=""		
PVAL=""		
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
		
if [ -z ${MODE} ]; then		
	MODE=`Set_CONFINTRVL_CALC_MODE`	
fi		
		
if [ -z ${INDIVIDUALS} ]; then		
	INDIVIDUALS=`Set_CONFINTRVL_INDIVIDUALS`	
fi		
		
if [ -z ${NUM_OF_TRIALS} ]; then		
	NUM_OF_TRIALS=`Set_CONFINTRVL_NUM_OF_TRIALS`	
fi		
		
if [ -z ${CUTOFF} ]; then		
	CUTOFF=`Set_CONFINTRVL_CUTOFF`	
fi		
		
if [ -z ${PREVIOUS_PATH} ]; then		
	PREVIOUS_PATH=`Set_CONFINTRVL_PREVIOUS_PATH`	
fi		
	
# ==================================================		
# environment		
# ==================================================		
TOPPATH_SCRIPTS=""		
TOPPATH_COVAL=""		
		
if [ -z ${TOPPATH_SCRIPTS} ]; then		
	TOPPATH_SCRIPTS=`Set_TOPPATH_SCRIPTS`	
fi		
		
if [ -z ${TOPPATH_COVAL} ]; then		
	TOPPATH_COVAL=`Set_TOPPATH_COVAL`	
fi		
		
# ==================================================		
NAME="${BULK_NAME}"		
QNAME="${NAME}_q${QVAL}p${PVAL}_filtered"		
	
SRCPATH="70.awk_custom"		
OUTPATH="80.cbind_confidence_interval"		
	
CMD1="Rscript"		
CMD1="${CMD1} ${TOPPATH_SCRIPTS}/3./MutMap_simulation_6.R"		
if [ ${MODE} -eq 1 ]; then		
	echo "${CMD1} ${INDIVIDUALS} ${NUM_OF_TRIALS} ${CUTOFF}"	
	eval "${CMD1} ${INDIVIDUALS} ${NUM_OF_TRIALS} ${CUTOFF}"	
	PREVIOUS_PATH="."	
fi		
	
CMD2="${TOPPATH_SCRIPTS}/3./cbind_simulated_pvalue_to_pileup.pl"		
CMD2="${CMD2} ${PREVIOUS_PATH}/${INDIVIDUALS}individuals.txt"		
	
for mis in ${MISs}		
do		
	DESTPATH="${OUTPATH}/mut_index_${mis}"	
	echo "mkdir -p ${DESTPATH}"	
	eval "mkdir -p ${DESTPATH}"	
	
	for dep in ${DEPTHs}	
	do	
		INPILEUP="${SRCPATH}/mut_index_${mis}/${QNAME}_cov${mis}_co${dep}.txt"
		OUTPILEUP="${DESTPATH}/${QNAME}_pvalue_cov${mis}_co${dep}.txt"
		
		echo "${CMD2} ${INPILEUP} ${OUTPILEUP}"
		eval "${CMD2} ${INPILEUP} ${OUTPILEUP}"
		
	done	
done
