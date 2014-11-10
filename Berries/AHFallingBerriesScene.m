//
//  AHFallingBerriesScene.m
//  Berries
//
//  Created by Adrian Hamelink on 13/07/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHFallingBerriesScene.h"

@interface AHFallingBerriesScene ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AHFallingBerriesScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self createScene];
    }
    return self;
}

- (void)createScene
{
    //fire timer every 0.75 seconds
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.75
                                                  target:self
                                                selector:@selector(addRandomFallingBerry:)
                                                userInfo:nil
                                                 repeats:YES];
    
    //add some berries at creation
    for (int i = 0; i < 20; i++) {
        AHBerrySprite *newBerry = [self newFallingBerry];
        
        //random position on screen
        newBerry.position = CGPointMake(arc4random_uniform(self.size.width - newBerry.size.width / 2) + newBerry.size.width / 4,
                                        arc4random_uniform(self.size.height - newBerry.size.height / 2) + newBerry.size.height / 4);
        [self addChild:newBerry];
    }
}

- (void)addRandomFallingBerry:(NSTimer *)timer
{
    if (!self.paused) {
        
        //create between 2 and 3 berries
        for (int i = 0; i < 2 + arc4random_uniform(2); i++) {
            AHBerrySprite *newBerry = [self newFallingBerry];
            newBerry.position = CGPointMake(arc4random_uniform(self.size.width),
                                            self.size.height + newBerry.size.height / 2);
            [self addChild:newBerry];
        }
    }
}

//create berry
- (AHBerrySprite *)newFallingBerry
{
    //ranodm type
    AHBerryType randomType = arc4random_uniform(5);
    AHBerrySprite *berry = [AHBerrySprite spriteNodeWithBerryType:randomType];
    
    //random size
    CGFloat random = 1 + arc4random_uniform(10) / 10.0;
    berry.scale *= random;
    
    //random rotation
    berry.zRotation = - M_PI / 6 + arc4random_uniform(10) * M_PI / 30;
    
    //falling action with random time
    CGFloat fallDuration = (10 + arc4random_uniform(10));
    SKAction *moveAction = [SKAction sequence:@[[SKAction moveToY:-50 duration:fallDuration],
                                                [SKAction removeFromParent]]];
    [berry runAction:moveAction];
    
    return berry;
}

@end
