declare name "Checkbox";

// Press switch 1 to play sound

import ("stdfaust.lib");

gate = checkbox("gate[switch:1]"):si.smoo;

process = *(gate);
