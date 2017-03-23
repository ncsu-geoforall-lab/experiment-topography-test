#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region n=215121 s=214422 w=317543.379732 e=318405.379732 res=3
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=10

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 50 = 0" width=3 color=95:72:16
X=318101
Y=214831
OFFX=30
OFFY=0
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 7
  symbol basic/point 2 $X $Y none black
  symbol basic/cross1 5 $XX $YY black none 
EOF
X=318070
Y=214498
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 7
  symbol basic/point 2 $X $Y none black
  symbol basic/circle 5 $XX $YY black none 
  text B
EOF
d.graph -m << EOF
  color white
  polygon
318060.576918 214996.470873
318114.412745 214960.939227
318125.179911 214982.473558
318076.727666 215019.081921
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move 318070 215005
  rotation 320
  text 650
EOF

d.graph -m << EOF
  color white
  polygon
  317963.672428 214848.960705
 318005.664374 214811.275626
 318018.584972 214828.503091
 317971.209444 214866.18817
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move 317963 214850
  rotation 320
  text 600
EOF



d.mon stop=cairo

echo "\mysection{Task ${ME: -1}}"
echo "\myimage{${ME}.png}"
echo "Imagine there is a stream that connects the circle and the cross.
In which direction would the water flow? Why? Please draw the path the stream would take."

