//
//  AHCamp.h
//  Berries
//
//  Created by Adrian Hamelink on 12/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AHBerries.h"

@interface AHCamp : SKSpriteNode
@property AHBerryType berryType;
+ (instancetype)spriteNodeWithSize:(CGSize)size;
+ (instancetype)spriteNodeWithBerryType:(AHBerryType)type size:(CGSize)size;
- (instancetype)initWithBerrySize:(CGSize)size;
- (instancetype)initWithBerryType:(AHBerryType)type size:(CGSize)size;
@end
