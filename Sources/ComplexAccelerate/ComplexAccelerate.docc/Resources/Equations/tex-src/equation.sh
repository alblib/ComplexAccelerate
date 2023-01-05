#!/bin/bash
if [-z $1]
then
    echo "Needs the equation text file. Please just put the content only and exclude \begin{equation} etc".
else
    echo `$1`
fi
