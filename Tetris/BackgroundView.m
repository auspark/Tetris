//
//  BackgroundView.m
//  Tetris
//
//  Created by Jerry.Yang on 2020/10/29.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//
/*
 虽然笔者刚刚接触C语言才不过十几天而已，但是发现C语言太难了。它的难点在于直接操作内存，而不像.net 那样，有clr维护内存；它的难点还在于，知识体系的简单，没有过大的框架，全部由底层的数据类型，函数来构建程序。这因为如此，C语言给了程序员非常宽松的思想空间。只要你有想法，就可以（几乎是）任意操作计算机。
 */

#import "BackgroundView.h"

@interface BackgroundView ()
{
    short xMax;
    short yMax;
    unsigned int database[25];//0x00 0f ff ff
    BOOL isRunning;
    NSTimer *mytimer;
    NSTimer *leftTimer;
    NSTimer *rightTimer;
    
}
@end

@implementation BackgroundView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.isLeftDown=NO;
    self.isRightDown=NO;
    self->isRunning=YES;
    self.speedup=NO;
    self.isPause=NO;
    self->xMax=self.frame.size.width/SquareSize-1;//width=400,0-19
    self->yMax=self.frame.size.height/SquareSize-1;//height=500,24-0
    self.sdm=[[SharpDataModel alloc]init];
    [self newSharp];
    self.timeInterval=0.4;
    [self startGame:0.4];
}

-(void)setIsLeftDown:(BOOL)isLeftDown{
    if (isLeftDown) {
        [self startMoveLeft:0.1];
    }else{
        [self->leftTimer invalidate];
        self->leftTimer=nil;
    }
}

-(void)setIsRightDown:(BOOL)isRightDown{
    if (isRightDown) {
        [self startMoveRight:0.1];
    }else{
        [self->rightTimer invalidate];
        self->rightTimer=nil;
    }
}


-(void)setSpeedup:(BOOL)speedup{
    _speedup=speedup;
//    NSLog(@"%@",speedup?@"down":@"up");
    if (speedup) {
        [self startGame:0.05];
    }else{
        [self startGame:0.4];
    }
}

-(void)viewDidMoveToWindow{
    for (NSView *v in self.subviews) {
        if ([[v identifier] isEqualToString:@"Score"]) {
            self.score=(NSTextField *)v;
            self.score.integerValue=0;
            break;
        }
    }
}

-(void)startMoveLeft:(NSTimeInterval)timerInterval{
    @autoreleasepool {
        [self->leftTimer invalidate];
        self->leftTimer=nil;
        self->leftTimer=[NSTimer scheduledTimerWithTimeInterval:timerInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self blockMoveLeft];
        }];
        [self->leftTimer fire];
    }
}

-(void)startMoveRight:(NSTimeInterval)timerInterval{
    @autoreleasepool {
        [self->rightTimer invalidate];
        self->rightTimer=nil;
        self->rightTimer=[NSTimer scheduledTimerWithTimeInterval:timerInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self blockMoveRight];
        }];
        [self->rightTimer fire];
    }
}


-(void)startGame:(NSTimeInterval)timeInterval{
    @autoreleasepool {
        [self->mytimer invalidate];
        self->mytimer=nil;
        self->mytimer=[NSTimer scheduledTimerWithTimeInterval:timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (self->isRunning) {
                if (!self.isPause) {
                    [self sharpMoveDown];
                }
            }else{
                [timer invalidate];
                timer=nil;
            }
        }];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    [self drawGrid];
    [self drawSquare];
    [self drawDatabase];
}

-(void)newGame{
    self.score.integerValue=0;
    [self newSharp];
    for (int i=0; i<=self->yMax; i++) {
        self->database[i]=0x0;
    }
    if (!self->isRunning) {
        self->isRunning=YES;
        [self startGame:0.4];
    }
}

-(void)drawGrid{
    NSBezierPath *path=[NSBezierPath bezierPath];
    //draw x line
    for (int x=0; x<=self.frame.size.width; x+=SquareSize)
    {
        [path moveToPoint:NSMakePoint(x, 0)];
        [path lineToPoint:NSMakePoint(x, self.frame.size.height)];
    }
    //draw y line
    for (int y=0; y<=self.frame.size.height; y+=SquareSize)
    {
        [path moveToPoint:NSMakePoint(0, y)];
        [path lineToPoint:NSMakePoint(self.frame.size.width, y)];
    }
    path.lineWidth=0.5;
    [[NSColor grayColor]set];
    [path stroke];
}

-(void)drawSquare{
    unsigned short sharp=[self.sdm sharp];
    for (short i=15; i>=0; i--) {
        if (sharp & 1<<i) {
            short relativeX = self.x+3-i%4;
            short relativeY = self.y-(3-i/4);
            [[NSColor blueColor]set];
            NSRectFill(NSMakeRect(relativeX*SquareSize+SpaceSize, relativeY*SquareSize+SpaceSize, SquareSize-2*SpaceSize, SquareSize-2*SpaceSize));
            // NSLog(@"self.x=%d xMax=%d",self.x,self->maxX);
        }
    }
}

-(void)drawDatabase{
//    self->database[0]=0x000ad2e1;//32 col
    for (short i=0; i<=self->yMax; i++) {
        unsigned int rowData = self->database[i];
        for (short j=self->xMax; j>=0; j--) {
            if (rowData & 1<<j) {
                short xIdx = self->xMax-j;
                [[NSColor blackColor]set];
                NSRectFill(NSMakeRect(xIdx*SquareSize+SpaceSize, i*SquareSize+SpaceSize, SquareSize-2*SpaceSize, SquareSize-2*SpaceSize));
            }
        }
    }
}


