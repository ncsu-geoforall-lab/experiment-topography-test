#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region n=215324 s=214625 w=317343 e=318205 res=3
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=10

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 50 = 0" width=3 color=95:72:16
X=317660
Y=215239
d.graph -m << EOF
  color black
  width 7
  symbol basic/box 8 $X $Y black none 
EOF
X=317727
Y=214728
d.graph -m << EOF
  color black
  width 7
  symbol basic/circle 8 $X $Y black none 
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

echo "\myimage{${ME}.png}"
echo "Imagine there is a stream that connects the circle and the square.
Please draw the path the stream would follow and
clearly mark the direction the water would flow with arrows."

