declare name "Djembe";
declare author "Joseph Bizien";

// Move from left to right along the x axis to increase frequency
// Move from front to bottom along the y axis to increase speed
// Turn knob 2 to change strike position

import ("stdfaust.lib");

time = hslider("[2]time[acc: 1 0 -5 0 5][hidden:1]", 28800, 3600, 32400, 4800);
timer = ba.pulse(time); 

djembe = pm.djembe(freq,strikePosition,strikeSharpness,gain,gate)*outGain;

freq = hslider("[1]freq[acc: 0 0 -10 0 10][hidden:1]",110,55,220,55);
gain = 2;
strikePosition = hslider("strike[knob:2]", 0.5, 0, 1, 0.1);
strikeSharpness = 0.5;
outGain = 1;    
gate = 1*timer;


process = djembe;
