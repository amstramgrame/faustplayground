import("stdfaust.lib");

wind(force) = no.multinoise(2) : par(i, 2, ve.moog_vcf_2bn(force,freq)) : par(i, 2, *(force))
    with {
        freq = (force*87)+1 : ba.pianokey2hz;
    };
gate = checkbox("wind[switch:1]");

process = wind ( hslider("force[acc: 0 1 -10 0 10][hidden:1]",0.66,0,0.99,0.01) * gate : si.smooth (0.997) );
