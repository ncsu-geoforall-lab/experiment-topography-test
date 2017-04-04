#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=243135 s=241866 w=299769 e=301332
r.neighbors input=ned output=ned_tmp size=7
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=10

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 50 = 0" width=3 color=95:72:16


d.graph -m << EOF
  color white
  polygon
300492.064793 242421.468085
300562.29342 242364.895025
300593.506142 242405.861723
300509.62195 242470.237964
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 300497.917179 242430.976037
  rotation 325
  text 950
EOF


d.graph -m << EOF
  color white
  polygon
  300599.358528 242723.841338
  300702.750673 242713.841338
  300716.406239 242757.25088
  300587.653757 242757.004856

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 300590.161709 242723.34929
  rotation 0
  text 1050
EOF

d.graph -m << EOF
  color white
  polygon
  320603.607259 217707.447751
  320626.237237 217855.568762
  320598.578374 217863.227625
  320575.948395 217727.563288

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 320605 217730
  rotation 80
  text 500
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





