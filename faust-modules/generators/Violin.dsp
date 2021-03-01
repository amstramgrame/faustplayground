declare name "Violin";

// Move from left to right along the x axis to increase frequency
// Move from bottom to front along the y axis to change bow position


import("stdfaust.lib");

// parameters
stringLength = hslider("stringLength[acc: 0 1 -10 0 10][hidden:1]",1.5,0.5,3,0.01);
bowVelocity = hslider("p[knob:2]",0.1,0,1,0.01);
bowPressure = 0.5;
bowPosition = hslider("dist[acc: 1 0 -10 0 10][hidden:1]",0.5,0,1,0.01) : si.smoo;

process = pm.violinModel(stringLength,bowPressure,bowVelocity,bowPosition); 
