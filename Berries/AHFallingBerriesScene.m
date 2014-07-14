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
    self.physicsWorld.gravity = CGVectorMake(0,-.2);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.33
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

- (void)addRandomFallingBerry:(NSTimer *)timer
{
//    for (int i = 0; i < 3; i++) {
        AHBerries *newBerry = [self newFallingBerry];
        newBerry.position = CGPointMake(arc4random_uniform(self.size.width),
                                        self.size.height + newBerry.size.height / 2);
        [self addChild:newBerry];
//    }
}

- (AHBerries *)newFallingBerry
{
    AHBerryType randomType = arc4random_uniform(3);
    AHBerries *berry = [AHBerries spriteNodeWithBerryType:randomType];
//
//    berry.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:berry.size.height / 2];
//    berry.physicsBody.affectedByGravity = YES;
//    berry.physicsBody.mass = 0.2;
    SKAction *moveAction = [SKAction sequence:@[[SKAction moveToY:0 duration:7], [SKAction removeFromParent]]];
    [berry runAction:moveAction];
    
    return berry;
}

@end
