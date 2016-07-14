//
//  ViewController.m
//  AudioRecorder
//
//  Created by Desai Chia on 7/6/16.
//  Copyright © 2016 Deven Desai. All rights reserved.
//

#import "BlueViewController.h"
#import "TableViewController.h"
@import AVFoundation;


@interface BlueViewController ()

@end

@implementation BlueViewController
@synthesize listOfRecordings;

-(BlueViewController*) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder: aDecoder];
	if(self){
		self.listOfRecordings = [[NSMutableArray alloc] init];
		[self.listOfRecordings addObject: @"recording"];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	TableViewController* pvc = (TableViewController*)segue.destinationViewController;
	pvc.otherListOfRecordings = self.listOfRecordings;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)startButton:(id)sender {
	AVAudioSession* audioSession = [AVAudioSession sharedInstance];
	NSError* err = nil;
	[audioSession setCategory: AVAudioSessionCategoryRecord error: &err];
	if(err){
		NSLog(@"audioSession: %@ %ld %@",
			  [err domain], [err code], [[err userInfo] description]);
		return;
	}
	err = nil;
	[audioSession setActive:YES error:&err];
	if(err){
		NSLog(@"audioSession: %@ %ld %@",
			  [err domain], [err code], [[err userInfo] description]);
		return;
	}
	
	NSMutableDictionary* recordingSettings = [[NSMutableDictionary alloc] init];
	
	[recordingSettings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];

	[recordingSettings setValue:@44100.0 forKey:AVSampleRateKey];
	
	[recordingSettings setValue:@1 forKey:AVNumberOfChannelsKey];
	
	[recordingSettings setValue:@16 forKey:AVLinearPCMBitDepthKey];
	
	[recordingSettings setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
	
	[recordingSettings setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
	
	[recordingSettings setValue:@(AVAudioQualityHigh)
						 forKey:AVEncoderAudioQualityKey];
	
	
	NSDate* now = [NSDate date];
	
	self.currentRecording = [[Recording alloc] initWithDate: now];
	[self.listOfRecordings addObject: self.currentRecording];
	
	NSLog(@"%@",self.currentRecording);
	
	err = nil;
	
	self.recorder = [[AVAudioRecorder alloc]
					 initWithURL:self.currentRecording.urlPath
					 settings:recordingSettings
					 error:&err];
	
	if(!self.recorder){
		NSLog(@"recorder: %@ %ld %@",
			  [err domain], [err code], [[err userInfo] description]);
		UIAlertController* alert = [UIAlertController
									alertControllerWithTitle:@"Warning"
									message:[err localizedDescription]
									preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction
										actionWithTitle:@"OK"
										style:UIAlertActionStyleDefault
										handler:^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
		
		return;
	}
	
	//prepare to record
	[self.recorder setDelegate:self];
	[self.recorder prepareToRecord];
	self.recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputAvailable;
	if( !audioHWAvailable ){
		UIAlertController* cantRecordAlert = [UIAlertController
											  alertControllerWithTitle:@"Warning"
											  message:@"Audio input hardware not available."
											  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction
										actionWithTitle:@"OK"
										style:UIAlertActionStyleDefault
										handler:^(UIAlertAction * action) {}];
		
		[cantRecordAlert addAction:defaultAction];
		[self presentViewController:cantRecordAlert animated:YES completion:nil];
		
		
		return;
	}
	
	// start recording
	[_recorder recordForDuration:(NSTimeInterval)5];
	
	self.statusLabel.text = @"Recording...";
	self.progressView.progress = 0.0;
	self.timer = [NSTimer
      scheduledTimerWithTimeInterval:0.2
				  target:self
				  selector:@selector(handleTimer)
				  userInfo:nil
				  repeats:YES];
	//NSMutableArray* recordings;
	//Recording*r = [[[Recording alloc] initWithDate: [NSDate date]];
}

- (IBAction)stopButton:(id)sender {
	[self.recorder stop];
	
	[self.timer invalidate];
	self.statusLabel.text = @"Stopped";
	self.progressView.progress = 1.0;
	
	if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
		NSLog(@"File exists");
		
	}else{
		NSLog(@"File does not exist");
	}
}


- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	NSLog (@"audioRecorderDidFinishRecording:successfully:");
	[self.timer invalidate];
	self.statusLabel.text = @"Stopped";
	self.progressView.progress = 1.0;
	
	if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
		NSLog(@"File exists");
	}else{
		NSLog(@"File does not exist");
	}
}
@end
