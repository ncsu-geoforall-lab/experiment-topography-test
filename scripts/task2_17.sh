#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=7 n=1148518 s=1145613 w=-2862349 e=-2858779
r.neighbors input=yosemite output=ned_tmp size=3
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20 cut=10

if [ -n "${KEY}" ]; then
d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}_key.png --o;
else 
d.mon cairo width=800 hei=650 res=1  out=../figures/${ME}.png --o;
fi
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16

# points
X=-2861533
Y=1147222
d.graph -m << EOF
  color black
  width 7
  symbol basic/box 8 $X $Y black none
EOF
X2=-2859471
Y2=1147133
d.graph -m << EOF
  color black
  width 7
  symbol basic/circle 6 $X2 $Y2 aqua none
EOF

# contour labels
d.graph -m << EOF
  color white
  polygon
-2860886.18764 1145673.82555 
-2860756.73483 1145981.83396  
-2860846.01263 1146039.86453
-2860979.92933 1145682.75333  
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move -2860890.89876 1145682.75333  
  rotation 68
  text 3200
EOF

d.graph -m << EOF
  color white
  polygon
  -2859493.45396 1146057.72009 
  -2859444.35117 1145700.60889
  -2859350.60948 1145709.53667  
  -2859386.3206 1146062.18398  
  
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move -2859479.88728 1146035.40064    
  rotation 276
  text 3300
EOF

d.graph -m << EOF
  color white
  polygon
-2859966.6263 1147707.21495
-2859713.4318 1147831.13165 
-2859730.2151 1147928.09
-2860038.0485 1147762.92607
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move -2859977.87353 1147701.67884
  rotation 30
  text 3200
EOF


d.graph -m << EOF
  color white
  polygon
-2859677.975 1147665.86667
-2859401.36667 1147815.95833
-2859430.1 1147888.58333
-2859726.39167 1147743.33333
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move -2859682.81667 1147668.80833
  rotation 28
  text 3100
EOF


echo "\myimage{${ME}.png}"
echo "You are standing at the square, but you want to get to a place (on the map) where
you would be able to see a small lake (the circle). Assume there is no vegetation.
Please draw a line that indicates the most efficient route from the square to another spot
on the map where you can see the lake.
"

if [ -n "${KEY}" ]; then

r.viewshed --overwrite obs=5 target=5 input=ned_tmp output=view coordinates=$X2,$Y2 -b
r.mapcalc "view2 = if(view == 1, 1, null())"
r.to.vect inp=view2 out=view -t type=area
d.vect view f_color=yellow color=yellow width=3
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16

d.graph -m << EOF
  color black
  width 7
  symbol basic/circle 6 $X2 $Y2 aqua none
  text B
EOF

r.mapcalc "fr = 0"
r.walk -k --overwrite elevation=ned_tmp friction=fr output=cost outdir=dir start_coordinates=-2860111,1146863 stop_coordinates=$X,$Y lambda=0 walk_coeff=0.5,20.5,0,-12.5
r.drain -d input=cost direction=dir output=drain drain=drain start_coordinates=$X,$Y
d.vect drain color=green width=4

r.walk -k --overwrite elevation=ned_tmp friction=fr output=cost outdir=dir start_coordinates=-2859741,1146709 stop_coordinates=$X,$Y lambda=0 walk_coeff=0.5,20.5,0,-12.5
r.drain -d input=cost direction=dir output=drain drain=drain start_coordinates=$X,$Y
d.vect drain color=green width=4

fi

d.mon stop=cairo
