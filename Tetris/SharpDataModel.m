//
//  BlockDataModel.m
//  Tetris
//
//  Created by Jerry.Yang on 2020/10/29.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "SharpDataModel.h"


const static unsigned short modelTypes[][4]={
    {0xe800,0x88c0,0x2e00,0xc440},
    {0xe200,0xc880,0x8e00,0x44c0},
    {0x8888,0xf000,0x8888,0xf000},
    {0x4e00,0x4c40,0xe400,0x8c80},
    {0xcc00,0xcc00,0xcc00,0xcc00},
    {0x4c80,0xc600,0x4c80,0xc600},
    {0x8c40,0x6c00,0x8c40,0x6c00},
};

@implementation SharpDataModel

-(id)init{
    if (self=[super init]) {
        [self random];
    }
    return self;
}

-(void)random{
    self.model=(unsigned short)arc4random()%7;//0-6
    self.type=(unsigned short)arc4random()%4; //0-3
}

-(unsigned short)sharp{
    return modelTypes[self.model][self.type];
}

-(unsigned short)randomSharp{
    [self random];
    return [self sharp];
}

-(void)next{//0-3
    self.type=self.type+1>3?0:self.type+1;
}

-(void)last{//0-3
    self.type=self.type-1<0?3:self.type-1;
}

-(unsigned short)row{//0-3
    int i = 0;
    for (int j=0; j<4; j++) {
        if ([self sharp]&0xf000>>j*4) {
            i+=1;
        }
    }
    return i>0?i-1:0;
}

-(unsigned short)col{//0-3
    unsigned short c=0;
    for (short i=0; i<4; i++) {
        if (i==0) {
            c=(0xf000>>i*4&[self sharp])>>(3-i)*4;
        }else{
            c|=(0xf000>>i*4&[self sharp])>>(3-i)*4;
        }
    }
    unsigned short tc=0;
    for (short i=0; i<4; i++) {
        if(c&1<<i){
            tc+=1;
        }
    }
    return tc>0?tc-1:0;
}

@end

