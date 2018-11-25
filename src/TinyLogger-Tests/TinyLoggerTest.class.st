"
A TinyLoggerTest is a test class for testing the behavior of TinyLogger
"
Class {
	#name : #TinyLoggerTest,
	#superclass : #TinyAbstractLoggerTest,
	#instVars : [
		'logger'
	],
	#category : #'TinyLogger-Tests-Core'
}

{ #category : #helpers }
TinyLoggerTest >> actualClass [
	^ TinyLogger
]

{ #category : #running }
TinyLoggerTest >> setUp [
	super setUp.
	logger := TinyLogger new
]

{ #category : #test }
TinyLoggerTest >> testAddFileLogger [
	logger removeAllLoggers.
	self assert: logger loggers isEmpty.
	
	logger
		addFileLogger;
		addFileLogger.
	self assert: logger loggers size equals: 2.
	self assert: logger fileLoggers size equals: 2
]

{ #category : #test }
TinyLoggerTest >> testAddFileLoggerNamed [
	logger removeAllLoggers.
	self assert: logger loggers isEmpty.
	
	logger addFileLoggerNamed: 'test.log'.
	self assert: logger fileLoggers size equals: 1.
	self assert: logger loggers anyOne fileName equals: 'test.log'
]

{ #category : #test }
TinyLoggerTest >> testAddLogger [
	logger removeAllLoggers.
	self assert: logger loggers isEmpty.
	
	logger
		addLogger: (TinyFileLogger for: logger);
		addLogger: (TinyFileLogger for: logger named: 'test.log').
	self assert: logger loggers size equals: 2.
	self assert: logger fileLoggers size equals: 2
]

{ #category : #test }
TinyLoggerTest >> testAddStdoutLogger [
	logger removeAllLoggers.
	self assert: logger loggers isEmpty.

	logger
		addStdoutLogger;
		addStdoutLogger.
	self assert: logger loggers size equals: 2.
	self assert: logger stdoutLoggers size equals: 2
]

{ #category : #test }
TinyLoggerTest >> testAddTranscriptLogger [
	logger removeAllLoggers.
	self assert: logger loggers isEmpty.
	
	logger
		addTranscriptLogger;
		addTranscriptLogger.
	self assert: logger loggers size equals: 2.
	self assert: logger transcriptLoggers size equals: 2
]

{ #category : #test }
TinyLoggerTest >> testFileLoggers [
	logger
		addTranscriptLogger;
		addFileLoggerNamed: 'test.log';
		addFileLoggerNamed: 'test2.log'.
	self assert: logger loggers size equals: 3.
	self assert: logger fileLoggers size equals: 2.
	self assert: (logger fileLoggers allSatisfy: [ :each | each kind = TinyFileLogger kind ]).
	self assert: (logger fileLoggers anySatisfy: [ :each | each kind = TinyFileLogger kind and: [ each fileName = 'test.log' ] ]).
	self assert: (logger fileLoggers anySatisfy: [ :each | each kind = TinyFileLogger kind and: [ each fileName = 'test2.log' ] ])
]

{ #category : #test }
TinyLoggerTest >> testLoggers [
	logger
		addTranscriptLogger;
		addFileLoggerNamed: 'test.log';
		addFileLoggerNamed: 'test2.log'.
	self assert: logger loggers size equals: 3.
	self assert: (logger loggers anySatisfy: [ :each | each kind = TinyFileLogger kind and: [ each fileName = 'test.log' ] ]).
	self assert: (logger loggers anySatisfy: [ :each | each kind = TinyFileLogger kind and: [ each fileName = 'test2.log' ] ]).
	self assert: (logger loggers anySatisfy: [ :each | each kind = TinyTranscriptLogger kind ])
]

{ #category : #test }
TinyLoggerTest >> testRecord [
	self skip.
	self flag: #todo
]

{ #category : #test }
TinyLoggerTest >> testRemoveAllLoggers [
	logger
		addTranscriptLogger;
		addFileLoggerNamed: 'test.log';
		addFileLoggerNamed: 'test2.log'.
	self assert: logger loggers size equals: 3.
	logger removeAllLoggers.
	self assert: logger loggers isEmpty
]

{ #category : #test }
TinyLoggerTest >> testRemoveFileLoggers [
	logger
		addTranscriptLogger;
		addFileLoggerNamed: 'test.log';
		addFileLoggerNamed: 'test2.log'.
	self assert: logger loggers size equals: 3.
	logger removeFileLoggers.
	self assert: logger loggers size equals: 1
]

{ #category : #test }
TinyLoggerTest >> testRemoveLogger [
	| logger1 logger2 |
	logger removeAllLoggers.
	self assert: logger loggers isEmpty.
	
	logger
		addLogger: (logger1 := TinyFileLogger for: logger);
		addLogger: (logger2 := TinyFileLogger for: logger named: 'test.log').
	self assert: logger loggers size equals: 2.
	
	logger removeLogger: logger1.
	self assert: logger loggers size equals: 1.
	self assert: logger loggers anyOne equals: logger2.
	
	logger removeLogger: logger2.
	self assert: logger loggers isEmpty
]

{ #category : #test }
TinyLoggerTest >> testRemoveStdoutLoggers [
	logger
		addStdoutLogger;
		addStdoutLogger;
		addFileLoggerNamed: 'test.log'.
	self assert: logger loggers size equals: 3.
	logger removeStdoutLoggers.
	self assert: logger loggers size equals: 1
]

{ #category : #test }
TinyLoggerTest >> testRemoveTranscriptLoggers [
	logger
		addTranscriptLogger;
		addTranscriptLogger;
		addFileLoggerNamed: 'test.log'.
	self assert: logger loggers size equals: 3.
	logger removeTranscriptLoggers.
	self assert: logger loggers size equals: 1
]

{ #category : #test }
TinyLoggerTest >> testStdoutLoggers [
	logger
		addStdoutLogger;
		addStdoutLogger;
		addFileLoggerNamed: 'test.log'.
	self assert: logger loggers size equals: 3.
	self assert: logger stdoutLoggers size equals: 2.
	self assert: (logger stdoutLoggers allSatisfy: [ :each | each kind = TinyStdoutLogger kind ])
]

{ #category : #test }
TinyLoggerTest >> testTranscriptLoggers [
	logger
		addTranscriptLogger;
		addTranscriptLogger;
		addFileLoggerNamed: 'test.log'.
	self assert: logger loggers size equals: 3.
	self assert: logger transcriptLoggers size equals: 2.
	self assert: (logger transcriptLoggers allSatisfy: [ :each | each kind = TinyTranscriptLogger kind ])
]

{ #category : #test }
TinyLoggerTest >> testWithDefaultLoggers [
	| numberOfDefaultLoggers |
	logger withDefaultLoggers.
	self assert: logger loggers isNotEmpty.
	numberOfDefaultLoggers := logger loggers size.
	logger addStdoutLogger.
	logger withDefaultLoggers.
	"Ensure the loggers are reset when this method is called"
	self assert: logger loggers size equals: numberOfDefaultLoggers
]