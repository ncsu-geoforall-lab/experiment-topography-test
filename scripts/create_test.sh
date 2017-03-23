#!/bin/bash

cd `dirname $0`
OUT=test.tex

echo "\documentclass[12pt]{article}
\usepackage[margin=2.5cm]{geometry}
\usepackage{graphicx}


\newcommand{\mysection}[1]{\subsection*{#1}}
\newcommand{\myimage}[1]{ \includegraphics[width=\textwidth]{figures/#1}}

\begin{document}" > ../$OUT

for TASK in "$@"
do
    ./$TASK >> ../$OUT
    echo "\clearpage"
done


echo "\end{document}" >> ../$OUT
cd ..
pdflatex $OUT

