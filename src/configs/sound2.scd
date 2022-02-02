// giant steps

// load preset config -- update dict
// onset detection
d.preGainOD = 90;
d.expThreshOD = 14.neg;
d.threshLoOD = 1.0;
d.threshHiOD = 31.neg;
d.cutoffOD = 270.0;
d.releaseTimeOD = 0.9191;

// augmentation
d.preGainAugSt = 25;
d.expThreshAugSt = 51.neg;
d.smoothing = 0.01;
d.cutoffAugSt = 320.0;
d.releaseTime = 0.3030;
d.lpfAugSt = 19999;
d.amplitudeLPFLo = 1000;
d.lpfHiLimit = 13000;
d.compressorThreshold = 2;

// master
d.masterVol = (18.0.neg);
d.outputVolOD = 0.6;
d.outputVolAugSt = 0.45;
// rate modulation ON
d.rateLo = 0.7; 
d.rateHi = 1.3;


// set to GUI
{
	// ONSET DETECTION SETTINGS
	~preGain.valueAction_(d.preGainOD/5);
	~expanderThresh.valueAction_(d.expThreshOD);
	~thresLo_NB.valueAction_(d.threshLoOD);
	// ~thresHi_NB.valueAction_(d.threshHiOD);
	~cutoffHPF.valueAction_(d.cutoffOD);
	~releaseTimeOD.valueAction_(d.releaseTimeOD);
	// OD: output volume
	~outputVolOD_NB.valueAction_(d.outputVolOD);

	// AUGMENTATION SETTINGS
	~gainAugSt_NB.valueAction_(d.preGainAugSt); // pre gain 
	~expThreshAugSt_NB.valueAction_(d.expThreshAugSt); // aug exp thresh
	~releaseTimeAugSt.valueAction_(d.releaseTime); // release time
	~smoothingAugSt_NB.valueAction_(d.smoothing);
	// AUG: output volume
	~outputVolAugSt_NB.valueAction_(d.outputVolAugSt);
}.defer(0.0);

// onset detection
~soundOD = [
	Buffer.read(s, ~currPath +/+ "/sounds/onset-detection/giant-steps_var01.wav"),
	Buffer.read(s, ~currPath +/+ "/sounds/onset-detection/giant-steps_var02.wav"),
	Buffer.read(s, ~currPath +/+ "/sounds/onset-detection/giant-steps_var03.wav"),
	Buffer.read(s, ~currPath +/+ "/sounds/onset-detection/giant-steps_var04.wav"),
];

// augmentation
~soundAugSt = Buffer.readChannel(s, ~currPath +/+ "/sounds/augmentation-sounds/giant-step-steady-state.wav", channels:0);
fork{// needs some time to load n set buffer
	0.25.wait;
	e.augmentedSteps.set(\bufnum, ~soundAugSt, \cutoffLPF, d.amplitudeLPFLo, \compThresh, d.compressorThreshold, \lpfHiLimit, d.lpfHiLimit);
};


"Sound 2 is loaded -- giant steps".postln;