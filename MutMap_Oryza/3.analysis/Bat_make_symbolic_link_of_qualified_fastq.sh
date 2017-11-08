#! /bin/sh	
	
# ==================================================	
# Those keys enable users to customize this script	
# ==================================================	
BULK_NAME=""	
	
SRC_PATH=""	
	
QVAL=""	
PVAL=""	
# --------------------------------------------------	
# load common functions	
. ../0.common/common.fnc	
# --------------------------------------------------	
if [ -z ${BULK_NAME} ]; then	
	BULK_NAME=`Set_BULK_NAME`
fi	
	
	
	
	
	
if [ -z ${SRC_PATH} ]; then	
	SRC_PATH=`Set_SRC_READ_PATH`
fi	
	
if [ -z ${QVAL} ]; then	
	QVAL=`Set_READ_QVAL`
fi	
	
if [ -z ${PVAL} ]; then	
	PVAL=`Set_READ_PVAL`
fi	
#--	
	
# --------------------------------------------------	
	
NAME="${BULK_NAME}"	
	
OUTPATH="10.bwa2bam"	
SRC_TAIL="*_[0-9]*.RnFq${QVAL}p${PVAL}S.[12].gz"	
FQ_HEAD="p_q${QVAL}p${PVAL}"	
FQ_TAIL="sequence.txt.gz"	
	
echo "mkdir -p ${OUTPATH}/${NAME}"	
eval "mkdir -p ${OUTPATH}/${NAME}"	
	
READs=`ls ${SRC_PATH}/${NAME}/q${QVAL}p${PVAL}/sep_pair/${SRC_TAIL}`	
	
for rd in ${READs}	
do	
	#                                   #${SRC_PATH}/*_[0-9]*.RnFq30p90S.[12].gz
	rd_basename=`basename ${rd}`    # -> *_[0-9]*.RnFq30p90S.[12].gz
	mylane=${rd_basename##*_}       # -> [0-9]*.RnFq30p90S.[12].gz
	mylane=${mylane%%.*}            # -> [0-9]*
	my1or2=${rd_basename%.*}        # -> *_[0-9]*.RnFq30p90S.[12]
	my1or2=${my1or2##*.}            # -> [12]
	
	echo "ln -s ${rd} ${OUTPATH}/${NAME}/${FQ_HEAD}_${mylane}_${my1or2}_${FQ_TAIL}"
	eval "ln -s ${rd} ${OUTPATH}/${NAME}/${FQ_HEAD}_${mylane}_${my1or2}_${FQ_TAIL}"
done
