//gravel

// load preset config -- update dict
// onset detection
d.preGainOD = 80;
d.expThreshOD = -14;
d.threshLoOD = 1.0;
d.threshHiOD = 1.0;
d.cutoffOD = 220.0;
d.releaseTimeOD = 0.1;

// augmentation
d.preGainAugSt = 17;
d.expThreshAugSt = 51.neg;
d.smoothing = 0.01;
d.cutoffAugSt = 320.0;
d.releaseTime = 0.1818;
d.lpfAugSt = 19999;
d.amplitudeLPFLo = 7000;

// master
d.masterVol = (18.0.neg);
d.outputVolOD = 0.4;
d.outputVolAugSt = 0.4;
// rate modulation OFF
d.rateLo = 1.0; 
d.rateHi = 1.0;


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

//onset detection
~soundOD = [
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/gravel_var01.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/gravel_var02.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/gravel_var03.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/gravel_var04.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/gravel_var05.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/gravel_var06.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/gravel_var07.wav", channels:0),
];

//augmentation
//labeled as underbrush???
~soundAugSt = Buffer.readChannel(s, ~currPath +/+ "/sounds/augmentation-sounds/gravel.wav", channels:0);
fork{// needs some time to load n set buffer
	0.25.wait;
	e.augmentedSteps.set(\bufnum, ~soundAugSt, \cutoffLPF, d.amplitudeLPFLo);
};


"Sound 8 is loaded -- gravel".postln;