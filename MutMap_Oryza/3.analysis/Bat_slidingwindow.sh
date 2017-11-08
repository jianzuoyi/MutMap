#! /bin/sh		
	
# ==================================================					
# Those keys enable users to customize this script					
# ==================================================					
REF=""					
BULK_NAME=""					
	
MISs=""					
DEPTHs=""					
QVAL=""					
PVAL=""					
	
#Average=(0 1 2 3)					
Average=(2 3)					
AverageOption=("2000000 100000" "4000000 100000" "2000000 10000" "4000000 10000")					
AverageDescrpt=("2M100K" "4M100K" "2M10K" "4M10K")					
					
MinCount=5					
					
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
	
if [ -z ${MISs} ]; then					
	MISs=`Set_MISs`				
fi					
					
if [ -z ${DEPTHs} ]; then					
	DEPTHs=`Set_DEPTHs`				
fi					
					
# ==================================================					
# environment					
# ==================================================					
TOPPATH_SCRIPTS=""					
TOPPATH_COVAL=""					
					
# --------------------------------------------------					
					
if [ -z ${TOPPATH_SCRIPTS} ]; then					
	TOPPATH_SCRIPTS=`Set_TOPPATH_SCRIPTS`				
fi					
					
if [ -z ${TOPPATH_COVAL} ]; then					
	TOPPATH_COVAL=`Set_TOPPATH_COVAL`				
fi					
# ==================================================					
	
NAME="${BULK_NAME}"					
FASTA_FAI="${REF}.fai"
	
WithUnmaskedGraph=1					
## 1 : enabled					
## 0 : disabled					
# ==================================================					

QNAME="${NAME}_q${QVAL}p${PVAL}_filtered_pvalue"					
# --------------------					
# 					
# --------------------					
MKDIR="mkdir -p"					
SRCPATH="80.cbind_confidence_interval"					
OUTPATH1="90.slidingwindow"					
					
SCRIPT1="${TOPPATH_SCRIPTS}/3./pileup_to_slidingwindow.R"					
CMD="Rscript ${SCRIPT1}"					
					
SCRIPT2="${TOPPATH_SCRIPTS}/3./make_png.R"					
CONFIGs=("config_SNPindex.ini" \					
		 "config_depth.ini" \			
		 "config_density.ini" \			
		 "config_out_of_conf_intrvl.ini")			
	
CMD2="Rscript ${SCRIPT2}"
	
for mis in ${MISs}					
do					
	echo "${MKDIR} ${OUTPATH1}/mut_index_${mis}/"				
	eval "${MKDIR} ${OUTPATH1}/mut_index_${mis}/"				
	
	for dep in ${DEPTHs}				
	do				
					
		PILEUP="${SRCPATH}/mut_index_${mis}/${QNAME}_cov${mis}_co${dep}.txt"			
		for ave in ${Average[@]}			
		do			
			OUTPATH="${OUTPATH1}/mut_index_${mis}"		
			OUTNAME="${QNAME}_sldwnd${AverageDescrpt[$ave]}_cov${mis}_co${dep}.txt"		
			OUTNAME2="mask${MinCount}_${OUTNAME}"		
			echo "${CMD} ${PILEUP} ${FASTA_FAI} ${AverageOption[$ave]} ${MinCount} ${OUTPATH} ${OUTNAME}"		
			eval "${CMD} ${PILEUP} ${FASTA_FAI} ${AverageOption[$ave]} ${MinCount} ${OUTPATH} ${OUTNAME}"		
					
			OUTNAME="${OUTPATH}/${OUTNAME}"		
			OUTNAME2="${OUTPATH}/${OUTNAME2}"		
					
			OUTPNGPATH="${OUTPATH1}/pngs/${AverageDescrpt[$ave]}/mut_index_${mis}"		
			echo "mkdir -p ${OUTPNGPATH}"		
			eval "mkdir -p ${OUTPNGPATH}"		
			OUTPNGPATH2="${OUTPNGPATH}/mask${MinCount}"		
			echo "mkdir -p ${OUTPNGPATH2}"		
			eval "mkdir -p ${OUTPNGPATH2}"		
					
			for mycfg in ${CONFIGs[@]}		
			do		
				if [ ${mycfg} = "config_SNPindex.ini" ]; then	
					myheader=${QNAME}
				fi	
					
				if [ ${mycfg} = "config_depth.ini" ]; then	
					myheader="depth_${QNAME}"
				fi	
				if [ ${mycfg} = "config_density.ini" ]; then	
					myheader="density_${QNAME}"
				fi	
				if [ ${mycfg} = "config_out_of_conf_intrvl.ini" ]; then	
					myheader="ratio_${QNAME}"
				fi	
					
				OUTPNG="${OUTPNGPATH}/${myheader}_sldwnd${AverageDescrpt[$ave]}_cov${mis}_co${dep}.png"	
				OUTPNG2="${OUTPNGPATH2}/mask${MinCount}_${myheader}_sldwnd${AverageDescrpt[$ave]}_cov${mis}_co${dep}.png"	
					
				mycfg="${TOPPATH_SCRIPTS}/3./${mycfg}"	
					
				if [ ${WithUnmaskedGraph} -eq 1 ]; then	
					echo "${CMD2} ${mycfg} ${PILEUP} ${OUTNAME} ${OUTPNG}"
					eval "${CMD2} ${mycfg} ${PILEUP} ${OUTNAME} ${OUTPNG}"
				fi	
				echo "${CMD2} ${mycfg} ${PILEUP} ${OUTNAME2} ${OUTPNG2}"	
				eval "${CMD2} ${mycfg} ${PILEUP} ${OUTNAME2} ${OUTPNG2}"	
			done		
		done			
	done				
					
done
