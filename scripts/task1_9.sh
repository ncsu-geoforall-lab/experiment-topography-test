#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=209880 s=207948 w=303090 e=305742
r.neighbors input=ned output=ned_tmp size=7
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16
X=320041
Y=225108
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


X1=304813
Y1=208805
X2=304884
Y2=208644
OFFX=20
OFFY=-20
let "XX1 = X1 + OFFX"
let "YY1 = Y1 + OFFY"
let "XX2 = X2 + OFFX"
let "YY2 = Y2 + OFFY"
d.graph -m << EOF
  color black
  width 4
  polyline
$X1 $Y1
$X2 $Y2
  move $XX1 $YY1
  text A
    move $XX2 $YY2
  text B
EOF


X1=303826
Y1=208860
X2=303546
Y2=208802
OFFX=0
OFFY=-110
let "XX1 = X1 + OFFX"
let "YY1 = Y1 + OFFY"
let "XX2 = X2 + OFFX"
let "YY2 = Y2 + OFFY"
d.graph -m << EOF
  color black
  width 4
  polyline
$X1 $Y1
$X2 $Y2
  move $XX1 $YY1
  text C
    move $XX2 $YY2
  text D
EOF



d.graph -m << EOF
  color white
  polygon
304762.4 209175.55
304952.183333 209265.616667
304923.233333 209329.95
304755.966667 209249.533333
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 304778.483333 209200.583333
  rotation 25
  text 800
EOF

d.graph -m << EOF
  color white
  polygon
303671.95 209667.7
303855.3 209706.3
303871.033333 209789.933333
303652.65 209725.6

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 303691.95 209683.083333
  rotation 15
  text 900
EOF

d.mon stop=cairo

echo "\mysection{Task ${ME: -1}}"
echo "\myimage{${ME}.png}"
echo "Imagine Martin traveled on foot from point A to point B, and Megan traveled on foot from point C to point D.

\noindent Who walked up a steeper slope? How can you tell?

\vspace{6em}

\noindent Who traveled a greater vertical distance? How can you tell?"





