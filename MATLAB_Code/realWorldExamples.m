clear; clc; close all;

data = parseData('places.txt');

honolulu = -157.86;

% Mexico City to Panama City
blankToBlank(honolulu, data(:,7), data(:,8));

% Seoul to LA
blankToBlank(honolulu, data(:,5), data(:,6));

% Sydney to Anchorage
blankToBlank(honolulu, data(:,3), data(:,4));

% Seattle to Corvallis
blankToBlank(honolulu, data(:,1), data(:,2));

% Houston to Fiji
blankToBlank(honolulu, data(:,9), data(:,10));
