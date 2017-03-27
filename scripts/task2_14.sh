#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=207393 s=205803 w=300105 e=302061
r.neighbors input=ned output=ned_tmp size=7
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=10

d.mon cairo width=800 hei=584 res=1  out=../figures/${ME}.png --o
d.rast ned_tmp
d.vect contours_tmp color=139:105:20
d.vect contours_tmp where="level % 50 = 0" width=3 color=139:105:20

# points and labels
X1=300822
Y1=206471
X2=300365
Y2=206794
OFFX1=20
OFFY1=-30
OFFX2=20
OFFY2=0
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

./profile.py ned_tmp 300927.735,207107.31,301277.37,207029.07 ../figures/${ME}_profile_1.png
./profile.py ned_tmp $X1,$Y1,$X2,$Y2 ../figures/${ME}_profile_2.png
./profile.py ned_tmp 301893.51,207320.025,301886.175,206818.8 ../figures/${ME}_profile_3.png
./profile.py ned_tmp 300854.385,206283.345,300428.955,206388.48 ../figures/${ME}_profile_4.png

echo "\mysection{Task ${ME: -2}}"
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
