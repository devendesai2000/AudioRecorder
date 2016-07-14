//
//  Recording.h
//  AudioRecorder
//
//  Created by Desai Chia on 7/6/16.
//  Copyright © 2016 Deven Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface Recording : NSObject <AVAudioPlayerDelegate>

@property(strong,nonatomic) NSDate* date;
//always save in ~/Documents/yyyyMMddhhmmss
@property (readonly, nonatomic) NSString* path;
@property (readonly, nonatomic) NSURL* urlPath;
@property (strong, nonatomic) NSString* name;
@property (nonatomic, assign) AVAudioPlayer *player;


-(Recording*) initWithDate:(NSDate*) aDate;



@end
