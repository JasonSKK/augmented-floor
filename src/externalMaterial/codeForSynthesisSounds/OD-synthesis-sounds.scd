//onset detection sample playback sounds

// kraftwerk
play{Env.perc(0.01, 0.6).kr 	* Mix(Saw.ar(59*[1,1.02,1.01,0.99,0.98,2.01,1.99]) * 0.4)*0.2!2}
//:
//s.record("/Users/jsk/Desktop/aug_floor/src/sounds/augmentation-sounds/star-wars-steady-state.wav")
//:

// star-wars
play{var freq = 220;
	var sig;
	var amp, env;
freq = freq * LFNoise1.kr(0.2).range(0.866,1.133);
	sig = Mix(
		Pulse.ar(
			freq *
			[1, 1.01, 0.99, 3.069444, 3.090277, 3.020833, 3.090277 ]/2));
	sig = LPF.ar(sig, Line.kr(10000, 3333, 0.6));
	env = Env.perc(0, 1.9, 0.1, -4).kr;
	sig = sig * env * 0.01 * SinOsc.ar(freq/4) * 10!2;
	Out.ar(0,sig)
}

//:
s.meter;
//:
// steps on Mars
play{
	var sig;
	sig = Gendy1.ar(minfreq:30, maxfreq:100) * 0.2;
	sig = Ringz.ar(sig, 20, 0.01);
	sig = LPF.ar(sig, 70);
	sig = HPF.ar(sig, 20);
	sig = sig!2;
	sig = SoftClipAmp.ar(sig, 0.2);
	/*
 Amplitude.ar(SoundIn.ar(mul:0.2),releaseTime:0.5);*/
};
//:
//s.record("/Users/jsk/Desktop/aug_floor/src/sounds/augmentation-sounds/steps/stepsOnMars.wav")