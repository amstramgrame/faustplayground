declare name "Highpass";

// Turn knob 2 to cut low frequencies

import ("stdfaust.lib");

fc = hslider("fc[knob:2]", 50, 50, 18000, 1);

process = fi.highpass(2, fc);

