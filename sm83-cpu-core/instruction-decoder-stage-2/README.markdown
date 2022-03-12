# SM83 instruction decoder stage 2

![sm83_instruction decoder stage 2](thumbnail.jpg)

[sm83_instr_decoder_stage2.svg](sm83_instr_decoder_stage2.svg) is a traced
Inkscape SVG based on a microscope photo taken with my "Frankenscope" and
a 40x objective.

This instruction decoder stage is based on wide OR gates implemented using
dynamic logic with static CMOS buffered outputs (= domino logic). All outputs
are 0 during precharge phase.

## Connections

* Clock: main clock for dynamic logic precharge and evaluation phases
* 107 inputs coming from stage 1
* 59 outputs, which are either
    a) signals passed as-is from stage 1 (technically not stage 2 outputs at all)
    b) buffered stage 1 signals
    c) signals coming from internal OR logic, buffered with static CMOS

## License

Licensed under Creative Commons Attribution 4.0 International.
