#!/bin/bash

basename="$1"

if pdflatex -halt-on-error -file-line-error -synctex=1 ${basename} ; then
    if grep -i "undefined citations\|undefined references" ${basename}.log ; then
	if biber ${basename}.tex ; then
	    pdflatex -halt-on-error -file-line-error -synctex=1 ${basename}
	fi
    fi
    if grep -i -q "rerun to get" ${basename}.log ; then
	pdflatex -halt-on-error -file-line-error -synctex=1 ${basename}
    fi
fi


