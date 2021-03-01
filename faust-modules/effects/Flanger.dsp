declare name "Flanger";
declare author "Joseph Bizien";

// Move from right to left along the x axis to increase frequency
// Move from front to bottom along the y axis to increase depth

import ("stdfaust.lib");

ffComb(del,ff) = _ <: _,de.delay(128,del)*ff :> _;
flanger(freq,depth,ff) = ffComb(del,ff)
with{
  del = os.osc(freq)*0.5 + 0.5 : +(1) : *(depth);
};

freq = hslider("freq[acc:0 1 -10 0 10][hidden:1]",1,0.1,50,0.01) : si.smoo;
depth = hslider("depth[acc: 1 1 -10 0 10][hidden:1]",1,0,120,0.01) : si.smoo;
ff = 1;

process = flanger(freq, depth, ff);
