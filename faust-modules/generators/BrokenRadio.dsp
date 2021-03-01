declare name "BrokenRadio";
declare author "Joseph Bizien";

//Move from right to left along axis x to increase modulation frequency (very sensitive)
//Move from bottom to front along axis y to increase volume

import ("stdfaust.lib");

mod = os.osc(freq);
freq = hslider("modulation frequency[acc: 0 1 -10 0 10]", 0, 0, 440, 1);
amp = 1500;

freq1 = 220;

process = os.osc(freq1 + amp*mod)*hslider("gain[acc: 1 0 -10 0 10]", 0.5, 0, 1, 0.01);

