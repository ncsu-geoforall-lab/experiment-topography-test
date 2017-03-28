#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=10 n=210804 s=203121 w=298605 e=309159
r.neighbors input=ned output=ned_tmp size=11
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=25

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
d.rast sedona_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 200 = 0" width=3 color=95:72:16


X=301804
Y=203710
OFFX=50
OFFY=-300
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 90
  symbol geology/half-arrow_left 10 $X $Y black black
  symbol geology/half-arrow_right 10 $X $Y black black
  move $XX $YY
  rotation 0
  size 3.5
  text A
EOF

X=304097
Y=208845
OFFX=-700
OFFY=100
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 330
  symbol geology/half-arrow_left 10 $X $Y black black
  symbol geology/half-arrow_right 10 $X $Y black black
  move $XX $YY
  rotation 0
  size 3.5
  text C
EOF

X=303931
Y=205516
OFFX=0
OFFY=-700
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 100
  symbol geology/half-arrow_left 10 $X $Y black black
  symbol geology/half-arrow_right 10 $X $Y black black
  move $XX $YY
  rotation 0
  size 3.5
  text D
EOF

X=302740
Y=209012
OFFX=0
OFFY=500
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 250
  symbol geology/half-arrow_left 10 $X $Y black black
  symbol geology/half-arrow_right 10 $X $Y black black
  move $XX $YY
  rotation 0
  size 3.5
  text B
EOF


d.graph -m << EOF
  color white
  polygon
304366.591062 204350.780274
305058.155383 204363.587021
305019.735143 204632.528702
304417.818049 204594.108462
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 304422.204555 204403.234248
  rotation 1
  text 800
EOF


d.graph -m << EOF
  color white
  polygon
305188.0575 205121.935
306032.3775 205400.9775
305979.6075 205597.2875 
305214.4425 205373.015

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 305224.02 205200.6675
  rotation 12
  text 1000
EOF


d.mon stop=cairo

echo "\begin{center}"
echo "\includegraphics[width=0.7\textwidth]{figures/${ME}_view.png}"
#echo "\includegraphics[width=0.7\textwidth]{figures/${ME}.png}"
echo "\end{center}"

echo "
\noindent
Imagine you see the view of the picture above.
Write down the letter of the arrow that indicates where and which direction you think you are facing: ........
"

echo "\myimage{${ME}.png}"



