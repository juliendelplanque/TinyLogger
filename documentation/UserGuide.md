# User documentation of TinyLogger

`TinyLogger` is a logger implementation (no kidding?!) for Pharo whose goal is to be small and simple.

The users can configure the way they want the logger to work, then the image will use this default logger to record informations. 

For specific cases, a specilized logger can be used.

## Configure your logger

The first step to use `TinyLogger` will be to configure the default logger that will be used by the image.

For most of the cases, the user should only interact with the `TinyLogger` class. `TinyLogger` is a composite to which we can add some *leaf* loggers. The *leaf* loggers will be loggers that will have the responsibility to log informations in one way. For example `TinyLogger` has a *leaf* logger to record informations in the Stdout of the application.

### Add sub-loggers to your `TinyLogger`

The default instance of `TinyLogger` has no logger registered when it is initialized. The first step will be to add one or multiple loggers to it. 

Here is the list of loggers present by default in the project:
* `TinyStdoutLogger`: This logger will record informations on the *stdout* of the application.
* `TinyTranscriptLogger`: This logger will record informations on the Pharo's `Transcript`.
* `TinyFileLogger`: This logger will record informations in a file on the user file system. By default the file will be named `TinyLogger.log`, but the file can be customized.

A *leaf* logger can be added to the default logger via the method `addLogger:` like this:

```Smalltalk
	TinyLogger default addLogger: TinyStdoutLogger new
```

But all default *leaf* loggers have a method to create a new instance and the new instance to the `TinyLogger` already present.

Here is an example adding a stdout logger, a transcript logger, a file logger with the default file name and a file logger with a customized name to the default `TinyLogger` instance:

```Smalltalk
	TinyLogger default
		addStdoutLogger;
		addTranscriptLogger;
		addFileLogger;
		addFileLoggerNamed: '../logs/MyOtherLog.log'.
```

### Remove sub-loggers

If at some point you wants to remove one or multiple loggers, `TineLogger` has some API elements to do that. 

The first way to remove loggers is with the method `removeAllLoggers`. This method will remove all the loggers of each kind.

```Smalltalk
	TinyLogger default removeAllLoggers
```

A second way to remove loggers is to remove all the loggers of one kind with the methods:
* `removeFileLoggers`
* `removeTranscriptLoggers`
* `removeStdoutLoggers`

```Smalltalk
	TinyLogger default removeFileLoggers
```

A last way is to use the method `removeLogger:` and giving as parameter the logger to remove.

```Smalltalk
	TinyLogger default fileLoggers
		select: [ :logger | logger fileName beginsWith: 'Test' ]
		thenDo: [ :logger | TinyLogger default removeLogger: logger ]
```

### List the sub-loggers

If you wish to get the list of loggers in a `TinyLogger` you can use different ways.

To get the list of all sub-loggers, you can use the `loggers` method:

```Smalltalk
	TinyLogger default loggers
```

You can also get it in the form of a dictionary with the kind of logger as keys and the instanciated loggers of this kind as values via the `loggersMap` method.

```Smalltalk
	TinyLogger default loggersMap
```

If you with to know all the loggers of a kind, you can use:
* `fileLoggers`
* `transcriptLoggers`
* `stdoutLoggers`

### Configure the timestamp format

By default, the preambule of the log will be a timestamp with a human readable format like this: 

```
29 November 2018 00:06:30 : Test
```

But this format is configurable. The `timestampFormatBlock:` method can be use with a parameter that is a block taking a stream as parameter and the timestamp (instance of DateAndTime) and use that to write the preambule on the stream.

```Smalltalk
	TinyLogger default timestampFormatBlock: [ :s :timestamp | s << timestamp asString ]
```

This will produce logs of this format:

```
2018-11-29T00:46:37.389775+01:00 : Test
```

## Record with your logger

This section will cover the API to record informations. 

### Record a single line log

To record a single line log you can just use the method `record`:

```Smalltalk
	'This is a string to log' record
```

This will produce a log like this with the default timestampFormatBlock:

```
29 November 2018 00:49:20 : This is a string to log
```

### Recording the execution of a task

To record the execution of a task you can use the method `execute:recordedAs:`

```Smalltalk
	self execute: [ 1 to: 5 do: [ :value | value asString record ] ] recordedAs: 'Task with only one nesting.'
```

Will rpoduce a log like this:

```
29 November 2018 00:56:20 : 	Begin: Task with only one nesting.
29 November 2018 00:56:20 : 		1
29 November 2018 00:56:20 : 		2
29 November 2018 00:56:20 : 		3
29 November 2018 00:56:20 : 		4
29 November 2018 00:56:20 : 		5
29 November 2018 00:56:20 : 	End: Task with only one nesting.
```

It is also possible to nest them like that:

```Smalltalk
self execute: [ 
		1 to: 4 do: [ :value1 | 
			self execute: [
				1 to: value1 do: [ :value2 | value2 asString record ]
				] recordedAs: 'My second nest'
			 ]
		 ] recordedAs: 'My first nest'.
```

It will produce this kind of output:

```
29 November 2018 00:57:45 : 	Begin: My first nest
29 November 2018 00:57:45 : 			Begin: My second nest
29 November 2018 00:57:45 : 				1
29 November 2018 00:57:45 : 			End: My second nest
29 November 2018 00:57:45 : 			Begin: My second nest
29 November 2018 00:57:45 : 				1
29 November 2018 00:57:45 : 				2
29 November 2018 00:57:45 : 			End: My second nest
29 November 2018 00:57:45 : 			Begin: My second nest
29 November 2018 00:57:45 : 				1
29 November 2018 00:57:45 : 				2
29 November 2018 00:57:45 : 				3
29 November 2018 00:57:45 : 			End: My second nest
29 November 2018 00:57:45 : 			Begin: My second nest
29 November 2018 00:57:45 : 				1
29 November 2018 00:57:45 : 				2
29 November 2018 00:57:45 : 				3
29 November 2018 00:57:45 : 				4
29 November 2018 00:57:45 : 			End: My second nest
29 November 2018 00:57:45 : 	End: My first nest
```

## Use another logger than the global logger

In some case it is possible that we do not want to use the default logger for a part of the application.

`TinyLogger` allows the users to use a custom logger during the execution of a process by changing the value of `TinyCurrentLogger`.

You can do it that way:

```Smalltalk
	| customLogger |
	customLogger := TinyLogger new
		addTranscriptLogger;
		yourself.
		
	TinyCurrentLogger value: customLogger during: [
		'test' record.
		TinyCurrentLogger value record: 'Test2'
	]
```
