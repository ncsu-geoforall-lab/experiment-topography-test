#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=227838 s=225780 w=315735 e=318270
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


X1=316699
Y1=226030
X2=316677
Y2=226346
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


X1=317437
Y1=226318
X2=316908
Y2=226682
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
316677.762678 227103.980512
316866.812225 227233.844624
316831.970634 227316.197476
316633.418835 227176.831111
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 316685 227125
  rotation 30
  text 1400
EOF

d.graph -m << EOF
  color white
  polygon
  316890.816729 225966.877675
  317070.522432 225944.705754
  317095.861771 226004.886684
  316886.812225 226036.560857

EOF
d.graph -m << EOF
  color 95:72:16
  size 2.3
  move 316889 225975
  rotation 355
  text 1200
EOF

d.mon stop=cairo

echo "\mysection{Task ${ME: -1}}"
echo "\myimage{${ME}.png}"
echo "Imagine Joe traveled on foot from point A to point B, and Anna traveled on foot from point C to point D.
Who walked up a steeper slope?

\vspace{4em}

\noindent Why did you choose the answer you did?"





