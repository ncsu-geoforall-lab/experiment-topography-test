#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=7 n=1150842 s=1147937 w=-2850050 e=-2846480
r.neighbors input=yosemite output=ned_tmp size=3
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20 cut=10

d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16

# points
X=-2847446
Y=1148266
d.graph -m << EOF
  color black
  width 7
  symbol basic/box 8 $X $Y black none
EOF
X2=-2849015
Y2=1150212
d.graph -m << EOF
  color black
  width 7
  symbol basic/circle 6 $X2 $Y2 aqua none
  text B
EOF

# contour labels
d.graph -m << EOF
  color white
  polygon
-2848766.72629 1148548.57071  
-2848600.41792 1148791.76521
-2848659.59293 1148840.868
-2848820.29297 1148584.28183
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move -2848765.65407 1148540.89016 
  rotation 56
  text 3400
EOF

d.graph -m << EOF
  color white
  polygon
-2849170.72362 1148280.91232 
-2848914.03466 1148133.42894
-2848860.46798 1148195.9234 
-2849161.86806 1148372.33456       
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move -2849184.0125 1148290.76788   
  rotation 330
  text 3300
EOF

d.graph -m << EOF
  color white
  polygon
-2847583.7954 1150320.73504
-2847561.4759 1149963.62384  
-2847467.7343 1149932.37661  
-2847472.1981 1150311.80726
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move -2847551.30098 1150289.48781
  rotation 270
  text 3400
EOF



echo "\myimage{${ME}.png}"
echo "You are standing at the square, but you want to get to a place (on the map) where
you would be able to see a small lake (the circle). Assume there is no vegetation.
Please draw a line that indicates the most efficient route from the square to another spot
on the map where you can see the lake.

"

if [ -n "${KEY}" ]; then

r.viewshed --overwrite obs=5 target=5 input=ned_tmp output=view coordinates=-2849015,1150212 -b
r.mapcalc "view2 = if(view == 1, 1, null())"
r.to.vect inp=view2 out=view -t type=area
d.vect view f_color=yellow color=yellow width=3
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16
X2=-2849015
Y2=1150212
d.graph -m << EOF
  color black
  width 7
  symbol basic/circle 6 $X2 $Y2 aqua none
  text B
EOF

r.mapcalc "fr = 0"
r.walk -k --overwrite elevation=ned_tmp friction=fr output=cost outdir=dir start_raster=view2 stop_coordinates=$X,$Y lambda=0 walk_coeff=0.2,10.5,0,-10.5
r.drain -d input=cost direction=dir output=drain drain=drain start_coordinates=$X,$Y
d.vect drain color=green width=4

r.walk -k --overwrite elevation=ned_tmp friction=fr output=cost outdir=dir start_raster=view2 stop_coordinates=$X,$Y lambda=0 walk_coeff=0.6,2.5,0,-2.5
r.drain -d input=cost direction=dir output=drain drain=drain start_coordinates=$X,$Y
d.vect drain color=red width=4

fi

d.mon stop=cairo
