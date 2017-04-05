#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region n=221035 s=219876 w=323375 e=324801 res=3
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20 

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16

d.legend -tb raster=ned_tmp border_color=none at=2,25,87,92 fontsize=14 labelnum=2 range=630,1050

X=323979
Y=220411
OFFX=20
OFFY=-20
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  symbol basic/point 2 $X $Y none black
  move $XX $YY
  text A
EOF
X2=324347
Y2=220220
let "XX = X2 + OFFX"
let "YY = Y2 + OFFY"
d.graph -m << EOF
  color black
  symbol basic/point 2 $X2 $Y2 none black
  move $XX $YY
  text B
EOF



echo "\myimage{${ME}.png}"
echo "Imagine you had to walk from point A to point B.
Draw the route you would take so that you expend the least amount of energy as possible."


if [ -n "${KEY}" ]; then
r.mapcalc "fr = 0"
r.walk -k --overwrite elevation=ned_tmp@rendering friction=fr output=cost outdir=dir start_coordinates=$X,$Y stop_coordinates=$X2,$Y2 lambda=0 walk_coeff=0.1,15.5,0,-15.5
r.drain -d input=cost direction=dir output=drain drain=drain start_coordinates=$X2,$Y2
d.vect drain color=green width=4

r.walk -k --overwrite elevation=ned_tmp@rendering friction=fr output=cost outdir=dir start_coordinates=$X,$Y stop_coordinates=$X2,$Y2 lambda=0 walk_coeff=0.5,4,0,-4
r.drain -d input=cost direction=dir output=drain drain=drain start_coordinates=$X2,$Y2
d.vect drain color=green width=4;
fi

d.mon stop=cairo
