declare name "Comb";

//Move from left to right along the x axis to increase feedback
//Move from bottom to front along the y axis to increase delay

import("stdfaust.lib");

// parameters
gain = 0.25;
del = hslider("del[acc: 1 0 -10 0 10][hidden:1]",525,50,1000,1) : si.smoo;
fb = hslider("fb[acc: 0 0 -10 0 10][hidden:1]",0.7,0.5,1,0.001);

process = no.noise*gain : fi.fb_fcomb(1024,del,1,fb); 