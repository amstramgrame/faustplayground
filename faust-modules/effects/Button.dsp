declare name "Button";
declare author "Joseph Bizien";

// Press and hold switch 1 to play sound

import ("stdfaust.lib");

gate = button("gate[switch:1]") : si.smoo;

process = *(gate) ;
