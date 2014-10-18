//
//  YHRecorderHandler.m
//  DuoRecorder
//
//  Created by kenobi on 2014/10/18.
//  Copyright (c) 2014年 ViewPlus. All rights reserved.
//

#import "YHRecorderHandler.h"

@implementation YHRecorderHandler
+ (void) activeSessionWithError:(NSError **)error{
	NSError* theError = nil;
	BOOL result = YES;
 
	AVAudioSession* myAudioSession = [AVAudioSession sharedInstance];
 
	result = [myAudioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&theError];
	if (!result)
	{
		NSLog(@"setCategory failed");
	}
 
	result = [myAudioSession setActive:YES error:&theError];
	if (!result)
	{
		NSLog(@"setActive failed");
	}
}

+ (NSArray *) avalidableSource{
	[self activeSessionWithError:nil];
	NSMutableArray *retArr=[NSMutableArray arrayWithCapacity:0];
	AVAudioSessionPortDescription* builtInMicPort = [self recordDescription];
	for (AVAudioSessionDataSourceDescription* source in builtInMicPort.dataSources)
	{
		[retArr addObject:source.orientation];
	} // end data source iteration
	return retArr;
}

+ (void) setRecordSource:(YHRecorderSource)sourceType{
	NSError *error;
	[self activeSessionWithError:&error];
	
	AVAudioSessionPortDescription *builtInMicPort=[self recordDescription];
	[builtInMicPort setPreferredDataSource:[self recordDataSourceFromType:sourceType] error:&error];
	[[AVAudioSession sharedInstance]setPreferredInput:builtInMicPort error:&error];
	if (error) {
		NSLog(@"%@",error);
	}
}

+ (void) setRecordSourceFromString:(NSString *)orientationString{
	NSError *error;
	[self activeSessionWithError:&error];
	
	AVAudioSessionPortDescription *builtInMicPort=[self recordDescription];
	[builtInMicPort setPreferredDataSource:[self recordDataSourceFromSource:orientationString] error:&error];
	[[AVAudioSession sharedInstance]setPreferredInput:builtInMicPort error:&error];
	if (error) {
		NSLog(@"%@",error);
	}
}

+ (AVAudioSessionPortDescription *) recordDescription{
	NSArray* inputs = [[AVAudioSession sharedInstance] availableInputs];
 
	// Locate the Port corresponding to the built-in microphone.
	AVAudioSessionPortDescription* builtInMicPort = nil;
	for (AVAudioSessionPortDescription* port in inputs)
	{
		if ([port.portType isEqualToString:AVAudioSessionPortBuiltInMic])
		{
			builtInMicPort = port;
			break;
		}
	}
	return builtInMicPort;
}

+ (AVAudioSessionDataSourceDescription *) recordDataSourceFromSource:(NSString *)sourceString{
	AVAudioSessionDataSourceDescription *retDataSource;
	
	AVAudioSessionPortDescription* builtInMicPort = [self recordDescription];
	for (AVAudioSessionDataSourceDescription* source in builtInMicPort.dataSources)
	{
		if ([source.orientation isEqual:sourceString])
		{
			retDataSource = source;
			break;
		}
	} // end data source iteration
	return retDataSource;
}

+ (AVAudioSessionDataSourceDescription *) recordDataSourceFromType:(YHRecorderSource)recordSource{
	NSString *sourceString;
	switch (recordSource) {
		case YHRecorderSourceTop:
			sourceString=AVAudioSessionOrientationTop;
			break;
		case YHRecorderSourceBottom:
			sourceString=AVAudioSessionOrientationBottom;
			break;
		case YHRecorderSourceFront:
			sourceString=AVAudioSessionOrientationFront;
			break;
		case YHRecorderSourceBack:
			sourceString=AVAudioSessionOrientationBack;
			break;
	default:
			break;
	}
	
	return [self recordDataSourceFromSource:sourceString];
}

+ (AVAudioSessionDataSourceDescription *)currentRecorderOrientation{
	return [[[AVAudioSession sharedInstance]preferredInput]selectedDataSource];
}


@end
