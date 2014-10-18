//
//  YHRecorderHandler.h
//  DuoRecorder
//
//  Created by kenobi on 2014/10/18.
//  Copyright (c) 2014年 ViewPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef enum{
	YHRecorderSourceTop,
	YHRecorderSourceBottom,//iPhone 5
	YHRecorderSourceFront,//iPhone 5
	YHRecorderSourceBack,//iPhone 5
} YHRecorderSource;

@interface YHRecorderHandler : NSObject
+ (NSArray *) avalidableSource;
+ (void) setRecordSource:(YHRecorderSource)sourceType;
+ (void) setRecordSourceFromString:(NSString *)orientationString;
+ (AVAudioSessionDataSourceDescription *)currentRecorderOrientation;

@end
