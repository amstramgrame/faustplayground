//----------------------rain--------------------------
// A very simple rain simulator
//
// #### Usage
//
// 
//  rain(d,l) : _,_
// 
//
// Where:
//
// * d: is the density of the rain: between 0 and 1
// * l: is the level (volume) of the rain: between 0 and 1
//
//----------------------------------------------------------

import("stdfaust.lib");

rain(density,level) = no.noise*0.5 <: par(i, 2, drop) : par(i, 2, *(level))
    with {
        drop = _ <: @(1), (abs < density) : *;
    };

process  =  rain (
                hslider("v:rain/density[acc: 0 0 -10 0 10][hidden:1]", 300, 0, 1000, 1) / 1000,
                hslider("v:rain/volume[acc:1 0 -10 0 10][hidden:1]", 0.5, 0, 1, 0.01)
            ):>*(1)*button("v:rain/On/Off[switch:1]");