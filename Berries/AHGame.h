//
//  AHGame.h
//  Berries
//
//  Created by Adrian Hamelink on 19/10/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

@import GameKit;

#import "AHBerrySprite.h"

@interface AHGame : NSObject

@property (nonatomic) NSUInteger score;
@property (nonatomic) NSUInteger timeElapsed;
@property (nonatomic, strong) NSTimer *timer;

- (instancetype)init;

- (void)addPoint;

@end