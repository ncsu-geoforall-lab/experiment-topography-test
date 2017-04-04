#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=219360 s=217725 w=321246 e=323259
r.neighbors input=ned output=ned_tmp size=7
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16


d.graph -m << EOF
  color white
  polygon
322092.156981 218200.278403
322288.341233 218253.139455
322260.624601 218295.827203
322122.330286 218255.596129
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 322120 218202
  rotation 18
  text 1000
EOF

d.graph -m << EOF
  color white
  polygon
  321375.540983 218750.941222
  321493.719761 218748.42678
  321478.633109 218700.65238
  321360.45433 218703.166823

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 321373 218710 
  rotation 0
  text 700
EOF

d.mon stop=cairo

echo "\myimage{${ME}.png}"
echo "What is the contour interval on this map?"


echo ""
echo "\begin{description}"
echo "\item A) 5 m"
echo "\item B) 10 m"
echo "\item C) 20 m"
echo "\item D) 25 m"
echo "\end{description}"



