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
    # Tell me what's getting checked 
    echo "Checking station $p"
    # The basic URL (RQH -> Research Quality, Hourly)
    urlBase="http://uhslc.soest.hawaii.edu/thredds/dodsC/uhslc/rqh/OS_UH-RQH"
    togaId=$p
    
    # Two standards appear to exist, _D and _R,
    # so we need to figure out which one is being used
    urlEnd_D="_20160323_D"
    urlEnd_R="_20160323_R"
    
    # First, download the DDS's
    urlDDS_D=$urlBase$togaId$urlEnd_D".dds"
    urlDDS_R=$urlBase$togaId$urlEnd_R".dds"
    # Check both stations and save the results to variables
    curl -s --head $urlDDS_D | head -n 1 | grep "HTTP/1.[01] [23].."
    resp_D=$?
    curl -s --head $urlDDS_R | head -n 1 | grep "HTTP/1.[01] [23].."
    resp_R=$?

    # Figure out which one to do
    # Create boolean for downloading, default to true
    exists=0
    if [ $resp_D -eq 0 ]; then
	urlEnd=$urlEnd_D
    elif [ $resp_R -eq 0 ]; then
	urlEnd=$urlEnd_R
    else 
	# Set exists boolean to skip download step
	exists=1
	# Blacklist ID if both fail!
	if [ -a blacklist.txt ]; then
	    # Append if the file already exists
	    echo $togaId >> blacklist.txt
	else
	    # Otherwise, create the blacklist file
	    echo $togaId > blacklist.txt
	fi
    fi
    
    # Actual downloading and parsing section
    if [ $exists -eq 0 ]; then
	urlDDS=$urlBase$togaId$urlEnd".dds"
	# Tell me what station is being checked
	echo "Checking station $togaId with DDS URL $urlDDS"
	# Get the actual DDS, not just the head
	wget $urlDDS -qO DDS.txt
	# Parse the number of time points
	time="$(awk '/Float64 time\[time = [1-9]*/ {print $4}' DDS.txt | awk -F']' '/[1-9]*/ {print $1; exit}')"
	# Subtract 1 for 0 indexing
	time="$((time -1))"

	# Build the URL to the data
	urlASCII=$urlBase$togaId$urlEnd".ascii?time[0:1:${time}],depth[0:1:0],latitude[0:1:0],longitude[0:1:0],sea_surface_height_above_reference_level[0:1:${time}][0:1:0][0:1:0][0:1:0]"
	# Build file name
	fname=$togaId".txt"
	# Get data and save
	wget $urlASCII -O $2$fname
    fi
done < $1


