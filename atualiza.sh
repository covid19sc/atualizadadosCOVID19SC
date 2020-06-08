#!/bin/zsh

LOGFILE=$HOME/dev/atualizadadosCOVID19SC/log/cron"$(date +%Y-%m-%d-%T)".log
echo "$(date +%Y-%m-$d-%T) : Starting work\n"  >> $LOGFILE 2>&1
echo "Atualiza ICL Rt para página" >> $LOGFILE 2>&1
ICLdir=$HOME/dev/covid19model
ICLfigures=$HOME/dev/covid19model/Brazil/figures
COVID19SCfigdir=$HOME/dev/atualizadadosCOVID19SC/figures

# Run ICL Rscript for all brazilian states
cd $ICLdir
Rscript base-Brazil.r --full >> $LOGFILE 2>&1
git commit -a -m "run ICL Brazil model in $(date +%Y-%m-%d-%T)" >> $LOGFILE 2>&1

#  Copy SC Figure to covid19sc
cd $ICLfigures
latest=(SC*.png(.om[1]))
fignewname=resultado_ICL_SC_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19SCfigdir/$fignewname

# Upload figure to github
cd $COVID19SCfigdir
git fetch --all
git pull origin
git add $fignewname
git commit -a -m "Update ICL result from SC in $(date +%Y-%m-%d-%T)"
git push >> $LOGFILE 2>&1
echo "$(date +%Y-%m-$d-%T) : Finished" >> $LOGFILE 2>&1
