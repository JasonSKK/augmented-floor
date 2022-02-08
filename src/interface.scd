Window.closeAll;
s.waitForBoot({

    var w, k;

    w = Window("Augmented steps").alwaysOnTop_(false);//Setting Up the Window
    w.bounds_(Rect(0, 150, 600, 730));
    w.view.background_(Color(0.0,0.2,0.3,0.86));//Color(0.2, 0.2, 0.2, 0.66));
    w.front;

	//Sliders
    k = Array.fill(15, {Slider(w, Rect(0, 100, 100, 50))});

	// outputVol Onset Detection
	k[2].bounds_(Rect(380, 640, 150, 20)).value_(d.masterVol.linlin(-90.0,0.0,0.0,1.0)).knobColor = Color(0.8,0.0,0.0); //master vol
	k[13].bounds_(Rect(380, 500, 150, 20)).value_(d.outputVolOD.linlin(0.0,10.0,0.0,1.0)); // output volume
	k[14].bounds_(Rect(380, 560, 150, 20)).value_(d.outputVolAugSt.linlin(0.0,10.0,0.0,1.0)); // output volume

	// ONSET DETECTION	
    k[0].bounds_(Rect(110, 40, 88, 20)).value_(d.preGainOD/100);//pregain
    k[1].bounds_(Rect(110, 80, 88, 20)).value_(d.expThreshOD.linlin(-90,0.0,0.0,1.0));//expander thresh	
    k[3].bounds_(Rect(400, 40, 88, 20)).value_(d.cutoffOD.linlin(1.0,4000,0.0,1.0)); //cutoffHPF
	k[4].bounds_(Rect(110, 120, 88, 20)).value_(d.threshLoOD.linlin(-900,10.0,0.0,1.0));//thresLo

	// 0 and 0 size bounds
	k[5].bounds_(Rect(110, 160, 0,  0)).value_(d.threshHiOD.linlin(-900,10.0,0.0,1.0));//threshHi
	
	k[11].bounds_(Rect(400, 80, 88, 20)).value_(d.releaseTimeOD.linlin(0.0,4.0,0.0,1.0));//releaseTime (amplitude) O.D.

	// augmentation
	k[6].bounds_(Rect(110, 260, 88, 20)).value_(d.preGainAugSt/80);// pregain
	k[7].bounds_(Rect(110, 300, 88, 20)).value_(d.expThreshAugSt.linlin(-90.0,0.0,0.0,1.0));// expander thresh
	k[8].bounds_(Rect(400, 260, 88, 20)).value_(d.smoothing);// smoothing factor
	k[9].bounds_(Rect(400, 300, 88, 20)).value_(d.cutoffAugSt.linlin(1.0,4000.0,0.0,1.0));// cutoff HPF
	k[10].bounds_(Rect(110, 340, 88, 20)).value_(d.releaseTime.linlin(0.0,2.0,0.0,1.0));// releaseTime (amplitude)
	k[12].bounds_(Rect(400, 340, 88, 20)).value_(d.lpfAugSt.linlin(1.0,20000.0,0.0,1.0));// LPF

    k[0].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 0.0, 100.0);
		e.od.set(\preGain, val);
		[\preGainFactor, val].postln;
		d.preGainOD = val; // upd dictionary
		~preGain.value_(val);
    });

	k[1].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, -90.0, 0.0);
		e.od.set(\expThresh, val);
		[\expanderThreshold, val, "db"].postln;
		d.expThreshOD = val; // upd dictionary
		~expanderThresh.value_(val);
	});

	k[2].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, -90.0, 0.0);
		s.volume = val;
		s.volume.postln;
		[\masterOut, val, "db"].postln;
		d.masterVol = val; // upd dictionary
		~masterOut_NB.value_(val);
	});

	k[3].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 1.0, 4000.0);
		e.od.set(\cutoff, val);
		[\cutoffHPF, val, "Hz"].postln;
		d.cutoffOD = val; // upd dictionary
		~cutoffHPF.value_(val);
	});

	k[4].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, -900.0, 10.0);
		e.od.set(\threshLo, val);
		[\thresLo, val, "db"].postln;
		d.threshLoOD = val; // upd dictionary
		~thresLo_NB.value_(val);
	});
	
	/*
k[5].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, -900.0, 10.0);
		e.od.set(\thresHi, val, "db");
		[\thresLo, val, "db"].postln;
		d.threshHiOD = val; // upd dictionary
		~thresHi_NB.value_(val);
		});
	*/

	k[6].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 0.0, 80.0);
		e.augmentedSteps.set(\gain, val);
		[\preGainFactor, val].postln;
		d.preGainAugSt = val; // upd dictionary
		~gainAugSt_NB.value_(val);
	});

	k[7].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, -90.0, 0.0);
		e.augmentedSteps.set(\expThresh, val);
		[\expanderThreshold, val, "db"].postln;
		d.expThreshAugSt = val; // upd dictionary
		~expThreshAugSt_NB.value_(val);
	});

	k[8].action_({
        |obj|
		var val;
		val = obj.value;
		e.augmentedSteps.set(\smoothing, val);
		[\smoothing, val, "ms"].postln;
		d.smoothing = val; // upd dictionary
		~smoothingAugSt_NB.value_(val);
	});

	k[9].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 1.0, 4000.0);
		e.augmentedSteps.set(\cutoff, val);
		[\cutoffHPF, val, "Hz"].postln;
		d.cutoffAugSt = val; // upd dictionary
		~cutoffHPFAugSt.value_(val);
	});

	k[10].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 0.0, 2.0);
		e.augmentedSteps.set(\releaseTime, val);
		[\releaseTime, val, "sec"].postln;
		d.releaseTime = val; // upd dictionary
		~releaseTimeAugSt.value_(val);
	});

	k[11].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 0.0, 4.0);
		e.od.set(\releaseTime, val);
		[\releaseTime, val, "sec"].postln;
		d.releaseTimeOD = val; // upd dictionary
		~releaseTimeOD.value_(val);
	});

	k[12].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 1.0, 20000.0);
		e.augmentedSteps.set(\lpf, val);
		[\lpf, val, "sec"].postln;
		d.lpfAugSt = val; // upd dictionary
		~lpfAugSt_NB.value_(val);
	});
	
	k[13].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 0.0, 10.0);
		//e.augmentedSteps.set(\outputVol, val);
		e.sound.set(\outputVol, val);
		e.od.set(\outputVol, val);
		[\outputVolOD, val, "mul factor"].postln;
		d.outputVolOD = val; // upd dictionary
		~outputVolOD_NB.value_(val);
	});

	k[14].action_({
        |obj|
		var val;
		val = obj.value.linlin(0.0, 1.0, 0.0, 10.0);
		e.augmentedSteps.set(\outputVol, val);
		[\outputVolAugSt, val, "mul factor"].postln;
		d.outputVolAugSt = val; // upd dictionary
		~outputVolAugSt_NB.value_(val);
	});

	
	
	//====================TEXT=======================================
	~text = Array.fill(19, {StaticText (w , Rect (150, 175, 100, 100))
        .string_("expander thesh")
        .font_(Font("Times New Roman", 14))
        .align_(\center)
        .background_(Color.white)
        .stringColor_(Color.black)});

	
	// slider titles

	//onset detection
    ~text[1].bounds_(Rect(10, 40, 90, 20)).string_("Pre Gain");
    ~text[2].bounds_(Rect(10, 80, 90, 20));
	~text[4].bounds_(Rect(305, 40, 90, 20)).string_("cutoff HPF");
	~text[5].bounds_(Rect(10, 120, 90, 20)).string_("OD threshold");
	~text[6].bounds_(Rect(10, 160, 0, 0)).string_("thresHi"); // size bounds 0
	~text[14].bounds_(Rect(305, 80, 90, 20)).string_("ReleaseTime");

	// master slider
	~text[3].bounds_(Rect(380, 610, 210, 20)).string_("Master Vol").background_(Color(0.8,0.8,0.8));
	// preset vol
	~text[17].bounds_(Rect(380, 470, 210, 20)).string_("Output Vol Onset Detection").background_(Color.yellow(0.8));
	~text[18].bounds_(Rect(380, 530, 210, 20)).string_("Output Vol Augmentation").background_(Color.red(0.8));
	
	// control sections -labels-
	~text[0].bounds_(Rect(10, 10, 580, 20)).string_("Onset Detection").background_(Color.yellow(0.8));
	~text[7].bounds_(Rect(10, 440, 580, 20)).string_("Preset Selection");
	~text[8].bounds_(Rect(10, 220, 580, 20)).string_("Agumentation").background_(Color.red(0.8));

	//augmentation
	~text[9].bounds_(Rect(10, 260, 90, 20)).string_("Pre Gain");
	~text[10].bounds_(Rect(10, 300, 90, 20)).string_("expander thresh");
	~text[11].bounds_(Rect(305, 260, 90, 20)).string_("smoothing");
	~text[12].bounds_(Rect(305, 300, 90, 20)).string_("cutoff HPF");
	~text[13].bounds_(Rect(10, 340, 90, 20)).string_("ReleaseTime");
	~text[16].bounds_(Rect(305, 340, 90, 20)).string_("LPF cutoff");
	
	//
	~text[15].bounds_(Rect(10, 635, 380, 30)).string_(" ").font_(Font("Times New Roman", 15)).background_(Color.clear).stringColor_(Color.white(0.2));
	
	//============== Onset Detection ===================
	// pre gain
	~preGain = NumberBox(w, Rect(200, 40, 50, 20))
	.value_(50)
	.clipLo_(0.0)
	.clipHi_(100.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(2)
	.action_({
		arg obj;
		var val;
		val = obj.value.linlin(0.0, 1.0, 0.0, 100.0);
		k[0].valueAction_(obj.value.linlin(0.0,20.0,0.0,1.0));
	});

	// expander threshold
	~expanderThresh = NumberBox(w, Rect(200, 80, 50, 20))
	.value_(14.neg)
	.clipLo_(90.0.neg)
	.clipHi_(0.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(0)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[1].valueAction_(obj.value.linlin(-90.0,0.0,0.0,1.0));
	});

	// master volume out
	~masterOut_NB = NumberBox(w, Rect(540, 640, 50, 20))
	.value_(d.masterVol)
	.clipLo_(-90.0)
	.clipHi_(0.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(4)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[2].valueAction_(val.dbamp);
	});

	// cutoff HPF
	~cutoffHPF = NumberBox(w, Rect(490, 40, 50, 20))
	.value_(220)
	.clipLo_(1.0)
	.clipHi_(4000.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(1)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[3].valueAction_(val.linlin(1.0,4000,0.0,1.0));
	});

	// thres Lo schmitt
	~thresLo_NB = NumberBox(w, Rect(200, 120, 50, 20))
	.clipLo_(-900.0)
	.clipHi_(10.0)
	.value_(d.threshLoOD)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(4)
	.action_({
		arg obj;
		var val;
		val = obj.value.linlin(0.0,1.0,-900.0,10.0);
		k[4].valueAction_(obj.value.linlin(-900.0, 10.0, 0.0, 1.0));
	});
	
	/*
	// thres Hi schmitt
	~thresHi_NB = NumberBox(w, Rect(200, 160, 50, 20))
	.value_(d.threshHiOD)
	.clipLo_(-900.0)
	.clipHi_(10.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(4)
	.action_({
		arg obj;
		var val;
		val = obj.value.linlin(0.0,1.0,-900.0,10.0);
		k[5].valueAction_(obj.value.linlin(-900.0, 10.0, 0.0, 1.0));
	});
	*/
	
	//============== Augmentation ======================

	// pre gain A.S.
	~gainAugSt_NB = NumberBox(w, Rect(200, 260, 50, 20))
	.value_(d.preGainAugSt)
	.clipLo_(0.0)
	.clipHi_(80.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(0)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[6].valueAction_(obj.value.linlin(0.0,80.0,0.0,1.0));
	});

	// expander threshold A.S.
	~expThreshAugSt_NB = NumberBox(w, Rect(200, 300, 50, 20))
	.value_(45.neg)
	.clipLo_(90.0.neg)
	.clipHi_(0.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(0)
	.action_({
		arg obj;
		var val;
		val = obj.value;	k[7].valueAction_(obj.value.linlin(-90.0,0.0,0.0,1.0));
	});

	// smoothing A.S.
	~smoothingAugSt_NB = NumberBox(w, Rect(490, 260, 50, 20))
	.value_(d.smoothing)
	.clipLo_(0.0)
	.clipHi_(1.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(4)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[8].valueAction_(val);
	});

	// cutoff HPF A.S.
	~cutoffHPFAugSt = NumberBox(w, Rect(490, 300, 50, 20))
	.value_(220)
	.clipLo_(1.0)
	.clipHi_(4000.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(1)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[9].valueAction_(val.linlin(1.0,4000,0.0,1.0));
	});
	
	// Release Time amplitude A.S.
	~releaseTimeAugSt = NumberBox(w, Rect(200, 340, 50, 20))
	.value_(d.releaseTime)
	.clipLo_(0.0)
	.clipHi_(2.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(4)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[10].valueAction_(val.linlin(0.0,2.0,0.0,1.0));
	});

	~lpfAugSt_NB = NumberBox(w, Rect(490, 340, 50, 20))
	.value_(d.lpfAugSt)
	.clipLo_(1.0)
	.clipHi_(20000.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(0)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[12].valueAction_(val.linlin(1.0,20000.0,0.0,1.0));
	});

	// Release Time amplitude O.D.
	~releaseTimeOD = NumberBox(w, Rect(490, 80, 50, 20))
	.value_(d.releaseTimeOD)
	.clipLo_(0.0)
	.clipHi_(4.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(4)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		k[11].valueAction_(val.linlin(0.0,4.0,0.0,1.0));
	});

	~outputVolOD_NB = NumberBox(w, Rect(540, 500, 50, 20))
	.value_(d.outputVolOD)
	.clipLo_(0.0)
	.clipHi_(10.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(2)
	.action_({
		arg obj;
		var val;
		val = obj.value;
		val = obj.value.linlin(0.0, 10.0, 0.0, 1.0);
		k[13].valueAction_(val);
	});

	~outputVolAugSt_NB = NumberBox(w, Rect(540, 560, 50, 20))
	.value_(d.outputVolAugSt)
	.clipLo_(0.0)
	.clipHi_(10.0)
	.font_(Font ("Times New Roman",16))
	.background_ (Color.new255(240, 240, 255))
	.decimals_(2)
	.action_({
		arg obj;
		var val;
		val = obj.value.linlin(0.0, 10.0, 0.0, 1.0);
		k[14].valueAction_(val);
	}); 


	// PRESET SELECTION
	~preset = EZNumber(w, Rect(10,480,180,25), "  Preset Num", ControlSpec(0, 1000, step:1), labelWidth:120)
	.font_(Font("Times New Roman", 14))
	.setColors(Color(1.0,1.0,0.7,0.5), Color.black)
	.action_({ |ez|
		var temp, button;
		fork{
			// load preset
			~presetNum = ez.value;
			
			s.sync;
			{(~currPath +/+ "/configs/sound"++~presetNum.asInteger++".scd").standardizePath.load}.defer(); // load preset file	
			button = ~globButton;//{~playOD.value}.defer(0.0).value;
			s.sync;
			if (button == 0, {
				e.sound.free; // free buf playback synth
				0.1.wait;
				~synthReg.value; // reload synthdef
			},{
				e.sound.free; // free buf playback synth
				0.1.wait;
				~synthReg.value; // reload synthdef
				0.1.wait;
				e.sound = Synth(\presetPlayback, args:[
					\bufCollection, ~soundOD,
					\masterAmp, 1,
					\outputVol, d.outputVolOD,
					\rateLo, d.rateLo,
					\rateHi, d.rateHi
				], addAction: \addToTail); // start playback synth
			});
			Ndef(\timer).clear; // stop var ~time register routine
			~timer.value(); // initialise - run timer
		};
	});

	// PLAY button O.D.
	~playOD = Button(w, Rect(305,155,250,30)).states_([
		["PLAY OD", Color.red(0.6), Color(0.7,0.7,0.7)],
		["STOP OD" , Color.white(1.0), Color.green(0.6)],
	]).font_(Font("Times New Roman", 12)).value_(0).action_({
		|obj|
		
		~globButton = obj.value;
		if(obj.value == 1, {
			e.sound.free; // free buf playback synth
			e.od.free; // free OD synth
			fork{
				s.sync;
				(~currPath +/+ "/configs/sound"++~presetNum.asInteger++".scd").standardizePath.load; // load preset from OD preset dir according to the presetNum value
				s.sync;
			};

			e.od = Synth(\onsetDetection, [ // set parameters for OD synth
				\preGain, d.preGainOD,
				\expThresh, d.expThreshOD,
				\threshLo, d.threshLoOD,
				\threshHi, d.threshHiOD,
				\cutoff, d.cutoffOD,
				\releaseTime, d.releaseTimeOD,
				\outputVol, d.outputVolOD,
				\rateLo, d.rateLo,
				\rateHi, d.rateHi,
			], addAction:\addToHead);
			e.sound = Synth(\presetPlayback, args:[\masterAmp, 1, \bufCollection, ~soundOD, \outputVol, d.outputVolAugSt], addAction: \addToTail); // start playback synth
		},{

			e.sound.free; // free buf playback synth
			e.od.free; // free OD synth
		});
	});
	
	// PLAY button Augmentation
	~playAugSt = Button(w, Rect(305,385,250,30)).states_([
		["PLAY Augmentation", Color.red(0.6), Color(0.7,0.7,0.7)],
		["STOP Augmentation" , Color.white(1.0), Color.green(0.6)],
	]).font_(Font("Times New Roman", 12)).action_({
		|obj|
		// ~soundOD.collect{|i| i.free}; // free Buffer collection -- OD
		// ~soundAugSt.free; // free Buffer -- AUG
		
		if(obj.value == 1, {
			(~currPath +/+ "/configs/sound"++~presetNum.asInteger++".scd").standardizePath.load; // load preset from aumgnetation-sounds preset dir according to the presetNum value
			e.augmentedSteps = Synth(\augmentedSteps, [ // set paratmeters to the synth
				\preGain, d.preGainAugSt,
				\expThresh, d.expThreshAugSt,
				\smoothing, d.smoothing,
				\cutoff, d.cutoffAugSt,
				\releaseTime, d.releaseTime,
				\outputVol, d.outputVolAugSt,
				\rateLo, d.rateLo,
				\rateHi, d.rateHi,
				\compThresh, d.compressorThreshold,
				\lpfHiLimit, d.lpfHiLimit,
				\bufnum, ~soundAugSt
			]);
		},{
			e.augmentedSteps.free; // free synth when aumentation button is OFF state
		});
	});

	// Participant ID
	~participants = EZNumber(w, Rect(10,530,180,25), "  Participant ID ",ControlSpec(0, 1000, step:1), initVal:0, labelWidth: 120)
	.font_(Font("Times New Roman", 14))
	.setColors(Color(0.6,0.2,0.3), Color.black)
	.action_({ |ez|
		var file, path;
		fork{
			// deactivate OD & AUG play button
			{
				~playAugSt.valueAction_(0); // first free aug synth
				~playOD.valueAction_(0); // then free OD synth
			}.defer(0.0);
			
			path = (~currPath +/+"/rating" +/+ "participant"++~participantID++".txt").standardizePath; // specify path to write the file for each participant, e.g. participant1.txt - 2 ... 3 ... etc.
			0.2.wait;
			s.sync;
			file = File(path,"w");
			s.sync;
			file.write(~finalRating.asCompileString+~overallTime.asCompileString); // write array w ratings to the file
			s.sync;
			file.close;
			["RATINGS FOR EACH PRESET WRITTEN TO DISK", ~finalRating.collect({|i| i[3]}) ].postln; // post only the rating values
			~participantID = ez.value.asInteger; // glob var upd
			[\participantID, "VALUE UPDATE:"+~participantID].postln; // post participantID VALUE
			0.5.wait;
			~finalRating = Array(50); // empty rating values for the next participant
			~sample = 0;
			// {~preset.valueAction_(0)}.defer(0.0); // when new participant invited set prest to zero
			{~preset.valueAction_(~soundCollection[~participantID][~sample][0])}.defer(0.0); // start with the first sound of the LATIN SQUARE ARRAY
			~endFlag = false;

			~algorithm.value(~soundCollection[~participantID][~sample][1]); // switch select aug or od

			Ndef(\overallT).clear; // stop var ~time register routine
			~ovTimer.value(); // initialise - run OVERALL timer
		};
	});

	// START experiment button
	~start = Button(w, Rect(10,570,250,30)).states_([
		["START EXPERIMENT", Color.white, Color.red(0.4)],
		["STOP" , Color.red, Color.gray(0.8)],
	]).font_(Font("Times New Roman", 12)).action_({
		|obj|
		obj.postln;

		if(obj.value == 1,{
		//play voice msg 
		e.voicePlayback.set(\gate, 0); // release playing synth
		e.voicePlayback = Synth(\voicePlayback, [\gate, 1, \bufnum, ~voiceMsgExpStart, \amp,3]); // play new one
		~sample = 0; // set sample to first sound when 2nd participant
		{~preset.valueAction_(~soundCollection[~participantID][~sample][0])}.defer(0.0); // start with the first sound of the LATIN SQUARE ARRAY
		~algorithm.value(~soundCollection[~participantID][~sample][1]); // switch select aug or od according to the symbol value within the latin square array
			fork{9.wait; s.record(~currPath +/+"/rating/recs/participant"++~participantID++".wav", ~recBus, 1)}; // start recording file after instructions voice msg
		},{
			s.stopRecording; // stop rec
		})
	});

	// learning phase button
	~learningPhButton =  Button(w,
		Rect(10,630,250,30)).states_([
	["LEARNING PHASE", Color.white, Color.cyan(0.4)],
			/*["STOP LEARNING PHASE" , Color.cyan(0.6), Color.gray(0.8)],*/
	]).font_(Font("Times New Roman", 12)).action_({
		|obj|
		//if(obj.value == 1, {
			~learningPhase.value();
		//},{
		//~learningPhase.stop;
		//});
	});

	// INSTRUCTIONS Button
	~instructions = Button(w, Rect(10,690,250,30)).states_([
		["PLAY INSTRUCTIONS", Color.yellow(1.0), Color(0.0,0.3,0.4)],
		//["STOP OD" , Color.white(1.0), Color.red(0.6)],
	]).font_(Font("Times New Roman", 12)).value_(0).action_({
		|obj|
		
		e.voicePlayback.set(\gate, 0); // release playing synth
		e.voicePlayback = Synth(\voicePlayback, [\gate, 1, \bufnum, ~voiceMsgIntro, \amp,3]); // play new one	
	});

		
});

"GUI PATCH LOADED".postln;
