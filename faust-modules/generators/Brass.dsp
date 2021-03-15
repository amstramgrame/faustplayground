declare name "Brass";

//Move from left to right along the x axis to increase frequency
//Move from bottom to front along the y axis to increase lips pressure
//Turn knob 2 to increase blowing pressure (volume)

import("stdfaust.lib");

// parameters

pressure = hslider("pressure[knob:2]",0.5,0,1,0.01) : si.smoo;
lips = hslider("lips[acc: 1 0 -10 0 10][hidden:1]",0.5,0.5,1,0.01) : si.smoo;
tube = hslider("note[acc: 0 0 -10 0 10][hidden:1]",60,40,70,3) : ba.midikey2hz : pm.f2l;
dist = 0.5;

process = pm.brassModel(tube,lips,0,pressure) : ef.cubicnl(dist,0)*0.95; 
