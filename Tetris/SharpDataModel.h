//
//  BlockDataModel.h
//  Tetris
//
//  Created by Jerry.Yang on 2020/10/29.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SquareSize 20
#define SpaceSize 2

//typedef NS_ENUM(NSUInteger, TetrisBaseUnitType) {
//    
//};

@interface SharpDataModel : NSObject
@property(nonatomic) unsigned short model,type;

-(id)init;
-(void)random;
-(unsigned short)sharp;
-(unsigned short)randomSharp;
-(void)next;
-(void)last;

-(unsigned short)row;
-(unsigned short)col;
@end


NS_ASSUME_NONNULL_END
