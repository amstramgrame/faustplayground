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
    mouthPosition = hslider("v:fluteModel/[1]mouthPosition[acc: 1 0 -10 0 10][hidden:1]",0.5,0,1,0.01) : si.smoo;
    outGain = hslider("v:fluteModel/[2]outGain[hidden:1]",0.5,0,1,0.01);
};

blower(pressure,breathGain,breathCutoff,vibratoFreq,vibratoGain) = pressure + vibrato + breathNoise
with{
    vibrato = os.osc(vibratoFreq)*vibratoGain;
    breathNoise = no.noise : fi.lowpass(2,breathCutoff) : *(pressure*breathGain);
};


blower_ui = blower(pressure,breathGain,breathCutoff,vibratoFreq,vibratoGain)
with{
    pressure = hslider("v:blower/[0]pressure[knob:2]",0,0,1,0.01) : si.smoo;
    breathGain = hslider("v:blower/[1]breathGain[hidden:1]",0.1,0,1,0.01)*0.05;
    breathCutoff = hslider("v:blower/[2]breathCutoff[hidden:1]",2000,20,20000,0.1);
    vibratoFreq = hslider("v:blower/[3]vibratoFreq[knob:3][hidden:1]",5,0.1,10,0.1);
    vibratoGain = hslider("v:blower/[4]vibratoGain[acc: 2 0 -10 0 10][hidden:1]",0.25,0,1,0.01)*0.03;
};


flute_ui = hgroup("flute",blower_ui : fluteModel_ui);

process = flute_ui;