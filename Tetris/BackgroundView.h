//
//  BackgroundView.h
//  Tetris
//
//  Created by Jerry.Yang on 2020/10/29.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SharpDataModel.h"
NS_ASSUME_NONNULL_BEGIN

#define TimerInterval 0.5
#define MaxLevel 16
@interface BackgroundView : NSView
-(void)executeKeyDownEventCode:(unsigned short)event;
@property(nonatomic) unsigned short x,y;
@property(nonatomic) SharpDataModel *sdm;
@property(nonatomic) NSTextField *score;
@property(nonatomic) BOOL isPause;
@property(nonatomic) BOOL speedup;
@property(nonatomic) NSTimeInterval timeInterval;
-(void)newSharp;
-(void)newGame;

@property(nonatomic) BOOL isLeftDown;
@property(nonatomic) BOOL isRightDown;

@property(nonatomic) short level;
@property(nonatomic) NSTextField *gameLevel;
@end

NS_ASSUME_NONNULL_END
