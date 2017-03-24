#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=219234 s=217599 w=320337 e=322350
r.neighbors input=ned output=ned_tmp size=7
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=25

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

echo "\mysection{Task ${ME: -1}}"
echo "\myimage{${ME}.png}"
echo "What is the contour interval on this map? That is, how much does elevation
change moving from one line to another?"





