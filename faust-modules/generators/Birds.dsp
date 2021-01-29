import ("stdfaust.lib");

gate = button("v:Birds/[0]On/Off[switch:1]");
g = hslider("v:Birds/[3]Gain[hidden:1]", 0.5, 0, 1, 0.01);


//Timer
//time = hslider("v:Birds/[1]time[hidden:1][acc:0 1 -10 0 10]", 24000, 3000, 48000, 100);
time = hslider("v:Birds/[1]Time[acc: 0 1 -10 0 10][hidden:1]", 0.5, 0.2, 1, 0.01);
TtoSR = time*time*45000+3000;
timer = ba.pulse(TtoSR); 

//Freq
envfreq = en.ar(0.04, 1000*gate, gate*timer);
freqDown = 300*envfreq;
freqs = hslider("v:Birds/[2]Freq[acc: 1 0 -10 0 10][hidden:1]", 2750, 2000, 3500, 5);
freq = freqs-freqDown;

envgain = en.ar(0.01, 0.1, gate*timer);

bird = os.osc(freq)*gate*envgain;

process = bird*g*gate;