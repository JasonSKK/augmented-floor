//alloc empty buffer

Buffer.freeAll;
~voiceBuffersLoad.value();

//onset detection
~soundOD = Array.fill(2, {Buffer.readChannel(s,~currPath +/+ "/sounds/silence.wav", channels:0)});

//augmentation
~soundAugSt = Buffer.readChannel(s, ~currPath +/+  "/sounds/silence.wav", channels:0);
e.augmentedSteps.set(\bufnum, ~soundAugSt);