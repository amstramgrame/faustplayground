import ("stdfaust.lib");

nylonGuitar_ui_MIDI = pm.nylonGuitar(stringLength,bend,gain,gate)
with{
    f = hslider("v:nylonGuitar/v:[0]midi/[0]freq[acc: 0 1 -10 0 10][hidden:1]",440,50,1000,0.01);
    bend = 1;
    gain = hslider("v:nylonGuitar/V:[0]midi/[2]gain[hidden:1]",0.8,0,1,0.01);
    gate = button("v:nylonGuitar/[4]gate[switch:1]");
    env = en.are(5, 1000*gate, gate);

    freqDown = f-(f/1.8)*env;
    freqUp = f+(f/1.8)*env;

    freqs = hslider("v:nylonGuitar/Bend[style:menu{'freqDown':0;'freqUp':1}][knob:2]", 0, 0, 1, 1);
    freq = freqDown, freqUp: ba.selectn(2, freqs);
    stringLength = freq : pm.f2l;
};


process = nylonGuitar_ui_MIDI;