activation
activate
	| argsArray sess stoneInfo |
	self activateHelp
		ifTrue: [ ^ self ].
	self arguments size < 1
		ifTrue: [ 
			self printHelp.
			^ self exitFailure: 'Missing arguments' ].
	[ self shouldNotBeForeignStone ]
		on: STONReaderError
		do: [ :ignored | 
			"if stoneInfo is corrupted, then the netldi could not have been started."
			^ self exitSuccess ].
	sess := self sessionDescriptionIfAbsent: [ :ignored |  ].
	[ stoneInfo := self stoneInfo ]
		on: STONReaderError
		do: [ :ignored | 
			"if stoneInfo is corrupted, then the netldi could not have been started."
			^ self exitSuccess ].
	argsArray := sess ifNil: [ {(stoneInfo netLDI)} ] ifNotNil: [ {(sess netLDI)} ].
	Transcript
		cr;
		show: (self runShellCommand: (self gemstoneBin / 'stopnetldi') pathString args: argsArray exitStatus: [:proc |
			| es |
			es := (proc exitStatus bitAnd: 16rFF00) >> 8.
			proc isComplete and: [ es == 0 or: [ es == 1 "information" or: [ es == 2 "warning"] ] ] ]);
		cr.
	self exitSuccess