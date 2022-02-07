OSCdef(\rating, {
	| msg, time, addr, recvPort |
	var val;
	val = msg[1];
	val = val.round(0.05); // round to the closest 0.0 or 0.5
	val.postln;
	if(~sample <= 15){
		~rating = val;
	};
	[\rating, val].postln;
}, path: '/control/ratingSlider');

OSCdef(\next, {
	| msg, time, addr, recvPort |
	var val, file, path, next, presetNum, algorithm, tempRating, algoFlag;
	val = msg[1];
	tempRating = ~rating;
	presetNum = (~soundCollection[~participantID][~sample][0]);
	algoFlag = (~soundCollection[~participantID][~sample][1]);
	if((~rating.notNil) && (~presetNum > 0),{
		if(val == 1,{ // next sound button
			if (~sample >= (~soundCollection[~participantID].size - 1),{
				"all samples were completed -- invite next participant".postln;
				if(~endFlag == false){ // store only once

					~finalRating.add([\participantID, ~participantID, algoFlag, "preset"++presetNum.asSymbol, ~rating]); // will be evaluated only for the first sample
					["RATING STORED", "PRESET", algoFlag, presetNum, \value, ~rating].postln; // report msg
					~rating = nil; // reset rating var (for the voiceMsg playback) after a while
					~endFlag = true; // the last val was stored
					
					// end of the experiment notification playback
					e.voicePlayback.set(\gate, 0); // release playing synth
					e.voicePlayback = Synth(\voicePlayback, [\gate, 1, \bufnum, ~voiceMsgEnd, \amp,3]); // play new one
					
				};
				{
					~preset.valueAction_(0); // set preset back to 0 -- silence
					// deactivate OD & AUG play button
					~playAugSt.valueAction_(0); // first free aug synth
					~playOD.valueAction_(0); // then free OD synth
				}.defer(0.0);
			},{

				if(~sample <= 15){
					~finalRating.add([\participantID, ~participantID, algoFlag, "preset"++presetNum.asSymbol, ~rating]); // will be evaluated only for the first sample
					{["RATING STORED", "PRESET", algoFlag, presetNum, \value, tempRating].postln}.defer(0.0); // report msg for storing first preset
					~rating = nil; // set rating to nil
				};
				
				~sample = ~sample + 1; // increase count in the Latin Square array
				~sample = ~sample.wrap(0, 15); // wrap
				
				next = ~soundCollection[~participantID][~sample][0];

				{~preset.valueAction_(next)}.defer(0.1);

				// choose augmentation oder OD
				algorithm = ~soundCollection[~participantID][~sample][1].asSymbol;
				switch(algorithm,
					\aug, { // aug flag
						{~playAugSt.valueAction_(0); // first free aug synth
							~playOD.valueAction_(0); // then free OD synth
							~playAugSt.valueAction_(1); // finally PLAY AUG synth
						}.defer(0.0)
					},
					\od, { // od flag
						{
							~playAugSt.valueAction_(0); // first free aug synth
							~playOD.valueAction_(0); // then free OD synth
							~playOD.valueAction_(1); // finally PLAY AUG synth
						}.defer(0.0)
					}	
				);
			});

		});
	},{
		if((val == 1) && (~endFlag == false)){ // prevent double triggers
			// please rate your sound notification
			e.voicePlayback.set(\gate, 0); // release playing synth
			e.voicePlayback = Synth(\voicePlayback, [\gate, 1, \bufnum, ~voiceMsg, \amp,3]); // play new one
		};
	});
	
	//[\next, val].postln;
}, path:'/control/next');

"OSC RECEIVERS LOADED".postln;

