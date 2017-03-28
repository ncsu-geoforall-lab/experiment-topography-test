#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region n=226701 s=224577 w=308001 e=310613 res=3
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16

d.legend -tb raster=ned_tmp border_color=none at=75,98,1,6 fontsize=14 labelnum=2 range=1220,1930

X=308963
Y=226196
OFFX=30
OFFY=0
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  symbol basic/point 2 $X $Y none black
  move $XX $YY
  text B
EOF
X=308712
Y=225128
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  symbol basic/point 2 $X $Y none black
  move $XX $YY
  text A
EOF
X=309710
Y=226271
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  symbol basic/point 2 $X $Y none black
  move $XX $YY
  text C
EOF

X=309924
Y=225465
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  symbol basic/point 2 $X $Y none black
  move $XX $YY
  text D
EOF
d.mon stop=cairo

echo "\myimage{${ME}.png}"
echo "The contour interval on this map is 20 meters. One person is standing at each point on the map. Please answer (Y/N)
 the following questions about whether the people standing at two points can see each other.
 Assume they are able to use binoculars. Also assume there is no vegetation."

echo ""
echo "\begin{enumerate}"
echo "\item A and B \ ......"
echo "\item B and D \ ......"
echo "\item A and C \ ......"
echo "\item A and D \ ......"
echo "\item B and C \ ......"
echo "\end{enumerate}"


