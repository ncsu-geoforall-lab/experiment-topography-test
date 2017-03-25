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
  rotation 320
  symbol geology/half-arrow_left 10 -2331027.06217 591090.388877 black black
  symbol geology/half-arrow_right 10 -2331027.06217 591090.388877 black black
EOF


d.graph -m << EOF
  color black
  width 4
  rotation 290
  symbol geology/half-arrow_left 10 -2329733.21304 592355.485805 black black
  symbol geology/half-arrow_right 10 -2329733.21304 592355.485805 black black
EOF

d.graph -m << EOF
  color black
  width 4
  rotation 180
  symbol geology/half-arrow_left 10 -2326038.55497 589595.274327 black black
  symbol geology/half-arrow_right 10 -2326038.55497 589595.274327 black black
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
-2330725.16404 587697.628935
-2330106.99168 587079.456572
-2329905.72626 587280.721992
-2330653.28354 587970.774863
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move -2330738.90744 587708.261645
  rotation 320
  text 1400
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
  text 1100
EOF


d.mon stop=cairo

echo "\mysection{Task ${ME: -1}}"
echo "\begin{center}"
echo "\includegraphics[width=0.7\textwidth]{figures/${ME}_view.png}"
#echo "\includegraphics[width=0.7\textwidth]{figures/${ME}.png}"
echo "\end{center}"

echo "
\noindent
Imagine you see the view of the picture above. Circle the arrow on the map that indicates where and which direction you think you are facing.
"

echo "\myimage{${ME}.png}"


