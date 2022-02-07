//steps on Mars

Buffer.freeAll;
~voiceBuffersLoad.value();

// load preset config -- update dict
// onset detection
d.preGainOD = 90;
d.expThreshOD = 8.neg;
d.threshLoOD = -3.787878787878;
d.threshHiOD = 10.0;
d.cutoffOD = 425.0;
d.releaseTimeOD = 0.1;

// augmentation
d.preGainAugSt = 18;
d.expThreshAugSt = 51.neg;
d.smoothing = 0.01;
d.cutoffAugSt = 320.0;
d.releaseTime = 0.1818;
d.lpfAugSt = 19999;
d.amplitudeLPFLo = 1000;
d.lpfHiLimit = 13000;
d.compressorThreshold = 2;

// master
//d.masterVol = d.masterVol;
d.outputVolOD = 0.5;
d.outputVolAugSt = 0.08;
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
	
//onset detection
~soundOD = [
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/stepsOnMars_var01.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/stepsOnMars_var02.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/stepsOnMars_var03.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/stepsOnMars_var04.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/stepsOnMars_var05.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/stepsOnMars_var06.wav", channels:0),
	Buffer.readChannel(s, ~currPath +/+ "/sounds/onset-detection/stepsOnMars_var07.wav", channels:0),
];

//augmentation
//labeled as underbrush???
~soundAugSt = Buffer.readChannel(s, ~currPath +/+ "/sounds/augmentation-sounds/stepsOnMars.wav", channels:0);
fork{// needs some time to load n set buffer
	0.05.wait;
	e.augmentedSteps.set(\bufnum, ~soundAugSt, \cutoffLPF, d.amplitudeLPFLo, \compThresh, d.compressorThreshold, \lpfHiLimit, d.lpfHiLimit);
};

"Sound 7 is loaded -- steps on Mars".postln;