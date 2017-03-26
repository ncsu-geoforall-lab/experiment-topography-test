#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=206431 s=205000 w=309393 e=311355
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=10

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=139:105:20
d.vect contours_tmp where="level % 50 = 0" width=3 color=139:105:20

# points
X=310607
Y=206230
d.graph -m << EOF
  color black
  width 7
  symbol basic/box 8 $X $Y black none
EOF
X=310414
Y=205482
d.graph -m << EOF
  color black
  width 7
  symbol basic/circle 8 $X $Y black none
  text B
EOF

# contour labels
d.graph -m << EOF
  color white
  polygon
309821 205330
309753 205310
309798 205150
309860 205160
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 309780 205319.590164
  rotation 280
  text 1000
EOF

d.graph -m << EOF
  color white
  polygon
309940 205280
309885 205240
310049.95082 205129.286885
310089.262295 205193.614754
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 309910 205250
  rotation 325
  text 1050
EOF

d.graph -m << EOF
  color white
  polygon
310023 205400
309944 205365
310055 205215
310110 205250
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 309970 205370
  rotation 300
  text 1100
EOF

d.mon stop=cairo

echo "\mysection{Task ${ME: -2}}"
echo "\myimage{${ME}.png}"
echo "Imagine there is a stream that connects the circle and the square.
Please draw the path you believe the stream would follow.
In addition, clearly mark the direction you believe the water would flow, and why."
