//
//  AudioPlayer.h
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol FinishPlayPlayer <NSObject>

- (void)playerHasFinishedToPlay;
- (void)refreshDisp;

@end

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate>

@property (strong, nonatomic) id<FinishPlayPlayer> finishDelegate;

@property (strong, nonatomic) AVPlayer *audioPlayer;

@property (assign, nonatomic) int index;
//@property (assign, nonatomic) int oldIndex;

@property (assign, nonatomic) bool currentlyPlaying;

@property (strong, nonatomic) NSMutableArray *listeningList;

@property (strong, nonatomic) NSString *songName;

- (void)prepareSong:(int)identifier;

- (void)playSound;
- (void)playSoundAtPeriod:(float)period;
- (void)pauseSound;
- (void)stopSound;
- (void)previous;
- (void)next;
- (void)deleteCurrentPlayer;

+ (AudioPlayer *)sharedCenter;


@end
