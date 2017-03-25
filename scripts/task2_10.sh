#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=206736 s=205305 w=306288 e=308250
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=10

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=139:105:20
d.vect contours_tmp where="level % 50 = 0" width=3 color=139:105:20
X=307747
Y=205647
OFFX=50
OFFY=50
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 7
  symbol basic/point 2 $X $Y none black
  symbol basic/cross1 5 $XX $YY black none 
EOF
X=307236
Y=206590
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
307963.691827 206074.241436
308099.341868 205938.591395
308116.000645 205969.529124
307985.110255 206081.380912
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 307970.350604 206064.722135
  rotation 318
  text 1050
EOF

d.graph -m << EOF
  color white
  polygon
308030.326935 205379.332453
308173.116452 205469.765814
308142.178723 205500.703543
308006.528682 205417.409658
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 308020.807634 205380.371056
  rotation 30
  text 1000
EOF

d.graph -m << EOF
  color white
  polygon
307836.162353 206454.074118
307828.468235 206501.777647
307654.581176 206484.850588
307680.741176 206427.914118
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 307669 206435
  rotation 10
  text 1100
EOF

d.mon stop=cairo

echo "\mysection{Task ${ME: -2}}"
echo "\myimage{${ME}.png}"
echo "Imagine there is a stream that connects the circle and the cross.
In which direction would the water flow? Why? Please draw the path the stream would take."

