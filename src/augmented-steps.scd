SynthDef(\augmentedSteps, {| out = 0, bufnum, amp = 1, gain = 50, expThresh = (45.neg), smoothing = 0.001, cutoff = 15, masterAmp = 1, releaseTime = 1.0, cutoffLPF = 100, outputVol = 1, rateLo, rateHi, compThresh = 2, lpfHiLimit = 13000 |
	var in, step, sig, hpf, envfollower, filter, expander, mix, tsub, lpf, smoothedCutoff, rate;

	in = SoundIn.ar((0..23)); // input 24
	hpf = HPF.ar(in, cutoff); // HPF to filter out noise 15Hz2
	tsub = hpf.max(0); // half wave rect
	//tsub = tsub.log + 0.01; 
	envfollower = Amplitude.kr(tsub); // envelope follower
	mix = Mix(envfollower)  * gain; // mix all channels togeather after HPF and env follower

	smoothedCutoff = Amplitude.kr(
		mix.linlin(2e-3, 3e-2, cutoffLPF, lpfHiLimit), 0.0, 1.25
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
	sig = LPF.ar(sig, smoothedCutoff.lag(0.85)); // lpf -- mod by amplitude
	//compThresh = 82.neg; // MouseX.kr(90, -1).neg;
	sig = Compander.ar( // dynamic compression
		in: sig,
		control: sig, 
		thresh: compThresh.dbamp,
		slopeBelow: 1,
		slopeAbove: 0.9,
		clampTime:  0.01,
		relaxTime:  0.01
		);
	sig = sig * masterAmp;
	sig = sig * outputVol * 20;
    Out.ar(out, sig!2);
}).add;

"AUGMENTATION PATCH LOADED".postln;
