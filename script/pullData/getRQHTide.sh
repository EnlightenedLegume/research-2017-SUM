#!/bin/bash

# Pulls hourly research quality tide data from 
# University of Hawaii THREDDS server
# First argument is the list of toga IDs to try,
# second argument is the location to save the
# data
# 
# Created by Benjamin Huang on 06/26/2017

# Loop through ID file
while read p; do

    # The basic URL (RQH -> Research Quality, Hourly)
    urlBase="http://uhslc.soest.hawaii.edu/thredds/dodsC/uhslc/rqh/OS_UH-RQH"
    togaId=$p
    urlEnd="_20160323_D"
    
    # Tell me what file is being attempted
    echo "Checking $togaId"
    # First, download the DDS 
    urlDDS=$urlBase$togaId$urlEnd".dds"
    wget $urlDDS -qO DDS.txt

    # Check if response was succesful, otherwise blacklist id
    if [ $? -eq 0 ]
    then 
	# Parse the number of time points
	time="$(awk '/Float64 time\[time = [1-9]*/ { print $4}' DDS.txt | awk -F']' '/[1-9]*/ {print $1; exit}' )"
	# Subtract 1 for 0 indexing
	time="$((time -1))"

	# Build the URL to the data
	urlASCII=$urlBase$togaId$urlEnd".ascii?time[0:1:${time}],depth[0:1:0],latitude[0:1:0],longitude[0:1:0],sea_surface_height_above_reference_level[0:1:${time}][0:1:0][0:1:0][0:1:0]"
	# Build file name
	fname=$togaId".txt"
	# Get data and save
	wget $urlASCII -O $2$fname
    else 
	# Blacklist id, but check if blacklist file exists
	if [ -a blacklist.txt ]
	then
	    echo $togaId >> blacklist.txt
	else
	    # Otherwise, create the blacklist file
	    echo $togaId > blacklist.txt
	fi
    fi
done < $1


