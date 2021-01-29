import ("stdfaust.lib");




echo = _ : ef.echo(0.5,del,fdbck) : _ 

with {
del = hslider("del", 0.25,0,0.5,0.01); 
fdbck = hslider("feedback", 0.5,0,1,0.01);
}; 

process = echo;