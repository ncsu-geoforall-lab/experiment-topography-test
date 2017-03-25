#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=10 n=622710 s=615430 w=-2335810 e=-2325810
r.mapcalc "sedona_tmp = sedona"
r.colors map=sedona_tmp rules=../elevation_color.txt
r.contour input=sedona_tmp output=contours_tmp step=25

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
d.rast sedona_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 200 = 0" width=3 color=95:72:16



d.graph -m << EOF
  color black
  width 4
  rotation 95
  symbol geology/half-arrow_left 10 -2328933.47431 615686.550315 black black
  symbol geology/half-arrow_right 10 -2328933.47431 615686.550315 black black
EOF


d.graph -m << EOF
  color black
  width 4
  rotation 190
  symbol geology/half-arrow_left 10 -2326688.90459 619302.127491 black black
  symbol geology/half-arrow_right 10 -2326688.90459 619302.127491 black black
EOF

d.graph -m << EOF
  color black
  width 4
  rotation 210
  symbol geology/half-arrow_left 10 -2333641.00433 618222.307462 black black
  symbol geology/half-arrow_right 10 -2333641.00433 618222.307462 black black
EOF
d.graph -m << EOF
  color black
  width 4
  rotation 30
  symbol geology/half-arrow_left 10 -2331833.21574 619508.385249 black black
  symbol geology/half-arrow_right 10 -2331833.21574 619508.385249 black black
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



