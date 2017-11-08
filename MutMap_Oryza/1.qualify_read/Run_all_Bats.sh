#! /bin/sh	
	
# --------------------------------------------------	
# load common functions	
. ../0.common/common.fnc	
# --------------------------------------------------	
MY_CULTIVAR_NAME=`Set_MY_CULTIVAR_NAME`	
	
BULK_NAME=`Set_BULK_NAME`	
	
	
	
	
if [ -z $1 ];then	
	echo "missing args!"
	echo "[usage]"
	echo "    $0 <INT>"
	echo "        <INT> : 0 or 9 (0:${BULK_NAME} / 9:${MY_CULTIVAR_NAME})"
	exit 0
fi	
	
myid=$1	
	
	
	
	
	
	
	
	
	
	
echo "----------------------------------------"	
echo "Run Bat_rename.sh ${myid} ..."	
echo "----------------------------------------"	
./Bat_rename.sh ${myid}	
	
echo "----------------------------------------"	
echo "Run Bat_fastq_quality_filter.sh ${myid} ..."	
echo "----------------------------------------"	
./Bat_fastq_quality_filter.sh ${myid}	
	
echo "----------------------------------------"	
echo "Run Bat_sep_pair.pl.sh ${myid} ..."	
echo "----------------------------------------"	
./Bat_sep_pair.pl.sh ${myid}	
	