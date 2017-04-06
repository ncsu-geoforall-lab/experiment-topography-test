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

if [ -n "${KEY}" ]; then
d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}_key.png --o;
else 
d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o;
fi
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 50 = 0" width=3 color=95:72:16

# points
X=308336
Y=207530
d.graph -m << EOF
  color black
  width 7
  symbol basic/box 8 $X $Y black none
EOF
X2=309258
Y2=206623
d.graph -m << EOF
  color black
  width 7
  symbol basic/circle 8 $X2 $Y2 black none
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
  color 95:72:16
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
  color 95:72:16
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
  color 95:72:16
  size 2.7
  move 307959.295082 206775
  rotation 340
  text 1100
EOF


echo "\myimage{${ME}.png}"
echo "Imagine there is a stream that connects the circle and the square.
Please draw the path the stream would follow and
clearly mark the direction the water would flow with arrows.

\vspace{6em}

\noindent
Finally, would the water flow faster near the circle,
or near the square?
"

if [ -n "${KEY}" ]; then

r.hydrodem input=ned_tmp out=ned_tmp2 -a
g.region n=$Y s=$Y2
g.region n=n+5 s=s-5
r.drain input=ned_tmp2 output=drain drain=drain start_coordinates=$X,$Y
v.generalize input=drain output=drain_gen method=snakes threshold=10
g.region res=3 n=207696 s=206265 w=307836 e=309798

d.vect map=drain_gen display=shape,dir color=30:144:255 width=4 size=25

fi

d.mon stop=cairo
