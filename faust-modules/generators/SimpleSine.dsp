import ("stdfaust.lib");


process =  os.osc(freq)* gate * volume;

freq = hslider("slide [unit:Hz][acc:0 0 -10 0 10][hidden:1]",1046.5,523.5,2093.0,0.001) : si.smooth(0.998);
volume = hslider("volume [acc:1 0 -9 0 10][hidden:1]", 0.5, 0, 1, 0.001):si.smooth(0.991):min(1):max(0);
gate = checkbox("gate[switch:1]") : si.smoo;