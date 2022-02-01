SynthDef(\augmentedSteps, {| out = 0, bufnum = 0, amp = 1, gain = 50, expThresh = (45.neg), smoothing = 0.001, cutoff = 15, masterAmp = 1, releaseTime = 1.0, cutoffLPF = 100, outputVol = 1, rateLo, rateHi |
	var in, step, sig, hpf, envfollower, filter, expander, mix, tsub, lpf, smoothedCutoff, rate;

	in = SoundIn.ar((0..23)); // input 24
	hpf = HPF.ar(in, cutoff); // HPF to filter out noise 15Hz2
	tsub = hpf.max(0); // half wave rect
	//tsub = tsub.log + 0.01; 
	envfollower = Amplitude.kr(tsub); // envelope follower
	mix = Mix(envfollower)  * gain; // mix all channels togeather after HPF and env follower

	smoothedCutoff = Amplitude.kr(
		mix.linlin(2e-3, 3e-2, cutoffLPF, 13000), 0.0, 1.25
	);
	//smoothedCutoff.poll(label: \cutoffAugSt);
	
	rate = Amplitude.kr(mix.linlin(2e-3, 3e-2, rateLo, rateHi), 0.0, 2.25);
	

	filter = K2A.ar(mix) + Lag.ar( //smoothing
		K2A.ar(mix), smoothing);

	//expander
    expander = Compander.ar(filter, filter,
        thresh: expThresh.dbamp,
        slopeBelow: 4,
        slopeAbove:  1,
        clampTime:   0.01,
        relaxTime:   0.1
		);
	
	amp = expander * 3;

	amp = Amplitude.ar(amp, 0.0, releaseTime);
	
	sig = PlayBuf.ar(
		numChannels:1,
		bufnum:bufnum,
		rate: BufRateScale.kr(bufnum) * rate, loop:1,
		doneAction:0) * amp * 0.75;

	// LPF filtering -- excitation cutoff freq parametrisation
	sig = LPF.ar(sig, smoothedCutoff.lag(0.05)); // lpf -- mod by amplitude
	
	sig = sig * masterAmp;
	sig = sig * outputVol * 20;
    Out.ar(out, sig!2);
}).add;

"AUGMENTATION PATCH LOADED".postln;

//test play
//e = ();
//e.augmentedSteps = Synth(\augmentedSteps);

