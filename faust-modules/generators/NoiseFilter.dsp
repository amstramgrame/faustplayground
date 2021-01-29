import("stdfaust.lib");

process = vgroup("Noise Filter", noiseFilter);

noiseFilter = noise : lowPass : *(volume) : onOff;

onOff = *(button("[1]On / Off[switch:1]"): si.smooth(0.998));

//--- Noise Generator ---
random  = +(12345)~*(1103515245);
noise   = random/2147483647.0;

//--- Lowpass Filter - Axe X ---
lowPass = fi.lowpass(2,fc)
    with{
        fc = hslider("Lowpass Filter [hidden:1][acc:0 1 -10 0 10][scale:log]", 800, 10, 18000, 0.01):si.smooth(0.999):min(18000):max(10);
};

//--- MyEcho ---


myEcho = vgroup("echo",ef.echo(0.5,del,fdbck))

with {
del = hslider("del", 0.25,0,0.5,0.01); 
fdbck = hslider("feedback", 0.5,0,1,0.01);
}; 


//--- Volume - Axe Z ---
volume = hslider("volume [hidden:1][acc:1 0 -10 0 10]", 0.5, 0, 1, 0.01):si.smooth(0.998);


