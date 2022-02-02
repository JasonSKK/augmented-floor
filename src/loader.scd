s.waitForBoot{

	s.freeAll;
	
	s = Server.local;
	s.options.blockSize = 64;
	s.options.numBuffers = 100; // increase in case of overload (bufs are freed anyway)
	s.options.inDevice_("Digiface USB (23879888)");
	s.options.numInputBusChannels.postln;
	s.options.numInputBusChannels = 24;
	s.options.numOutputBusChannels = 2;
	s.options.numOutputBusChannels.postln;
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


