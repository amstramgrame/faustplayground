declare name "FM";
declare author "Joseph Bizien";

// Move from right to left along the x axis to increase carrier frequency
// Move from bottom to front along the y axis to increase frequency modulation
// Move from bottom to top to increase amplitude modulation


import ("stdfaust.lib");

mod = os.osc(freq);
freq = hslider("modulation frequency[acc: 1 0 -10 0 10][hidden:1]", 220, 0, 2000, 1);
amp = hslider("modulation amplitude[acc: 2 1 -10 0 10][hidden:1]", 0, 0, 10000, 1);

freq1 = hslider("carrier frequency[acc: 0 1 -10 0 10][hidden:1]", 220, 50, 2000, 1);


process = os.osc(freq1 + amp*mod)*0.5;

