//
//  Recording.m
//  AudioRecorder
//
//  Created by Desai Chia on 7/6/16.
//  Copyright © 2016 Deven Desai. All rights reserved.
//

#import "Recording.h"
@import AVFoundation;

@implementation Recording
@synthesize name;



- (void) play: (Recording*) aRecording
{
	NSLog(@"Playing %@", aRecording.name);
	NSAssert([[NSFileManager defaultManager] fileExistsAtPath: aRecording.path], @"Doesn't exist");
	NSError *error;
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL: aRecording.urlPath error:&error];
	if(error){
		NSLog(@"playing audio: %@ %ld %@", [error domain], [error code], [[error userInfo] description]);
		return;
	}else{
		_player.delegate = self;
	}
	if([_player prepareToPlay] == NO){
		NSLog(@"Not prepared to play!");
		return;
	}
	[_player play];
}

@end
