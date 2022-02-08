

//:


~timer =
{
	~time = 0.0; // initialise time
	
	Ndef(\timer, {
	| trigger = 0 |
	var trig, timer;
    trig = Impulse.kr(trigger);
    timer = Sweep.kr(trig);
});

fork{
	inf.do {
		~time = Ndef(\timer).bus.getSynchronous; // this works only for control rate signals
		~time.postln;
		"popos".postln;
		(0.05).wait; // update var every 0.01 sec
	}
};

}
//:

~timer.value()
Ndef(\timer).clear
//a = ~timer.play
//a.free

//:
//a.set(\trigger, 10);
//a.set(\trigger, 0)

