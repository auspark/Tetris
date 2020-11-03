//
//  ViewController.m
//  Tetris
//
//  Created by Jerry.Yang on 2020/10/29.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self test];
    [(BackgroundView *)self.view setGameLevel:self.levelTextField];
    [[(BackgroundView *)self.view gameLevel] setIntegerValue:1];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)restartGame:(id)sender {
    [(BackgroundView *)self.view newGame];
}

-(void)test{
    unsigned short s = 0xe800;
    for (short i=15; i>=0; i--) {
        if(s & 1<<i){
            NSLog(@"i:%d = yes",i);
        }else{
            NSLog(@"i:%d = NO",i);
        }
    }
}

@end
