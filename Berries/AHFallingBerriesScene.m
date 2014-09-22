//
//  AHFallingBerriesScene.m
//  Berries
//
//  Created by Adrian Hamelink on 13/07/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHFallingBerriesScene.h"
#import "AHBerries.h"

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
    //Timer for random falling berries
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.75
                                                  target:self
                                                selector:@selector(addRandomFallingBerry:)
                                                userInfo:nil
                                                 repeats:YES];
    for (int i = 0; i < 10; i++) {
        AHBerries *newBerry = [self newFallingBerry];
        newBerry.position = CGPointMake(arc4random_uniform(self.size.width),
                                        arc4random_uniform(self.size.height));
        [self addChild:newBerry];
    }
}

- (CGFloat)velocity
{
    if (!_velocity) _velocity = 1;
    return _velocity;
}

- (void)addRandomFallingBerry:(NSTimer *)timer
{
    if (!self.paused) {
        for (int i = 0; i < arc4random_uniform(3); i++) {
            AHBerries *newBerry = [self newFallingBerry];
            newBerry.position = CGPointMake(arc4random_uniform(self.size.width),
                                            self.size.height + newBerry.size.height / 2);
            [self addChild:newBerry];
        }
    }
}
    
- (AHBerries *)newFallingBerry
{
    AHBerryType randomType = arc4random_uniform(3);
    AHBerries *berry = [AHBerries spriteNodeWithBerryType:randomType];

    CGFloat scale = .5 + (1 + arc4random_uniform(10)) / 10.0;
    berry.yScale = scale;
    berry.xScale = scale;
    
    CGFloat duration = (10 + arc4random_uniform(10)) * self.velocity;
    SKAction *moveAction = [SKAction sequence:@[[SKAction moveToY:0 duration:duration],
                                                [SKAction removeFromParent]]];
    [berry runAction:moveAction];
    
    return berry;
}

@end
