declare name "Echo";
declare author "Joseph Bizien";

// Turn knob 2 to increase delay

import ("stdfaust.lib");

echo = _ : ef.echo(0.5,del,fdbck) : _ 

with {
 del = hslider("del[knob:2]", 0.25,0,0.5,0.01):si.smoo; 
 fdbck = 0.6;
}; 

process = echo;
