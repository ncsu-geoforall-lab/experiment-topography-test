#!/bin/bash

export GRASS_FONT="Lato-Medium"
export GRASS_OVERWRITE=1

ME=`basename -s .sh "$0"`
cd `dirname $0`
if [ ! -d "../figures" ]; then
  mkdir ../figures
fi


g.region res=3 n=206634 s=205203 w=296160 e=298122
r.neighbors input=ned output=ned_tmp size=5
r.colors map=ned_tmp rules=../elevation_color.txt
r.contour input=ned_tmp output=contours_tmp step=20

d.mon cairo width=800 hei=584 res=1  out=../figures/${ME}.png --o
#d.rast ned_tmp
d.vect contours_tmp color=95:72:16
d.vect contours_tmp where="level % 100 = 0" width=3 color=95:72:16

# points and labels
X1=297121
Y1=206326
X2=296650
Y2=205703
OFFX1=10
OFFY1=30
OFFX2=-80
OFFY2=-80
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

# contour labels
d.graph -m << EOF
  color white
  polygon
297880 205407
297945 205370
297980 205520
297950 205545
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move 297933.081968 205394.639344
  rotation 70
  text 900
EOF

d.graph -m << EOF
  color white
  polygon
297730 205607.278688
297784.770492 205570
297840 205750
297800 205800
EOF
d.graph -m << EOF
  color 95:72:16
  size 2.7
  move 297784.049181 205585.278688
  rotation 70
  text 1000
EOF

d.mon stop=cairo

./profile.py ned_tmp 297634,205966,297938,205455 ../figures/${ME}_profile_1.png
./profile.py ned_tmp 297870,206213,296973,206188 ../figures/${ME}_profile_2.png
./profile.py ned_tmp 296664,205760,297364,206186 ../figures/${ME}_profile_3.png
./profile.py ned_tmp $X1,$Y1,$X2,$Y2 ../figures/${ME}_profile_4.png

echo "\myimage{${ME}.png}"
echo "Based on the image above, which elevation profile (below) matches the cross-section of the
line AB?

\begin{center}
\newcommand{\imgsize}{0.45}
\newcommand{\ABlabels}{
    \hspace*{2em}\textsf{\textbf{\small A \hfill B}}\hspace*{1em}
}
\newcommand{\answerLetter}[1]{
    \raisebox{9ex}{#1)}
}
\setlength{\tabcolsep}{0.1em}
\begin{tabular}{rcrc}
\answerLetter{A}
&
\includegraphics[width=\imgsize\textwidth]{figures/${ME}_profile_1.png}
&
\rule{0pt}{1em}  % to make this column further from the previous image
\answerLetter{B}
&
\includegraphics[width=\imgsize\textwidth]{figures/${ME}_profile_2.png}
\\\\[-3ex]
&
\ABlabels
&
&
\ABlabels
\\\\
\answerLetter{C}
&
\includegraphics[width=\imgsize\textwidth]{figures/${ME}_profile_3.png}
&
\answerLetter{D}
&
\includegraphics[width=\imgsize\textwidth]{figures/${ME}_profile_4.png}
\\\\[-3ex]
&
\ABlabels
&
&
\ABlabels
\end{tabular}
\end{center}
"
