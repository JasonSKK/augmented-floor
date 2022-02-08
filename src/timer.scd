~timer =
{
	
	Ndef(\timer, {
		| trigger = 0 |
		var trig, timer;
		trig = Impulse.kr(trigger);
		timer = Sweep.kr(trig);
	});

	fork{ // reg val to variable
		inf.do {
			~time = Ndef(\timer).bus.getSynchronous;
			~time = ~time.round(0.01);
			~time.postln;
			(0.05).wait;
		}
	};

};

~timer.play
