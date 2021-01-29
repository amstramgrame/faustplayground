import("stdfaust.lib");

time = hslider("v:Percsounds/[1]time[hidden:1][acc:0 1 -10 0 10]", 24000, 3000, 48000, 100);
temps = hslider("v:Percsounds/[2]temps", 0.5, 0, 1, 0.01);
TtoSR = temps*temps*45000+3000;
timer = ba.pulse(TtoSR); 


//kick
envfreqKick1 = en.ar(0.04, 1000*gate, gate*timer);
envfreqKick2 = en.ar(0.06, 1000*gate, gate*timer);
freqKick1 = 1900*envfreqKick1;
freqKick2 = 60*envfreqKick2;
freqKick = 2000-freqKick1-freqKick2;

envgainKick = en.ar(0.01, 0.1, gate*timer);

kick = os.osc(freqKick)*gate*envgainKick;

//Snare 
envgainSnare = en.ar(0.0087, 0.013, gate*timer);

q = hslider("q", 1, 1, 50, 1);
snare = no.noise*envgainSnare : fi.resonbp(1960, 3, 1);

//Hi-hat
envgainHihat = en.ar(0.0001, 0.02, gate*timer);

hihat = no.noise*envgainHihat*0.7 : fi.resonbp(5925, 1, 1);

percus = hslider("v:Percsounds/[0]Sound[style:menu{'kick':0;'snare':1;'hihat':2}][knob:2]", 0, 0, 2, 1);
percu = kick, snare, hihat : ba.selectn(3, percus);

gate = checkbox("v:Percsounds/[2]On/Off[switch:1]");

process = percu;
