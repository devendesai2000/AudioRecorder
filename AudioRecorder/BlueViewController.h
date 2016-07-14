//
//  ViewController.h
//  AudioRecorder
//
//  Created by Desai Chia on 7/6/16.
//  Copyright © 2016 Deven Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Recording.h"

@interface BlueViewController : UIViewController <AVAudioRecorderDelegate>

- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;

@property(strong, nonatomic)Recording* currentRecording;
@property(strong, nonatomic)NSMutableArray* listOfRecordings;
@property (nonatomic, assign) AVAudioRecorder *recorder;
@property (strong, nonatomic) IBOutlet UIProgressView * progressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) NSTimer* timer;



@end




