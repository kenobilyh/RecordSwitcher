//
//  ViewController.m
//  RecordSwitcher
//
//  Created by kenobi on 2014/10/18.
//  Copyright (c) 2014年 kenobi. All rights reserved.
//

#import "ViewController.h"
#import "YHRecorderHandler.h"

@interface ViewController ()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.edgesForExtendedLayout=UIRectEdgeNone;
	UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeSystem];
	startBtn.frame=CGRectMake(150, 100, 44, 44);
	[startBtn setTitle:@"start" forState:UIControlStateNormal];
	[startBtn addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:startBtn];
	
	UISegmentedControl *segmentCtrl=[[UISegmentedControl alloc]initWithItems:[YHRecorderHandler avalidableSource]];
	segmentCtrl.center=CGPointMake(self.view.center.x, 80);
	[segmentCtrl setSelectedSegmentIndex:0];
	[segmentCtrl addTarget:self action:@selector(sourceChange:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:segmentCtrl];
	
	[YHRecorderHandler setRecordSource:YHRecorderSourceBottom];
	
	NSError *error;
	NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
	NSDictionary *set = [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithFloat:44100.0f], AVSampleRateKey,
						 [NSNumber numberWithInt:kAudioFormatAppleLossless], AVFormatIDKey,
						 [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
						 [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
						 nil];
	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:set error:&error];
	self.recorder.delegate=self;
	self.recorder.meteringEnabled=YES;
}

- (void) sourceChange:(UISegmentedControl *)sender{
	[YHRecorderHandler setRecordSourceFromString:[sender titleForSegmentAtIndex:sender.selectedSegmentIndex]];
}

- (void) startRecord:(UIButton *)sender{
	[self.recorder recordForDuration:10];
	self.updateTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateMeter:) userInfo:nil repeats:YES];
}

- (void) updateMeter:(NSTimer *)timer{
	[self.recorder updateMeters];
	NSLog(@"%@",[YHRecorderHandler currentRecorderOrientation]);
	NSLog(@"%s %f %f",__func__,[self.recorder peakPowerForChannel:0],[self.recorder averagePowerForChannel:0]);
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
	[self.updateTimer invalidate];
}

@end
