#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=207696 s=206265 w=307836 e=309798
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=10

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=139:105:20
d.vect contours_tmp where="level % 50 = 0" width=3 color=139:105:20

# points
X=308336
Y=207530
d.graph -m << EOF
  color black
  width 7
  symbol basic/box 8 $X $Y black none
EOF
X=309258
Y=206623
d.graph -m << EOF
  color black
  width 7
  symbol basic/circle 8 $X $Y black none
  text B
EOF

# contour labels
d.graph -m << EOF
  color white
  polygon
308360 206535
308345 206470
308505 206407
308530 206460
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 308350 206487
  rotation 335
  text 1000
EOF

d.graph -m << EOF
  color white
  polygon
308200 206608.827869
308230 206542.713115
308395 206610.614754
308370 206657.07377
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 308220 206565
  rotation 15
  text 1050
EOF

d.graph -m << EOF
  color white
  polygon
307959.295082 206835
307954 206755
308120 206715
308135 206775
EOF
d.graph -m << EOF
  color 139:105:20
  size 2.7
  move 307959.295082 206775
  rotation 340
  text 1100
EOF

d.mon stop=cairo

echo "\mysection{Task ${ME: -2}}"
echo "\myimage{${ME}.png}"
echo "Imagine there is a stream that connects the circle and the square.
Please draw the path you believe the stream would follow.
In addition, clearly mark the direction you believe the water flow, and why.

\vspace{6em}

Finally, do you think the water would flow faster near the circle,
or near the square? Why?
"
