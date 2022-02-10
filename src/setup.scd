// INIT: functions, buffer alloc, dictionaries

e = (); // synth dict
d = (); // preset dict

~randomPreset = { | in = 0 | // random preset selection
	var temp, arr, val, suf;
	arr = in;
	suf = Pn(Pshuf(in, 1), inf).asStream;
	temp = suf.next;
	if(temp == ~last){
		arr = in; 
		val = arr.remove(temp);
		// arr.postln;
		temp = arr.choose;
		arr = arr.add(val);
	};
	~last = temp;
	temp;
};

~algorithm = { | algorithm |
	algorithm.postln;
	switch(algorithm,
		\aug, { // aug flag
			{
				~playAugSt.valueAction_(0); // first free aug synth
				~playOD.valueAction_(0); // then free OD synth
				~playAugSt.valueAction_(1) // finally PLAY AUG synth
			}.defer(0.0);
		},
		\od, { // od flag
			{
				~playAugSt.valueAction_(0); // first free aug synth
				~playOD.valueAction_(0); // then free OD synth
				~playOD.valueAction_(1); // finally PLAY AUG synth
			}.defer(0.0)
		}	
	);
};

~timer = { // time for each preset
	Ndef(\timer, { // count time
		| trigger = 0 |
		var trig, timer;
		trig = Impulse.kr(trigger);
		timer = Sweep.kr(trig);
	});

	fork{ // reg val to variable
		inf.do {
			~time = Ndef(\timer).bus.getSynchronous;
			~time = ~time.round(0.01);
			(0.01).wait;
		}
	};

};

~ovTimer = { // for overall experiment time	
	Ndef(\overallT, { // count time
		| trigger = 0 |
		var trig, timer;
		trig = Impulse.kr(trigger);
		timer = Sweep.kr(trig);
	});

	fork{ // reg val to variable
		inf.do {
			~overallTime = Ndef(\overallT).bus.getSynchronous;
			~overallTime = ~overallTime.round(0.01);
			//~overallTime.postln;
			(0.01).wait;
		}
	};

};

// load voice buffers
~voiceBuffersLoad = {~voiceMsg = Buffer.read(s, (~currPath +/+ "sounds/voiceMsg.wav").standardizePath);
	~voiceMsgEnd = Buffer.read(s, (~currPath +/+ "sounds/voiceMsgEnd.wav").standardizePath);
	~voiceMsgLPStart = Buffer.read(s, (~currPath +/+ "sounds/startLearningPhase.wav").standardizePath);
	~voiceMsgLPEnd = Buffer.read(s, (~currPath +/+ "sounds/endLearningPhase.wav").standardizePath);
	~voiceMsgLPRepeat = Buffer.read(s, (~currPath +/+ "sounds/learningPhaseRepeat.wav").standardizePath);
	~voiceMsgExpStart = Buffer.read(s, (~currPath +/+ "sounds/startExpInstructions.wav").standardizePath);
	~voiceMsgIntro = Buffer.read(s, (~currPath +/+ "sounds/intro.wav").standardizePath);
};
	

// INIT: environmental vars
~finalRating = Array(50); // preset rating values
~rating = nil;
~time = nil;
~participantID = 1; // participant ID init
~presetNum = -1; // preset number initialisation: GUI
~startFlag = false; // if experiment has started
~sample = 0;
~endFlag = false; // if last value stored in the array
~ampErrorFlag = false;
~globButton = 0;
~learningPhaseFlag = false;

// BUSES
~velBus = Bus.audio(s,1); // bus for triggering
~trigBus = Bus.audio(s,1); // bus for triggering
~gateBus = Bus.audio(s,1);
~specBus = Bus.audio(s,1); // bus for spectral modulation
~recBus = Bus.audio(s,1); 

// AUGMENTATION: allocate empty buffer 
~soundAugSt = Buffer.readChannel(s, ~currPath +/+ "sounds/silence.wav", channels:0);
// ONSET DETECTION: allocate empty buffer 
~soundOD = Array.fill(2, {Buffer.readChannel(s, ~currPath +/+ "sounds/silence.wav", channels:0)});

// ======= start preset initialisation ========
// defaults at startup

// onset detection
d.preGainOD = 50;
d.expThreshOD = -14;
d.threshLoOD = 1.0;
d.threshHiOD = 1.0;
d.cutoffOD = 220.0;
d.releaseTimeOD = 0.1;

// augmentation
d.preGainAugSt = 17;
d.expThreshAugSt = -49;
d.smoothing = 0.01;
d.cutoffAugSt = 320.0;
d.releaseTime = 0.25;
d.lpfAugSt = 19999;
d.amplitudeLPFLo = 100;
d.lpfHiLimit = 13000;
d.compressorThreshold = 2.dbamp;

// master
d.masterVol = (10.0.neg);
d.outputVolOD = 1.0;
d.outputVolAugSt = 1.0;
d.rateLo = 0.7;
d.rateHi = 1.3;

// ======= end of preset initialisation =======

//a = s.volume; // server vol


fork{
	0.1.wait;
	s.volume = d.masterVol; // set init master vol
	0.15.wait;
	s.sync;
	~voiceBuffersLoad.value();
	0.5.wait;
	s.sync;
	
	// voice message playback synth
	SynthDef(\voicePlayback,{
		| bufnum, trigger = 0, amp = 0.0, gate = 0 |
		var sig = PlayBuf.ar(
			numChannels:1,
			bufnum:bufnum,
			rate:BufRateScale.kr(bufnum),
			trigger: trigger,
			loop:0,
			doneAction:0
		); // play sample
		sig = sig * EnvGen.ar(Env.adsr(0.0, 0.2, 0.7, 0.01), gate, doneAction:2);
		Out.ar(1, sig * amp * 0.1)
	}).add;

	s.sync;
	
	// init synth variable
	e.voicePlayback = Synth(\voicePlayback, \gate,0);

	// for recording
	SynthDef(\rec, {
		var in;
		in = Mix(SoundIn.ar((0..23)));
		Out.ar(~recBus, in);
	}).add;
	s.sync;
	Synth(\rec, addAction:\addToTail);

};

"INIT FILE LOADED".postln;	

