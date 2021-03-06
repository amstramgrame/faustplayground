declare name "Metronome";

// Move from right to left along the x axis to increase speed

import("stdfaust.lib");

process = vgroup("Metronome", (bip * envelope) : _ * volume) : min(1) : max(-1) ;
bip = os.osc(230); // Bip's height in Hz;

envelope = en.asr(a,s,r,gate) with{
  a = 0.01; //in seconds
  s = 90; //percentage of gain
  r = 0.02;//in seconds
};

volume = 0.1;

/* --------------------- Pulse -----------------------*/

gate = phasor_bin(1) :-(0.001):pulsar;
ratio_env = (0.15);
fade = (0.5); // min > 0 pour eviter division par 0
proba = 1; // Regular tempo
speed = vslider("[2]tempo[acc: 0 1 -10 0  10][hidden:1]", 100/60, 25/60, 2000/60, 0.1);

phasor_bin (init) =  (+(float(speed)/float(ma.SR)) : fmod(_,1.0)) ~ *(init);
pulsar = _<:(((_)<(ratio_env)):@(100))*((proba)>((_),(no.noise:abs):ba.latch));
