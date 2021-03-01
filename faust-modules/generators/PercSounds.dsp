declare name "PercSounds";
declare author "Joseph Bizien";

// Move from left to right along the x axis to increase speed
// Move from bottom to front along the y axis to change sound

import("stdfaust.lib");

//Timer
time = hslider("v:Percsounds/[2]time[hidden:1][acc:0 1 -10 0 10]", 0.5, 0, 1, 0.01);
TtoSR = time*time*45000+3000;
timer = ba.pulse(TtoSR); 


//kick
envfreqKick1 = en.ar(0.04, 1000, timer);
envfreqKick2 = en.ar(0.06, 1000, timer);
freqKick1 = 400*envfreqKick1;
freqKick2 = 45*envfreqKick2;
freqKick = 500-freqKick1-freqKick2;

envgainKick = en.ar(0.01, 0.1, timer);

kick = os.osc(freqKick)*envgainKick;

//Snare 
envgainSnare = en.ar(0.0087, 0.03, timer);

q = hslider("q", 1, 1, 50, 1);
snare = no.noise*envgainSnare : fi.resonbp(1760, 3, 1);

//Hi-hat
envgainHihat = en.ar(0.0001, 0.02, timer);

hihat = no.noise*envgainHihat*0.7 : fi.resonbp(5925, 1, 1);

percus = hslider("v:Percsounds/[0]Sound[hidden:1][style:menu{'kick':0;'snare':1;'hihat':2}][acc: 1 0 -4 0 4]", 0, 0, 2, 1);

percu = kick, snare, hihat : ba.selectn(3, percus);


process = percu;
