//
//  AHCampSprite.h
//  Berries
//
//  Created by Adrian Hamelink on 29/10/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

@import SpriteKit;

#import "AHBerrySprite.h"

@interface AHCampSprite : SKSpriteNode

@property AHBerryType berryType;

+ (instancetype)berryCampWithType:(AHBerryType)type size:(CGFloat)size;
- (instancetype)initWithBerryType:(AHBerryType)type size:(CGFloat)size;

@end
