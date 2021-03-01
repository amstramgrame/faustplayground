declare name "Bird";
declare author "Joseph Bizien";

// Move from right to left along the x axis to increase speed
// Move from bottom to front along the y axis to increase frequency

import ("stdfaust.lib");

g = hslider("v:Bird/[3]Gain[hidden:1]", 0.5, 0, 1, 0.01);

//Timer
time = hslider("v:Bird/[1]Time[acc: 0 0 -10 0 10][hidden:1]", 0.5, 0.25, 1, 0.01);
TtoSR = time*time*45000+3000;
timer = ba.pulse(TtoSR); 

//Freq
envfreq = en.ar(0.04, 1000, timer);
freqDown = 300*envfreq;
freqs = hslider("v:Bird/[2]Freq[acc: 1 0 -10 0 10][hidden:1]", 2750, 1500, 7000
, 5):si.smoo;
freq = freqs-freqDown;

envgain = en.ar(0.01, 0.1, timer);

bird = os.osc(freq)*envgain;

process = bird*g;
