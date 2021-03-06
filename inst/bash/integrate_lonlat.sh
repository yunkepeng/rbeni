#!/bin/bash

	##-----------------------------
	## Calculates global totals, integrating over gridcell area
	## argument 1: input file
	## argument 2: output file
	## argument 3: land area fraction file
	##-----------------------------
	cdo gridarea $1 gridarea.nc
	cdo mulc,1 $1 tmp.nc

	if [ -z "$3" ]
	then
		echo "Assuming all gridcells are 100% land..."
		cdo div tmp.nc tmp.nc ones.nc
		cdo selname,gpp ones.nc mask.nc
		cdo mul mask.nc gridarea.nc gridarea_masked.nc
	else
		echo "Using land mask provided as input..."
		cdo mul $3 gridarea.nc gridarea_masked.nc
	fi

	cdo mul gridarea_masked.nc $1 tmp3.nc
	cdo fldsum tmp3.nc tmp4.nc
	cdo mulc,1e-15 tmp4.nc $2

	## remove temporary files
	rm tmp.nc tmp2.nc tmp3.nc gridarea.nc gridarea_masked.nc mask.nc ones.nc
