declare name "Rain";

// Move from left to right along the x axis to increase density
// Move from bottom to front along the y axis to increase volume 

import("stdfaust.lib");

rain(density,level) = no.noise*0.5 <: par(i, 2, drop) : par(i, 2, *(level))
    with {
        drop = _ <: @(1), (abs < density) : *;
    };

process  =  rain (
                hslider("v:rain/density[acc: 0 0 -10 0 10][hidden:1]", 300, 1, 1000, 1) / 1000,
                hslider("v:rain/volume[acc:1 0 -10 0 10][hidden:1]", 0.5, 0, 1, 0.01)
            ):>*(1);
            
