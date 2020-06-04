#!/bin/zsh

echo "Atualiza ICL Rt para página"
ICLdir=$HOME/dev/covid19model
ICLfigures=$HOME/dev/covid19model/Brazil/figures
COVID19SCdir=$HOME/dev/covid19sc.github.io

# Run ICL Rscript for all brazilian states
cd $ICLdir
Rscript base-Brazil.r --full
git commit -a -m "run ICL Brazil model in $(date +%Y-%m-%d-%T)"

#  Copy SC Figure to covid19sc
cd $ICLfigures
latest=(SC*.png(.om[1]))
fignewname=fig/resultado_ICL_SC_$(date +%Y-%m-%d).png
cp -f  $latest $COVID19SCdir/$fignewname

# Upload figure to github
cd $COVID19SCdir
git fetch --all
git pull origin
git add $fignewname
git commit -a -m "Update ICL result from SC in $(date +%Y-%m-%d-%T)"
git push 
