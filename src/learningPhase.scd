~learningPhase =
{
fork{
	|i|
	var order;
	// play introduction voice
	e.voicePlayback.set(\gate, 0); // release playing synth
	e.voicePlayback = Synth(\voicePlayback, [\gate, 1, \bufnum, ~voiceMsgLPStart, \amp,1]); // play new one

	8.wait;
	
	i = 0; // set preset counter to 0
	
	// learning phase order
	order =
	[
		["empty", 0],
		[ [2, \aug], [5, \aug], [1, \aug], [7, \aug], [3, \aug], [8, \aug], [6, \aug], [4, \aug], [7, \od], [4, \od], [1, \od], [2, \od], [5, \od], [6, \od], [8, \od], [3, \od]].scramble; // randomise order for each participant
	];
	
	17.do{
		var preset, algorithm, looping;
		if(
			i <= (order[1].size - 1), {
				~soundOD.collect{|i| i.free}; // free Buffer collection -- OD
				~soundAugSt.free; // free Buffer collection -- AUG
				
				preset = order[1][i][0];
				algorithm = order[1][i][1];
				defer{~preset.valueAction_(preset)}; // set preset
				~algorithm.value(algorithm); // set algorithm of preset
			},{
				//~learningPhase.stop();
				defer{~preset.valueAction_(0); // set preset to number 0 -- silence
					~playOD.valueAction_(0); // switch off OD button
					~playAugSt.valueAction_(0); // switch off AUG button
				};
				{"LEARNING PHASE ENDED".postln;}.defer(0.5); // post
				//
				2.wait;
				// MSG1 "THE LEARNIG PHASE HAS ENDED"
				e.voicePlayback.set(\gate, 0); // release playing synth
				e.voicePlayback = Synth(\voicePlayback, [\gate, 1, \bufnum, ~voiceMsgLPEnd, \amp,1]); // play new one
				5.wait; // wait for msg 1 to finish
				// MSG2 "LEARNING PHASE REPEAT"
				e.voicePlayback.set(\gate, 0);
				e.voicePlayback = Synth(\voicePlayback, [\gate, 1, \bufnum, ~voiceMsgLPRepeat, \amp,1]); // play new one

				// stop all synths
				defer{~preset.valueAction_(0); // set preset to number 0 -- silence
					~playOD.valueAction_(0); // switch off OD button
					~playAugSt.valueAction_(0); // switch off AUG button
				};
			}
		);
		i = i + 1; // next preset -- learning phase collection
		1.wait; // wait 5 sec for the participant to try out the preset
	};
	
};

};

"LEARNING PHASE PATCH LOADED".postln;