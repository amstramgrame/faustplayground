declare name "AM";
declare author "Joseph Bizien";

// Move from right to left along the x axis to increase carrier frequency and amplitude modulation
// Move from bottom to front along the y axis to increase frequency modulation

import ("stdfaust.lib");

mod = os.osc(freq);
freq = hslider("modulation frequency[acc: 1 0 -10 0 10][hidden:1]", 0, 0, 200, 1): si.smoo;
amp = hslider("modulation amplitude[acc: 0 1 -10 0 10][hidden:1]", 1, 0,  1, 0.1): si.smoo;

freq1 = hslider("carrier frequency[acc: 0 1 -10 0 10][hidden:1]", 220, 50, 2000, 1):si.smoo;


process = (1+amp*mod)*os.osc(freq1)*0.5;

