//
//  AHBerries.h
//  Berries
//
//  Created by Adrian Hamelink on 12/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, AHBerryType) {
    AHBerryTypeOrange = 0,
    AHBerryTypeApple,
    AHBerryTypeCherry,
    AHBerryTypeLemon
};

@interface AHBerries : SKSpriteNode
//lastPosition for when resetting a berry
@property CGPoint lastPosition;
@property AHBerryType berryType;

- (instancetype)initWithBerryType:(AHBerryType)type;
+ (instancetype)spriteNodeWithBerryType:(AHBerryType)type;
+ (SKColor *)colorForBerryType:(AHBerryType)type;

@end
