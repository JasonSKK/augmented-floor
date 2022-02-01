SynthDef(\onsetDetection, {
	| preGain = 60, cutoff = 220, amp = 0.25, expThresh = (14.neg), threshLo = 1.0, threshHi = 1.0, releaseTime = 0.1, outputVol = 1.0 |
    var in, mix, sig, inputSig, runningMax, mixedRaw, mean, squared, nFilt, hpf, slope, step, onsets, chain, trig, max, spec; //DSP vars
	var tbTrig, chVel, meanVel, runMaxTr, trigger, vel; // trigering vars
	inputSig = SoundIn.ar((0..23)) * preGain; // amplify
	mixedRaw = Mix(inputSig); // mix all inputSig channels

	chain = FFT(LocalBuf(128), mixedRaw);
    spec = SpecCentroid.kr(chain);
	spec = K2A.ar(spec);
	Out.ar(~specBus, spec);

	// initial sig processing before triggering
	hpf = HPF.ar(mixedRaw, cutoff);
	squared = hpf.squared; // squaring after HPF 
	nFilt = Median.ar(10, squared);// noise filtering
	slope = Slope.ar(nFilt); // derivative, slope
	step = Compander.ar(slope,// expander SNR, decrease internal noise
        thresh: expThresh.dbamp,
        slopeBelow: 10,
        slopeAbove:  1,
        clampTime:   0.01,
        relaxTime:   0.01
	);
	step = Amplitude.kr(step,0.0,releaseTime); // env follower
	step = K2A.ar(step); // kontrol to audio rate

	// trigger
	threshLo = threshLo.dbamp;
	trigger = Trig.ar(Schmidt.ar(step, threshLo, threshLo), 0.03); // note trig duration
	
	// calculate max amplitude of input signal -- while set back to zero when new trigger  
	chVel = RunningMax.ar(inputSig.abs, trigger).max(1e-10);
	meanVel = 10 * chVel.mean; // mean value of all channels
	// meanVel.poll;

	runMaxTr = DelayN.ar(
		trigger,
		maxdelaytime:0.01,
		delaytime:0.009); // calculate velocity after a while -- so sig will be formed
	
	vel = (meanVel).min(1).max(1e-4); // clipping
	// trigger sent through the onset bus as a signal
	Out.ar(~velBus, runMaxTr * Latch.ar(vel, runMaxTr));
	
	SendTrig.ar(runMaxTr, value: vel); // for sclang amplitude update processing
}).add;

// preset playback synth
~synthReg = { // synth register function
	var reg;
	reg = SynthDef(\presetPlayback, {
		arg
		preGain = 1, amp = 0.1, masterAmp = 1.0, outputVol = d.outputVol, cutoffLPF = d.amplitudeLPFLo, rateLo = d.rateLo, rateHi = d.rateHi, on = 0;
		var	trig, sig, buffer, bufCollection, ampDet, env, nextVoice, spec, cutoff, rate;
		bufCollection = ~soundOD;

		trig = In.ar(~velBus) * preGain;

		spec = In.ar(~specBus); 

		// sample playback parameters
		ampDet = Latch.ar(trig, trig); // sample & hold for velocity amplitude

		rate = ampDet.linlin(0.0, 1.0, 0.7, 1.3) * (0.7 + Env.perc(0.0, 2.25, level: 0.4).kr(gate: trig, doneAction:0)); // glissando as augmentation -- + 0.7 is the lower level. normally 0.4 level would have to be 0.6 (0.7 lower + 0.6 = 1.3) | upper limit of linear mapping, nonetheless result using 0.4 showed significant similarity with augmentation version (rateHi-rateLo - 0.2)

		// switch for presets with no rate modulation
		// if rateLo & Hi == 1, rate = 1, else rate = whatever derives from upper calculation amp.linlin(0.0, 1.0 ... ... )
		rate = rate.max(d.rateLo); 
		rate = rate.min(d.rateHi);
		
		ampDet = ampDet.sqrt; // range amp
		env = Amplitude.ar(trig, attackTime: 0.0, releaseTime: 1.80); // envelope with instant attack and smooth release
		
		// random selection form buffer collection 	
		buffer = Demand.ar(trig, 0, Dxrand(list: bufCollection, repeats: inf)); 

		sig = PlayBufCF.ar(1, buffer, rate: rate, trigger: trig) * outputVol * amp * 4; // amp was from sclang side amp update
		sig = sig!2 * masterAmp * env;

		cutoff = LinExp.ar(ampDet, 1e-4, 1.0, d.amplitudeLPFLo, 13000);
		// cutoff.poll(label:\cutoffOD);
		sig = LPF.ar(sig, cutoff.lag(0.06));
		
		sig = HPF.ar(sig, 30); // 20 HPF filter
		sig = LeakDC.ar(sig, 0.995); // DC
		Out.ar(0, sig);		
	});

	reg.add; // add synth

};

~synthReg.value(); // evaluate 


OSCdef(\amplitudeUpdate, {| msg, time, addr, recvPort, initAmp = 0.1, outputVol = 1 |
	var amplitude;
	//msg.postln;
	amplitude = msg[3];
	amplitude = amplitude.sqrt;
	amplitude.postln;
	//amplitude = amplitude.explin("whateva", "whateva", 0.0, 1.0);

	if(amplitude > 0.1, {
		e.sound.set(\amp, amplitude);
		fork{
			var preGainTemp;
			preGainTemp = d.preGainOD;
			e.od.set(\preGain, 0.0);
			0.2.wait;
			e.od.set(\preGain, preGainTemp)};
	},{
		e.sound.set(\amp, amplitude)
	};
	);
	
	[\velUpdate, amplitude].postln;
}, '/tr');

"ONSET DETECTION PATCH LOADED".postln;
