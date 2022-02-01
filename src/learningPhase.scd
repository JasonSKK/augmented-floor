~learningPhase =
{
fork{
	|i|
	var order;
	i = 0; // set preset counter to 0
	order =
	// learning phase order
	~soundCollection =
	[
		["empty", 0],
		[[2, \aug], [5, \aug], [1, \aug], [7, \aug], [3, \aug], [8, \aug], [6, \aug], [4, \aug],  [7, \od], [4, \od], [1, \od], [2, \od], [5, \od], [6, \od], [8, \od], [3, \od]].scramble; // randomise order for each participant
	];
	
	17.do{
		var preset, algorithm, looping;
		if(
			i <= (~soundCollection[1].size - 1), {
				~soundOD.collect{|i| i.free}; // free Buffer collection -- OD
				~soundAugSt.free; // free Buffer collection -- AUG
				
				preset = ~soundCollection[1][i][0];
				algorithm = ~soundCollection[1][i][1];
				defer{~preset.valueAction_(preset)}; // set preset
				~algorithm.value(algorithm); // set algorithm of preset
				"ekos".postln;
			},{
				//~learningPhase.stop();
				defer{~preset.valueAction_(0); // set preset to number 0 -- silence
					~playOD.valueAction_(0); // switch off OD button
					~playAugSt.valueAction_(0); // switch off AUG button
					"alekos".postln;
				};
				{"LEARNING PHASE ENDED".postln;}.defer(0.5); // post
				// 
				e.voicePlayback.set(\gate, 0); // release playing synth
				e.voicePlayback = Synth(\voicePlayback, [\gate, 1, \bufnum, ~voiceMsgLPEnd, \amp,1]); // play new one
			}
		);
		i = i + 1; // next preset -- learning phase collection
		1.wait; // wait 6 sec for the participant to try out the preset
	};
	
};

};

"LEARNING PHASE PATCH LOADED".postln;