declare name "NoiseFilter";
declare author "Joseph Bizien";

// Move from left to right along the x axis to cut high frequencies
// Move from bottom to front along the y axis to increase volume

import("stdfaust.lib");

process = vgroup("Noise Filter", noiseFilter);

noiseFilter = noise : lowPass : *(volume);

//--- Noise Generator ---
random  = +(12345)~*(1103515245);
noise   = random/2147483647.0;

//--- Lowpass Filter - Axe X ---
lowPass = fi.lowpass(2,fc)
    with{
        fc = hslider("Lowpass Filter [hidden:1][acc:0 1 -10 0 10][scale:log]", 800, 10, 18000, 0.01):si.smooth(0.999):min(18000):max(10);
};

volume = hslider("volume [hidden:1][acc:1 0 -10 0 10]", 0.5, 0, 1, 0.01):si.smooth(0.998);