#pragma mark - key equilavent
-(void)executeKeyDownEventCode:(unsigned short)event{
    switch (event) {
        case NSLeftArrowFunctionKey:{//左移一个单位
            if ([self canMoveLeft]) {
                self.x--;
                self.needsDisplay=YES;
            }
            break;
        }
        case NSRightArrowFunctionKey:{//右移一个单位
            if ([self canMoveRight]) {
                self.x++;
                self.needsDisplay=YES;
            }
            break;
        }
        case NSUpArrowFunctionKey:{//变形
            if ([self canChangeSharp]) {
                [self.sdm next];
                self.needsDisplay=YES;
            }
            break;
        }
//        case NSDownArrowFunctionKey:{
//            self.speedup=YES;
//            break;
//        }
        default:
            break;
    }
}

-(void)sharpMoveDown{
    [self sharpMoveDownSingle];
}

-(void)sharpMoveDownSingle{
    if([self canMoveDown]){
        self.y--;
    }else{
        [self addSharpToDatabase];
    }
    self.needsDisplay=YES;
}

-(void)blockMoveLeft{
    if ([self canMoveLeft]) {
        self.x--;
        self.needsDisplay=YES;
    }
}

/*
 在square还没达到最左边的情况下,检查square中每个unit左边是否有障碍物
 如果有则不能移动,否则可以移动
 */
-(BOOL)canMoveLeft{
    if (self.x>0) {
        BOOL isCanMove=YES;
        for (short i=15; i>=0; i--) {
            if ([self.sdm sharp] & 1<<i) {
                short relativeX = self.x+3-i%4-1;
                short relativeY = self.y-(3-i/4);
                unsigned int rowData = self->database[relativeY];
                if(rowData & 1<<(self->xMax-relativeX)){
                    isCanMove=NO;
                    break;
                }
            }
        }
        return isCanMove;
    }
    return NO;
}

-(void)blockMoveRight{
    if ([self canMoveRight]) {
        self.x++;
        self.needsDisplay=YES;
    }
}

//是否可以右移
-(BOOL)canMoveRight{
    if (self.x+[self.sdm col]<self->xMax){
        BOOL isCanMove=YES;
        for (short i=15; i>=0; i--) {
            if ([self.sdm sharp] & 1<<i) {
                short relativeX = self.x+3-i%4+1;
                short relativeY = self.y-(3-i/4);
                unsigned int rowData = self->database[relativeY];
                if(rowData & 1<<(self->xMax-relativeX)){
                    isCanMove=NO;
                    break;
                }
            }
        }
        return isCanMove;
    }
    return NO;
}
//是否可形变
//主要看形变以后是否与四周其它障碍物冲突,是否超界
-(BOOL)canChangeSharp{
    BOOL isCanMove=YES;
    [self.sdm next];
    if (self.x+[self.sdm col]>self->xMax || self.y-[self.sdm row]<0) {
        isCanMove=NO;
    }else{
        for (short i=15; i>=0; i--) {
            if ([self.sdm sharp] & 1<<i) {
                short relativeX = self.x+3-i%4;
                short relativeY = self.y-(3-i/4);
                unsigned int rowData = self->database[relativeY];
                if(rowData & 1<<(self->xMax-relativeX)){
                    isCanMove=NO;
                    break;
                }
            }
        }
    }
    [self.sdm last];
    return isCanMove;
}

//判断是否可以下降一格
-(BOOL)canMoveDown{
    if(self.y-[self.sdm row]>0){
        BOOL isCanDown=YES;
        for (short i=15; i>=0; i--) {
            if ([self.sdm sharp] & 1<<i) {
                short relativeX = self.x+3-i%4;
                short relativeY = self.y-(3-i/4);
                unsigned int rowData = self->database[relativeY-1];
                if(rowData & 1<<(self->xMax-relativeX)){
                    isCanDown=NO;
                    break;
                }
            }
        }
        return isCanDown;
    }
    return NO;
}


// 新建sharp
-(void)newSharp{
    [self.sdm random];
    self.x=self->xMax/2-[self.sdm col]/2;
    self.y=self->yMax;
    self.needsDisplay=YES;
}

// 下降到不能下降的时候,要将square数据添加到数据库中
-(void)addSharpToDatabase{
    for (short i=15; i>=0; i--) {
        if ([self.sdm sharp] & 1<<i) {
            short relativeX = self.x+3-i%4;
            short relativeY = self.y-(3-i/4);
            unsigned int rowData = self->database[relativeY];
            rowData = rowData | 1<<(self->xMax-relativeX);
            self->database[relativeY]=rowData;
        }
    }
    [self eliminate];
    if (self->database[self->yMax]!=0x0) {
//        NSLog(@"timer should stop");
        self->isRunning=NO;
    }else{
        [self newSharp];
    }
}

// 消行
-(void)eliminate{
    /*
     1.一次将所有满行都消除,之后再将上边行一行行下移
     2.一次消除一行,上边的行立马全部下移
     */
    short c=0;
    for (short i=0; i<=self->yMax; i++) {
        if (self->database[i]==0x000fffff) {
            c++;
            self->database[i]=0x0;
            for (short j=i+1; j<=self->yMax; j++) {
                self->database[j-1]=self->database[j];
            }
            i-=1;
            self.score.integerValue+=self->xMax+1;
        }
        else if (self->database[i]==0x0) {
            break;
        }
    }
    //计分奖励:一次性消除3行,奖励1行的成绩,4行奖励2行的成绩
    if (c>2) {
        self.score.integerValue+=(c-2)*(self->xMax+1);
    }
}

@end
