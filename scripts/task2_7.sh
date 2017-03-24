#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=239691 s=238935 w=299724 e=300654
r.neighbors input=ned output=ned_tmp size=7
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=5

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 25 = 0" width=3 color=95:72:16


X=299936
Y=239084
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

X=300324
Y=239523
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  symbol basic/point 2 $X $Y none black
  move $XX $YY
  text B
EOF


d.graph -m << EOF
  color white
  polygon
300090.557614 239077.289329
300154.574462 239121.043667
300139.443207 239141.994636
300068.442703 239102.420584
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 300084.7379 239090.092699
  rotation 25
  text 1050
EOF


d.graph -m << EOF
  color white
  polygon
  300204.623998 239245.585536
  300276.788445 239271.192275
  300276.788445 239289.815358
  300199.968227 239265.372561

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 300205.787941 239254.224962
  rotation 14
  text 1100
EOF


d.mon stop=cairo

echo "\mysection{Task ${ME: -1}}"
echo "\myimage{${ME}.png}"
echo "Which hill is higher: A or B?"





