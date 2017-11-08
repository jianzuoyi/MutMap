#! /bin/sh	
	
# ==================================================	
# Those keys enable users to customize this script	
# ==================================================	
REF=""	
BULK_NAME=""	
	
MIS_MATCH_DEFAULT=""	
DONTREALIGN=""	
QVAL=""	
PVAL=""	
# --------------------------------------------------	
# load common functions	
. ../0.common/common.fnc	
# --------------------------------------------------	
	
if [ -z ${REF} ]; then	
	REF=`Set_REF_FASTA`
fi	
	
if [ -z ${BULK_NAME} ]; then	
	BULK_NAME=`Set_BULK_NAME`
fi	
	
if [ -z ${QVAL} ]; then	
	QVAL=`Set_READ_QVAL`
fi	
	
if [ -z ${PVAL} ]; then	
	PVAL=`Set_READ_PVAL`
fi	

if [ -z ${MIS_MATCH_DEFAULT} ]; then	
	MIS_MATCH_DEFAULT=`Set_MIS_MATCH_DEFAULT`
fi	
	
if [ -z ${DONTREALIGN} ]; then	
	DONTREALIGN=`Set_DONTREALIGN`
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
	
if [ -z $1 ];then	
	MIS_MATCH=${MIS_MATCH_DEFAULT}
else	
	MIS_MATCH=$1
fi	
	
	
Command=`basename $0`	
Logf="log.${Command}.${MIS_MATCH}.txt"	
	
# --------------------------------------------------	
QNAME="${NAME}_q${QVAL}p${PVAL}"	
INPATH="10.bwa2bam/${NAME}"	
INBAM="${INPATH}/${QNAME}_MSR.bam"	
	
OUTPATH="20.coval_refine"	
OUTPREF=`basename ${INBAM} .bam`	
OUTPREF="${OUTPATH}/${OUTPREF}_Cov_${MIS_MATCH}_S"	
	
OPTION=""	
OPTION="${OPTION} -ref ${REF}"	
OPTION="${OPTION} -pref ${OUTPREF}"	
OPTION="${OPTION} -n ${MIS_MATCH}" 	
OPTION="${OPTION} ${DONTREALIGN}"	
	
CMD="${TOPPATH_COVAL}/coval refine"	
CMD="${CMD} ${OPTION} ${INBAM}"	
	
# start=`stop_watch.pl start`	
	
echo "${CMD}"	
${CMD} 2>&1 | tee -a ${OUTPATH}/$Logf	
	
# stop_watch.pl $start	