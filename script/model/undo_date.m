function [YY, MO, DD, HH, MM, SS] = undo_date(start_time);
% Kristine Larson
% ASEN 2003
% March 8, 2004
% code to read times (internal matlab datstr) from absolute gravity data files. 
% outputs 
%    year (YY), month (MO), day (DD), hour (HH), 
%    minute (MM), second (SS) appropriate for use in gravtide.m
% ouput times are integers
YY = str2num(datestr(start_time, 11));
MO = str2num(datestr(start_time, 5));
DD = str2num(datestr(start_time, 7));
hms_v = datestr(start_time, 13);
HH = str2num(hms_v(1:2));
MM = str2num(hms_v(4:5));
SS = str2num(hms_v(7:8));

