declare name "Drop";
declare author "Joseph Bizien";

// Move from right to left along the x axis to increase frequency
// Move from front to bottom to increase speed

import("stdfaust.lib");

drop(f0,trig) = os.osc(f) * (exp(-damp*time) : si.smooth(0.99))
    with {
        damp = 0.043*f0 + 0.0014*f0^(3/2);
        f = f0*(1+sigma*time);
        sigma = eta * damp;
        eta = 0.075;
        time = 0 : (select2(trig>trig'):+(1)) ~ _ : ba.samp2sec;
    };


time = hslider("time[hidden:1][acc:1 0 -10 0 10]", 24000, 2000, 48000, 100);
timer = ba.pulse(time);

process =  drop(hslider("v:bubble/freq[hidden:1][acc: 0 1 -10 0 10]", 600, 150, 5000, 1), 1*timer);

