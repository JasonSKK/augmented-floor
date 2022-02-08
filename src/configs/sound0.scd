//alloc empty buffer
s.stopRecording;
//Buffer.freeAll;
//~voiceBuffersLoad.value();
~soundOD.collect{|i|i.free};
~soundAugSt.free;

//onset detection
~soundOD = Array.fill(2, {Buffer.readChannel(s,~currPath +/+ "/sounds/silence.wav", channels:0)});

//augmentation
~soundAugSt = Buffer.readChannel(s, ~currPath +/+  "/sounds/silence.wav", channels:0);
e.augmentedSteps.set(\bufnum, ~soundAugSt);