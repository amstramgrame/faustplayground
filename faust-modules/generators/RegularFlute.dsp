declare name "RegularFlute";
declare author "Joseph Bizien";

// Move from right to left along the x axis to increase frequency
// Turn knob 2 to increase blowing pressure (volume)

import ("stdfaust.lib");

fluteModel(tubeLength,mouthPosition,pressure) = pm.endChain(fluteChain) : fi.dcblocker
with{
    maxTubeLength = pm.maxLength;
    tubeTuning = 0.27; // set "by hand"
    tLength = tubeLength+tubeTuning; // global tube length
    embouchurePos = 0.27 + (mouthPosition-0.5)*0.4; // position of the embouchure on the tube
    tted = tLength*embouchurePos; // head to embouchure distance
    eted = tLength*(1-embouchurePos); // embouchure to foot distance
    fluteChain = pm.chain(pm.fluteHead : pm.openTube(maxTubeLength,tted) : pm.fluteEmbouchure(pressure) : pm.openTube(maxTubeLength,eted) : pm.fluteFoot : pm.out);
};

fluteModel_ui(pressure) = fluteModel(tubeLength,mouthPosition,pressure)*outGain
with{
    tubeLength = hslider("v:fluteModel/[0]tubeLength[acc: 0 0 -10 0 10][hidden:1] ",0.8,0.01,3,0.01) : si.smoo;
    mouthPosition = 0.35;
    outGain = 0.5;
};

blower(pressure,breathGain,breathCutoff,vibratoFreq,vibratoGain) = pressure + vibrato + breathNoise
with{
    vibrato = os.osc(vibratoFreq)*vibratoGain;
    breathNoise = no.noise : fi.lowpass(2,breathCutoff) : *(pressure*breathGain);
};


blower_ui = blower(pressure,breathGain,breathCutoff,vibratoFreq,vibratoGain)
with{
    pressure = hslider("v:blower/[0]pressure[knob:2]",0,0,1,0.01) : si.smoo;
    breathGain = 0.1*0.05;
    breathCutoff = 2000;
    vibratoFreq = 5;
    vibratoGain = 0.25*0.03;
};


flute_ui = hgroup("flute",blower_ui : fluteModel_ui);

process = flute_ui;
