import ("stdfaust.lib");

reverb = _<: (*(g)*fixedgain : re.mono_freeverb(combfeed, allpassfeed, damping, spatSpread)),
	*(1-g), *(1-g) :> _
with{
	scaleroom   = 0.28;
	offsetroom  = 0.7;
	allpassfeed = 0.5;
	scaledamp   = 0.4;
	fixedgain   = 0.1;
	origSR = 44100;

	damping = 0.5*scaledamp*origSR/ma.SR;
	combfeed = hslider("Room Size[knob:2]", 0.5, 0, 1, 0.05)*scaleroom*origSR/ma.SR + offsetroom;
	spatSpread = 0.5*46*ma.SR/origSR: int;
	g = 0.4;
};

process = reverb;