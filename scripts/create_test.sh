#!/bin/bash

cd `dirname $0`
OUT=test.tex

echo "\documentclass[12pt]{article}
\usepackage[margin=2.5cm]{geometry}
\usepackage{graphicx}


\newcommand{\mysection}[1]{\subsection*{#1}}
\newcommand{\myimage}[1]{ \includegraphics[width=\textwidth]{figures/#1}}

\begin{document}
%\pagestyle{empty}
\begin{center}
\Huge
Topographic Map Assessment 2
\end{center}
\normalsize

\noindent
Please complete this 18-item assessment. Try to answer each item to the best of your ability.


\vfill

\noindent
Participant ID: ...........................

\vspace{2em}

\noindent
Date: ...........................

\clearpage


" > ../$OUT

for TASK in "$@"
do
    ./$TASK >> ../$OUT
    echo "\clearpage"
done


echo "\end{document}" >> ../$OUT
cd ..
pdflatex $OUT

