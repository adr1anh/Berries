//
//  AHBerrySprite.m
//  Berries
//
//  Created by Adrian Hamelink on 12/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHBerrySprite.h"

@implementation AHBerrySprite

- (instancetype)initWithBerryType:(AHBerryType)type
{
    //creates a square proportional to the screen size
    CGFloat hitZoneSide = [UIScreen mainScreen].bounds.size.width / 5.5;
    CGSize hitZone = CGSizeMake(hitZoneSide, hitZoneSide);
    
    //self is the hit zone
    self = [super initWithColor:[SKColor clearColor] size:hitZone];
    if (self) {
        [self setScale:1];
        
        //add the image on top
        self.imageSprite = [[AHBerrySprite alloc] initWithImageNamed:[AHBerrySprite nameForType:type]];
        
        //scale it
        CGFloat width = self.imageSprite.size.width;
        CGFloat height = self.imageSprite.size.height;
        CGFloat scale;
        
        if (width <= height) {
            scale = hitZoneSide / height;
        } else {
            scale = hitZoneSide / width;
        }
        
        //add it and make it slightly smaller
        [self.imageSprite setScale:scale * .8];
        [self addChild:self.imageSprite];
        
        self.berryType = type;
        self.rottingStage = AHRottingStageHealthy;
        self.name = [[AHBerrySprite nameForType:type] stringByAppendingString:@"Berry"];
    }
    return self;
}

+ (instancetype)spriteNodeWithBerryType:(AHBerryType)type
{
    return [[AHBerrySprite alloc] initWithBerryType:type];
}

- (void)setScale:(CGFloat)scale
{
    [super setScale:scale];
    _scale = scale;
}

- (void)startRotting
{
    //if it's sorted, we stop jittering
    if (self.rottingStage == AHRottingStageSaved) {
        [self removeActionForKey:@"jitter"];
        return;
    }
    
    //go through each rotting stage
    if (self.rottingStage == AHRottingStageHealthy) {
        
        //start jittering, rotating
        SKAction *jitter = [SKAction sequence:@[[SKAction rotateToAngle:M_PI / 6 duration:.5],
                                                [SKAction rotateToAngle:- M_PI / 6 duration:.5]]];
        
        [self runAction:[SKAction repeatActionForever:jitter] withKey:@"jitter"];
        
        //color to brown
        SKAction *rot = [SKAction sequence:@[[SKAction waitForDuration:1.5],
                                             [SKAction colorizeWithColor:[SKColor brownColor] colorBlendFactor:.5 duration:.5],
                                             [SKAction performSelector:@selector(incrementRotting) onTarget:self]]];
        [self.imageSprite runAction:rot];
    }
    
    if (self.rottingStage == AHRottingStageDry) {
        
        //wait a bit, then color some more
        SKAction *rotMore = [SKAction sequence:@[[SKAction waitForDuration:1.5],
                                                 [SKAction colorizeWithColor:[SKColor brownColor] colorBlendFactor:.75 duration:.5],
                                                 [SKAction waitForDuration:1.5],
                                                 [SKAction performSelector:@selector(incrementRotting) onTarget:self]]];
        [self.imageSprite runAction:rotMore];
    }
    
    if (self.rottingStage == AHRottingStageRotten) {
        
        //make jittering faster
        SKAction *jitter = [self actionForKey:@"jitter"];
        jitter.speed *= 2;
        
        //flash yellow for strawberries, and white for the rest
        SKColor *highlight = (self.berryType == AHBerryTypeStrawberry) ? [SKColor yellowColor] : [SKColor redColor];
        
        //final stage and urgent
        SKAction *lastRot = [SKAction sequence:@[[SKAction colorizeWithColor:highlight colorBlendFactor:.75 duration:.5],
                                                 [SKAction colorizeWithColor:[SKColor blackColor] colorBlendFactor:.75 duration:.5]]];
        
        [self.imageSprite runAction:[SKAction sequence:@[[SKAction repeatAction:lastRot count:5],
                                                         [SKAction performSelector:@selector(incrementRotting) onTarget:self]]]];
    }
    
    if (self.rottingStage == AHRottingStageDead) {
        
        //lose game
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gameLost" object:self];
    }
    
}

//go to next stage
- (void)incrementRotting
{
    self.rottingStage++;
    [self startRotting];
}

- (void)appear
{
    CGFloat oldScale = self.scale;
    
    //move up, make opaque, and shrink
    SKAction *prepare = [SKAction group:@[[SKAction moveByX:0 y:120 duration:0],
                                          [SKAction scaleBy:.3 duration:0],
                                          [SKAction fadeAlphaTo:1 duration:0]]];
    
    //make bigger
    SKAction *appear = [SKAction scaleTo:oldScale duration:.6];
    
    //fall
    SKAction *fall = [SKAction moveByX:0 y:-120 duration:.6];
    
    //bounce
    SKAction *bounce = [SKAction sequence:@[[SKAction moveByX:0 y:20 duration:.25],
                                             [SKAction moveByX:0 y:-20 duration:.25]]];
    
    //do all of those
    SKAction *final = [SKAction sequence:@[prepare,
                                           [SKAction group:@[appear, fall]],
                                           bounce,
                                           [SKAction performSelector:@selector(startRotting) onTarget:self]]];
    
    [self runAction:final];
}

- (void)disappear
{
    //shrink, rotate and fade
    CGFloat duration = 2.5;
    SKAction *disappear = [SKAction sequence:@[[SKAction group:@[[SKAction rotateByAngle:3 * M_PI duration:duration],
                                                                 [SKAction scaleTo:0 duration:duration],
                                                                 [SKAction fadeOutWithDuration:duration]]],
                                               [SKAction removeFromParent]]];
    [self runAction:disappear];
}

//name for different AHBerryTypes
+ (NSString *)nameForType:(AHBerryType)type
{
    switch (type) {
        case AHBerryTypeBanana: {
            return @"Banana";
        }
        case AHBerryTypeStrawberry: {
            return @"Strawberry";
        }
        case AHBerryTypeApple: {
            return @"Apple";
        }
        case AHBerryTypeOrange: {
            return @"Orange";
        }
        case AHBerryTypeCherry: {
            return @"Cherry";
        }
        case AHBerryTypeUnknown: {
            return nil;
        }
    }
}

@end
