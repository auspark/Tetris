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



@interface BackgroundView : NSView
-(void)executeKeyEventCode:(unsigned short)event;
@property(nonatomic) unsigned short x,y;
@property(nonatomic) SharpDataModel *sdm;
@property(nonatomic) NSTextField *score;

-(void)newSharp;
-(void)newGame;

@end

NS_ASSUME_NONNULL_END
