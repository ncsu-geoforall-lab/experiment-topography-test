#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=10 n=623130 s=615000 w=-2335810 e=-2325810
r.mapcalc "sedona_tmp = sedona"
r.colors map=sedona_tmp rules=../elevation_color.txt
r.contour input=sedona_tmp output=contours_tmp step=25

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
d.rast sedona_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 200 = 0" width=3 color=95:72:16

d.legend -tb raster=sedona_tmp border_color=none at=75,98,1,6 range=1320,2160  labelnum=2 fontsize=14


X=-2328933
Y=615686
OFFX=100
OFFY=-300
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 95
  symbol geology/half-arrow_left 10 $X $Y black black
  symbol geology/half-arrow_right 10 $X $Y black black
  move $XX $YY
  rotation 0
  size 3.5
  text C
EOF

X=-2327040
Y=620260
OFFX=500
OFFY=-100
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 200
  symbol geology/half-arrow_left 10 $X $Y black black
  symbol geology/half-arrow_right 10 $X $Y black black
  move $XX $YY
  rotation 0
  size 3.5
  text D
EOF


X=-2333641
Y=618222
OFFX=500
OFFY=200
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 210
  symbol geology/half-arrow_left 10 $X $Y black black
  symbol geology/half-arrow_right 10 $X $Y black black
  move $XX $YY
  rotation 0
  size 3.5
  text A
EOF

X=-2331833
Y=619508
OFFX=-700
OFFY=-400
let "XX = X + OFFX"
let "YY = Y + OFFY"
d.graph -m << EOF
  color black
  width 4
  rotation 30
  symbol geology/half-arrow_left 10 $X $Y black black
  symbol geology/half-arrow_right 10 $X $Y black black
  move $XX $YY
  rotation 0
  size 3.5
  text B
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

\vfill

"

echo "\myimage{${ME}.png}"



