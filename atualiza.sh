#!/bin/zsh
echo "Inicio Script $(date +%Y-%m-$d-%T)"

LOGFILE=$HOME/dev/atualizadadosCOVID19SC/log/cron"$(date +%Y-%m-%d-%T)".log
echo "$(date +%Y-%m-$d-%T) : Starting work\n"  >> $LOGFILE 2>&1
echo "Atualiza resultados modelos ICL para SC" >> $LOGFILE 2>&1
ICLdir=$HOME/dev/covid19model
ICLfigures=$HOME/dev/covid19model/Brazil/figures
COVID19figdir=$HOME/dev/atualizadadosCOVID19SC/figures

COVID19dir=$HOME/dev/atualizadadosCOVID19SC

#Updates SC data using Julia
cd $COVID19dir
julia -E 'include("atualizadados.jl")' >> $LOGFILE 2>&1 

# Run ICL Rscript for all SC regions
cd $ICLdir
Rscript base-Brazil.r --full >> $LOGFILE 2>&1
git commit -a -m "run ICL Brazil model in $(date +%Y-%m-%d-%T)" >> $LOGFILE 2>&1

#  Copy SC Figure to covid19sc
# SC
cd $ICLfigures
latestRt=(SC-R*.png(.om[1]))
fignewnameRt=resultadoRt_ICL_SC_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latestRt $COVID19figdir/$fignewnameRt
latest=(SC-t*.png(.om[1]))
fignewname=resultado_ICL_SC_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19figdir/$fignewname

# SUL
latestRt=(SUL-R*.png(.om[1]))
fignewnameRt=resultadoRt_ICL_SUL_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latestRt $COVID19figdir/$fignewnameRt
latest=(SUL-t*.png(.om[1]))
fignewname=resultado_ICL_SUL_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19figdir/$fignewname

# PNN
latestRt=(PNN-R*.png(.om[1]))
fignewnameRt=resultadoRt_ICL_PNN_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latestRt $COVID19figdir/$fignewnameRt
latest=(PNN-t*.png(.om[1]))
fignewname=resultado_ICL_PNN_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19figdir/$fignewname


# MOS
latestRt=(MOS-R*.png(.om[1]))
fignewnameRt=resultadoRt_ICL_MOS_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latestRt $COVID19figdir/$fignewnameRt
latest=(MOS-t*.png(.om[1]))
fignewname=resultado_ICL_MOS_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19figdir/$fignewname



# GOE
latestRt=(GOE-R*.png(.om[1]))
fignewnameRt=resultadoRt_ICL_GOE_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latestRt $COVID19figdir/$fignewnameRt
latest=(GOE-t*.png(.om[1]))
fignewname=resultado_ICL_GOE_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19figdir/$fignewname



# GFL
latestRt=(GFL-R*.png(.om[1]))
fignewnameRt=resultadoRt_ICL_GFL_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latestRt $COVID19figdir/$fignewnameRt
latest=(GFL-t*.png(.om[1]))
fignewname=resultado_ICL_GFL_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19figdir/$fignewname



# FVI
latestRt=(FVI-R*.png(.om[1]))
fignewnameRt=resultadoRt_ICL_FVI_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latestRt $COVID19figdir/$fignewnameRt
latest=(FVI-t*.png(.om[1]))
fignewname=resultado_ICL_FVI_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19figdir/$fignewname



# AVI
latestRt=(AVI-R*.png(.om[1]))
fignewnameRt=resultadoRt_ICL_AVI_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latestRt $COVID19figdir/$fignewnameRt
latest=(AVI-t*.png(.om[1]))
fignewname=resultado_ICL_AVI_$(date --date="1 day ago" +%Y-%m-%d).png
cp -f  $latest $COVID19figdir/$fignewname



# Upload figure to github
cd $COVID19figdir
git fetch --all >> $LOGFILE 2>&1
git pull origin >> $LOGFILE 2>&1
git add --all >> $LOGFILE 2>&1
git commit -a -m "Update ICL results for SC in $(date +%Y-%m-%d-%T)" >> $LOGFILE 2>&1
git push >> $LOGFILE 2>&1
echo "$(date +%Y-%m-$d-%T) : Finished" >> $LOGFILE 2>&1

echo "Inicio Fim Script $(date +%Y-%m-$d-%T)"
