declare name "Clarinet";

// Move from right to left along the x axis to increase frequency
// Turn knob 2 to increase blowing pressure (volume)

import("stdfaust.lib");

// parameters

pressure = hslider("pressure[knob:2]",0.5,0,1,0.01);
reed = 0.5;
bell = 0.5;
tube = hslider("note[acc: 0 0 -10 0 10][hidden:1]",60,40,88,1) : ba.midikey2hz : pm.f2l : si.smooth(0.99);

// additional mappings
pres = pressure : si.smooth(0.99);

process = pm.clarinetModel(tube,pres,reed,bell); 
