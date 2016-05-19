#!/bin/bash
# -----------------------------------------------------------------------------
# Simple Timer for Terminal
#
# @author jacojang <jacojang@jacojang.com>
# -----------------------------------------------------------------------------

# Local Functions
# -----------------------------------------------------------------------------
printTime(){
	indata=$1

	min=$((${indata} / 60))
	sec=$((${indata} % 60))

	printf "%02d:%02d" ${min} ${sec}
}

showDoneMsg(){
	cols=$1
	rows=$2
	msg=" Timer ended "

	hcols=$((${cols} / 2)) 
	hmsg=$((${#msg} / 2))

	startp=$((${hcols} - ${hmsg}))
	tput cup 2 ${startp}
	echo ${msg}
	tput cup 3 0
	echo
	echo -e "\n  ${msg}  \n" | xmessage -buttons Ok:0 -default Ok -nearmouse -timeout 20 -file -
}

printUsage(){
	echo
	echo " Usage : $0 <time> <cmd>"
	echo ""
	echo " Parameter:"
	echo "     time - seconds"
	echo "     cmd - commands to run when timer done"
	echo
}

printTitle(){
	tput cup 0 0
	echo -n " Simple timer for Terminal by jacojang "
}

printFrame(){
	cols=$1
	rows=$2

	tput cup 1 0
	echo -n "┏"
	c=3 ;while [ ${c} -lt ${cols} ] ; do echo -n "━"; c=$((${c} + 1)); done
	echo -n "┓"

	tput cup 2 0
	echo -n "┃"
	tput cup 2 $((${cols} - 2))
	echo -n "┃"

	tput cup 3 0
	echo -n "┗"
	c=3 ;while [ ${c} -lt ${cols} ] ; do echo -n "━"; c=$((${c} + 1)); done
	echo -n "┛"
}

printProgress(){
	cols=$1
	rows=$2
	ctime=$3
	intime=$4

	prog_size=$((${cols} - 20))

	p=$((${ctime}*${prog_size}/${intime}))

	tput cup 2 2
	tput setaf 1
	tput setab 6
	n=0
	while [ ${n} -lt ${p} ] ; do echo -ne " "; n=$((${n} + 1)); done

	tput setab 9
	while [ ${n} -lt ${prog_size} ] ; do echo -ne " "; n=$((${n} + 1)); done

	tput setaf 1
	echo -n "┃ "
	tput setaf 3
	printTime ${ctime}
	tput setaf 1
	echo -n " / "
	tput setaf 4
	printTime ${intime}

	tput sgr0
}

# Main Start
# -----------------------------------------------------------------------------
if [ $# -lt 1 ] ; then
	printUsage
	exit -1 
fi
intime=$1;shift
if [ $# -lt 1 ] ; then
	cmd=""
else
	cmd=$@
fi
ctime=0


pcols=0
prows=0
while [ ${ctime} -lt ${intime} ]
do
	cols=`tput cols`
	rows=`tput lines`

	if [ ${pcols} -ne ${cols} -o ${prows} -ne ${rows} ] ; then 
		clear
		printTitle
		printFrame ${cols} ${rows}
	fi

	printProgress ${cols} ${rows} ${ctime} ${intime}

	sleep 1
	ctime=$((${ctime} + 1))
	pcols=${cols}
	prows=${rows}
done


## Done Notify 
cols=`tput cols`
rows=`tput lines`
clear
printTitle
printFrame ${cols} ${rows}
if [ "x${cmd}" = "x" ] ; then
	showDoneMsg ${cols} ${rows}
else
	${cmd}
fi

