s.waitForBoot{

	s.freeAll;
	
	s = Server.local;
	s.options.blockSize = 64;
	o = Server.default.options;
	o.inDevice_("Digiface USB (23879888)");
	o.numInputBusChannels.postln;
	o.numInputBusChannels = 24;
	o.numOutputBusChannels = 2;
	o.numOutputBusChannels.postln;
	s.options.numWireBufs = 48;
	s.options.hardwareBufferSize = 64;
	s.reboot;

	7.wait;
	s.sync;
	
	// current dir
	~currPath = Document.current.dir;
	
	// test
	//play{SinOsc.ar()*0.1!2 * Env.perc.kr(doneAction:2)};

	// show
	0.25.wait;
	
	// INIT: load functions, buffer alloc, dictionaries
	s.sync;
	
	(~currPath +/+ "setup.scd").standardizePath.load;
	0.2.wait;

	s.sync;

	// Preset Order Patch load
	(~currPath +/+ "presetOrder.scd").standardizePath.load;
	0.2.wait;
	
	// Onset Detection Patch load
	s.sync;
	(~currPath +/+"onsetDetection.scd").standardizePath.load;
	0.2.wait;
	// load sound0 empty buffer
	s.sync;
	(~currPath +/+"/configs/sound0.scd").standardizePath.load;
	0.2.wait;

	// Augmentation Patch load
	s.sync;
	(~currPath +/+"augmented-steps.scd").standardizePath.load;
	0.2.wait;

	// GUI load
	s.sync;
	(~currPath +/+"interface.scd").standardizePath.load;
	0.2.wait;

	// Touch OSC Setup load
	s.sync;
	(~currPath +/+"touchOsc.scd").standardizePath.load;
	0.2.wait;

	// Learning Phase load
	s.sync;
	(~currPath +/+"learningPhase.scd").standardizePath.load;
	0.2.wait;
	
	// Limiter 
	Safety.setLimit(0.9);
	StageLimiter.activate;

	// server meter
	s.meter;
};


