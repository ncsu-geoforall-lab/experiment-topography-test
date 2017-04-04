#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=10 n=619070 s=615430 w=-2336800 e=-2331510
r.mapcalc "sedona_tmp = sedona"
r.colors map=sedona_tmp rules=../elevation_color.txt
r.contour input=sedona_tmp output=contours_tmp step=50

d.mon cairo width=800 hei=550 res=1  out=../figures/${ME}.png --o
d.rast sedona_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 200 = 0" width=3 color=95:72:16

d.legend -tb raster=sedona_tmp border_color=none at=2,25,87,92 range=1350,1940 labelnum=2 fontsize=14

X=299936
Y=239084
OFFX=20
OFFY=-20
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 118
  symbol geology/half-arrow_left 10 -2333737.06667 615808.683333 black black
  symbol geology/half-arrow_right 10 -2333737.06667 615808.683333 black black
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

echo "\begin{center}"
echo "\includegraphics[width=0.85\textwidth]{figures/${ME}.png}"
echo "\end{center}"

echo "
\noindent
Based on the image above, which of the following views best represents what someone would see
standing at the start of the arrow and facing in that direction?"

echo "
\begin{center}
\begin{tabular}{llll}
A) & \includegraphics[width=0.45\textwidth]{figures/task1_8_wrong3.png} &
B) & \includegraphics[width=0.45\textwidth]{figures/task1_8_wrong2.png}\\\\
C) & \includegraphics[width=0.45\textwidth]{figures/task1_8_wrong1.png} &
D) & \includegraphics[width=0.45\textwidth]{figures/task1_8_correct.png}
\end{tabular}
\end{center}
"




