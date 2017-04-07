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
Topographic Map Assessment 1
\end{center}
\normalsize

\noindent
Please complete this assessment. Try to answer each item to the best of your ability.


\vfill

\noindent
Participant ID: ...........................

\vspace{2em}

\noindent
Date: ...........................



" > ../$OUT

COUNTER=1

for TASK in "$@"
do
    echo "\mysection{Question $COUNTER}" >> ../$OUT
    ./$TASK >> ../$OUT
    echo "\clearpage" >> ../$OUT
    let "COUNTER += 1"
done


echo "\end{document}" >> ../$OUT
cd ..
pdflatex $OUT

