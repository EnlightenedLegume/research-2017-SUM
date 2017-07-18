#! /bin/bash

filename=$FIGURES"/predVData.ps"
efnm=`echo $filename | sed 's/.ps/.eps/g'`
pfnm=`echo $filename | sed 's/.ps/.pdf/g'`

data=~/research/data/processed/tideLevel_rqh_UHSLC/stationRange.txt

#plotting prep
gmt gmtset FONT_ANNOT_PRIMARY 8p,Helvetica
gmt gmtset FONT_TITLE 12p,Helvetica
gmt gmtset FONT_LABEL 8p,Helvetica
gmt gmtset PROJ_LENGTH_UNIT cm
gmt gmtset PS_PAGE_ORIENTATION portrait
gmt gmtset PS_MEDIA letter
o="-K -V -O"

figw=15
centw=`echo $figw/2 | bc -l`

# DEFINE PROJECTION, and make a colour scale
proj=" -Rg -JW250/${figw}c"
#proj=" -R-10/20/40/60 -JT3.5/50/${figw}c"

# Get max data value 
max=`gmt gmtinfo -C $data | awk '{print $6*1.2}'`
# Colour palette selection.  -Z flag would make continuous
gmt makecpt -Crainbow -T0/${max}/0.01 -Z  > chil.cpt
#gmt makecpt -Cwysiwyg -T0/70/.01 -Z > chil.cpt

# Write PS header - so no care is needed for the -K or -O flags later (historical)
echo 0 0 | gmt psxy -R1/2/1/2 -JX4.25/10 -Sp -K -Y15 > $filename

gmt psbasemap $o $proj -Bg30  >> $filename
gmt pscoast $proj -B15 -Slightblue  $o >> $filename

#the -A flag determines 
gmt pscoast $proj -W0.25p $o -A0/0/1 >> $filename

# Read in the prediction data
awk '{print $1, $2, $3}' ~/research/data/processed/webcritech/stationList.txt | gmt psxy $proj -Cchil.cpt -W.25p -St0.2 -: $o >> $filename
# Read in the UHSLC data 
awk '{print $1, $2, $3}' $data | gmt psxy $proj -Cchil.cpt -W.25p -Sc0.2 -: $o >> $filename

# label something
# echo "-30 -10.  CM Atlantic" | gmt pstext $proj -N $o -F+f12,1,black+j -:  >> $filename

# Calculate scale interval
majorint=`echo $max/4 | bc`
minorint=`ehco $minorint/6 | bc -l`
# plot scale + key
gmt psscale -Cchil.cpt -D${centw}c/-1c/4c/0.4ch -Np -Ba${majorint}f${minorint}:"Tidal Range (m)": $o >>$filename

#finish up
echo 0 0 | gmt psxy -R1/2/1/2 -JX1/1 -Sp -O >> $filename


echo " made $filename ........"

ps2epsi $filename $efnm

ps2pdf $filename $pfnm

xpdf $pfnm &

convert -density 300 $efnm $pfnm
