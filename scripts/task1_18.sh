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



d.graph -m << EOF
  color black
  width 4
  rotation 90
  symbol geology/half-arrow_left 10 301804.88895 203710.979819 black black
  symbol geology/half-arrow_right 10 301804.88895 203710.979819 black black
EOF


d.graph -m << EOF
  color black
  width 4
  rotation 330
  symbol geology/half-arrow_left 10 304097.649381 208845.948364 black black
  symbol geology/half-arrow_right 10 304097.649381 208845.948364 black black
EOF

d.graph -m << EOF
  color black
  width 4
  rotation 100
  symbol geology/half-arrow_left 10 303931.161674 205516.194224 black black
  symbol geology/half-arrow_right 10 303931.161674 205516.194224 black black
EOF
d.graph -m << EOF
  color black
  width 4
  rotation 250
  symbol geology/half-arrow_left 10 302740.134232 209012.436071 black black
  symbol geology/half-arrow_right 10 302740.134232 209012.436071 black black
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
303546.959273 208512.97295
304264.137088 208141.577296
304328.170822 208384.905483
303649.413247 208794.721377

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 303540.413247 208590.847164
  rotation 330
  text 1000
EOF


d.mon stop=cairo

echo "\mysection{Task ${ME: -2}}"
echo "\begin{center}"
echo "\includegraphics[width=0.7\textwidth]{figures/${ME}_view.png}"
#echo "\includegraphics[width=0.7\textwidth]{figures/${ME}.png}"
echo "\end{center}"

echo "
\noindent
Imagine you see the view of the picture above. Circle the arrow on the map that indicates where and which direction you think you are facing.
"

echo "\myimage{${ME}.png}"



