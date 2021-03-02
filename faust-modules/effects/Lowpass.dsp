declare name "Lowpass";

import ("stdfaust.lib");

//Turn knob 2 to cut high frequencies 

fc = hslider("fc[knob:2]", 18000, 50, 18000, 1);

process = fi.lowpass(2, fc);
