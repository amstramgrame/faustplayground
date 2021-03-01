declare name "Vibrato";
declare author "Joseph Bizien";

// Turn knob 2 to increase the frequency and the amplitude of the vibrato

import ("stdfaust.lib");

mod = os.osc(freq);
freq = hslider("modulation frequency[knob:2]", 0, 0, 20, 1): si.smoo;
amp = hslider("modulation amplitude[knob:2]", 1, 0,  1, 0.1): si.smoo;


process = (1+amp*mod)*_*hslider("gain", 0.5, 0, 1, 0.01);

