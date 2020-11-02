//
//  TetrisWindow.m
//  Tetris
//
//  Created by Jerry.Yang on 2020/10/29.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "TetrisWindow.h"

@implementation TetrisWindow

-(void)awakeFromNib{
    self.title=@"简易怀旧版俄罗斯方块";
}

-(void)keyDown:(NSEvent *)event{
    NSString *fcstr = event.charactersIgnoringModifiers;
    if ([fcstr characterAtIndex:0] == NSLeftArrowFunctionKey) {
        [(BackgroundView *)self.contentView setIsLeftDown:YES];
//        [(BackgroundView *)self.contentView executeKeyDownEventCode:NSLeftArrowFunctionKey];
    }
    else if ([fcstr characterAtIndex:0] == NSRightArrowFunctionKey) {
        [(BackgroundView *)self.contentView setIsRightDown:YES];
//        [(BackgroundView *)self.contentView executeKeyDownEventCode:NSRightArrowFunctionKey];
    }
    else if ([fcstr characterAtIndex:0] == NSUpArrowFunctionKey) {
        [(BackgroundView *)self.contentView executeKeyDownEventCode:NSUpArrowFunctionKey];
    }
    else if ([fcstr characterAtIndex:0] == NSDownArrowFunctionKey) {
        [(BackgroundView *)self.contentView setSpeedup:YES];
    }
    else if ([fcstr characterAtIndex:0] == ' '){
//        [(BackgroundView *)self.contentView newSharp];
        [(BackgroundView *)self.contentView setIsPause:![(BackgroundView *)self.contentView isPause]];
    }
    else{
        [super keyDown:event];
    }
}

-(void)keyUp:(NSEvent *)event{
    NSString *fcstr = event.charactersIgnoringModifiers;
    if ([fcstr characterAtIndex:0] == NSDownArrowFunctionKey) {
        [(BackgroundView *)self.contentView setSpeedup:NO];
    }
    else if ([fcstr characterAtIndex:0] == NSLeftArrowFunctionKey){
        [(BackgroundView *)self.contentView setIsLeftDown:NO];
    }
    else if ([fcstr characterAtIndex:0] == NSRightArrowFunctionKey){
        [(BackgroundView *)self.contentView setIsRightDown:NO];
    }
}

@end
