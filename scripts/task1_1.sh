#!/bin/bash

#export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
echo $ME
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region n=221035 s=219876 w=323375 e=324801 res=3
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20 -t

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
d.rast ned_tmp
d.vect contours_tmp
d.graph -m << EOF
  color black
  symbol basic/point 2 323770 220706 none black
EOF
d.text -g text=A at=323770,220706
d.graph -m << EOF
  color black
  symbol basic/point 2 323943 220348 none black
EOF
d.text -g text=A at=323943,220348
d.mon stop=cairo

