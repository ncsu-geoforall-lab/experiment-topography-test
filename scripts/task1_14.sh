#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=206946 s=205518 w=298425 e=300384
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20

d.mon cairo width=800 hei=584 res=1  out=../figures/${ME}.png --o
d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16

d.legend -tb raster=ned_tmp border_color=none at=2,25,87,92 fontsize=14 labelnum=2 range=800,1170

# points and labels
X1=298919
Y1=206350
X2=299211
Y2=206082
OFFX1=-100
OFFY1=-30
OFFX2=20
OFFY2=-20
let "XX1 = X1 + OFFX1"
let "YY1 = Y1 + OFFY1"
let "XX2 = X2 + OFFX2"
let "YY2 = Y2 + OFFY2"

# line
d.graph -m << EOF
  color black
  width 7
  polyline
    $X1 $Y1
    $X2 $Y2
  move $XX1 $YY1
  text A
  move $XX2 $YY2
  text B
EOF

d.mon stop=cairo

./profile.py ned_tmp $X1,$Y1,$X2,$Y2 ../figures/${ME}_profile_1.png
./profile.py ned_tmp 299651.303279,206823.065573,299522.844262,206435.904371 ../figures/${ME}_profile_2.png
./profile.py ned_tmp 298957.267759,206517.975409,298653.961749,206384.163934 ../figures/${ME}_profile_3.png
./profile.py ned_tmp 300245.426229,205998.786885,299783.330601,205952.398907 ../figures/${ME}_profile_4.png

echo "\myimage{${ME}.png}"
echo "Which elevation profile (below) matches the cross-section of the
line AB above?

\begin{center}
\newcommand{\imgsize}{0.47}
\newcommand{\ABlabels}{
    \hspace*{2em}\textsf{\textbf{\small A \hfill B}}\hspace*{1em}
}
\begin{tabular}{cc}
\includegraphics[width=\imgsize\textwidth]{figures/${ME}_profile_1.png}
&
\includegraphics[width=\imgsize\textwidth]{figures/${ME}_profile_2.png}
\\\\
\ABlabels
&
\ABlabels
\\\\
\includegraphics[width=\imgsize\textwidth]{figures/${ME}_profile_3.png}
&
\includegraphics[width=\imgsize\textwidth]{figures/${ME}_profile_4.png}
\\\\
\ABlabels
&
\ABlabels
\end{tabular}
\end{center}
"
