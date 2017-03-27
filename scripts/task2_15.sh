#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=10 n=595120 s=586490 w=-2334460 e=-2322610
r.mapcalc "sedona_tmp = sedona"
r.colors map=sedona_tmp rules=../elevation_color.txt
r.contour input=sedona_tmp output=contours_tmp step=25

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast sedona_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 200 = 0" width=3 color=95:72:16



d.graph -m << EOF
  color black
  width 4
  rotation 180
  symbol geology/half-arrow_left 10 -2325822.91345 589624.026529 black black
  symbol geology/half-arrow_right 10 -2325822.91345 589624.026529 black black
EOF


d.graph -m << EOF
  color black
  width 4
  rotation 310
  symbol geology/half-arrow_left 10 -2329402.56271 590975.380065 black black
  symbol geology/half-arrow_right 10 -2329402.56271 590975.380065 black black
EOF

d.graph -m << EOF
  color black
  width 4
  rotation 110
  symbol geology/half-arrow_left 10 -2330480.77032 591004.132268 black black
  symbol geology/half-arrow_right 10 -2330480.77032 591004.132268 black black
EOF
d.graph -m << EOF
  color black
  width 4
  rotation 10
  symbol geology/half-arrow_left 10 -2332766.57045 591895.450559 black black
  symbol geology/half-arrow_right 10 -2332766.57045 591895.450559 black black
EOF


d.graph -m << EOF
  color white
  polygon
-2328683.125 593086.125
-2328357.25 592300.1875
-2328120.25 592200.3125
-2328416.5 593219.4375
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move -2328599.8125 593150.5625
  rotation 284
  text 1600
EOF


d.graph -m << EOF
  color white
  polygon
-2332795.32265 588272.672993
-2332077.15029 587841.389949
-2331966.49996 588085.783674
-2332723.44215 588531.442819

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move -2332833.44215 588330.810108
  rotation 330
  text 1400
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



