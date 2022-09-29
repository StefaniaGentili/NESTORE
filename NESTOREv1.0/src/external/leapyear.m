function [ status ] = leapyear( year )
% Modified from leapyear.m by Pablo Brubeck 2015
% https://github.com/pbrubeck/MATLAB/blob/master/Simple/LeapYear.m


if mod(year, 400) == 0
    status = true;
elseif mod(year, 4) == 0 && mod(year, 100) ~= 0
    status = true;
else
    status = false;
end
