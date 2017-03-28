#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region n=223167 s=222270 w=319314 e=320418
g.region res=3 n=225897 s=224784 w=320037 e=321408
r.neighbors input=ned output=ned_tmp size=7
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=10

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 50 = 0" width=3 color=95:72:16
X=321035
Y=225554
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



d.graph -m << EOF
  color white
  polygon
320308.868194 224873.993387
320435.656442 224918.54061
320437.089669 224937.387512
320336.281869 224945.954285
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 320330 224908
  rotation 0
  text 1300
EOF

d.graph -m << EOF
  color white
  polygon
320706.366487 225497.654503
320798.887641 225471.954182
320812.594479 225501.081212
320701.226423 225533.634952
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 320698 225509
  rotation 340
  text 1200
EOF

d.mon stop=cairo

echo "\myimage{${ME}.png}"
echo "The contour interval on this map is 10 meters. What is the elevation at point A?"


