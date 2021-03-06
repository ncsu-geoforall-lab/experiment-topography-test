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
OFFX1=-60
OFFY1=30
OFFX2=-40
OFFY2=-120
let "XX1 = X1 + OFFX1"
let "YY1 = Y1 + OFFY1"
let "XX2 = X2 + OFFX2"
let "YY2 = Y2 + OFFY2"
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
OFFX1=20
OFFY1=-20
OFFX2=-140
OFFY2=-40
let "XX1 = X1 + OFFX1"
let "YY1 = Y1 + OFFY1"
let "XX2 = X2 + OFFX2"
let "YY2 = Y2 + OFFY2"
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
304160.745 209447.715
304210.47 209620.205
304134.225 209620.205
304107.705 209474.235
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 304165.855 209460.345
  rotation 82
  text 800
EOF

d.graph -m << EOF
  color white
  polygon
303869.025 209444.4
303925.27 209636.45
303855.765 209626.505
303792.78 209451.03

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 303852.505 209464.29
  rotation 70
  text 900
EOF

d.mon stop=cairo

echo "\myimage{${ME}.png}"
echo "Imagine Martin traveled on foot from point A to point B, and Megan traveled on foot from point C to point D.

\vspace{1em}

\noindent Who walked up a steeper slope?

\vspace{1em}

A) Martin

B) Megan

\vspace{1em}

\noindent Who traveled a greater vertical distance?

\vspace{1em}

A) Martin

B) Megan

C) Both traveled the same vertical distance
"




