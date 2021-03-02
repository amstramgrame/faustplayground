declare name "Disto";

// Turn knob 2 to increase distortion

import ("stdfaust.lib");

drive = hslider("disto[knob:2]", 0, 0, 1, 0.1);

process = ef.cubicnl(drive, 0);
