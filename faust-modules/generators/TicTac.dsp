declare name "Tic Tac";

// Move from right to left along the x axis to increase frequency
// Move from bottom to front along the y axis to increase speed
// Turn knob 2 to change the q 

import("stdfaust.lib");

// parameters
impFreq = hslider("impFreq[acc: 1 0 -10 0 10][hidden:1]",11,2,20,0.01) : si.smoo;
resFreq = hslider("resFreq[acc: 0 1 -10 0 10][hidden:1]",1650,300,3000,0.01) : si.smoo;
q = hslider("q[knob:2]",30,10,50,0.01) : si.smoo;

// DSP
process = os.lf_imptrain(impFreq) : fi.resonlp(resFreq,q,1);
