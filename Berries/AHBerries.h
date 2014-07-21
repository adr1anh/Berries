//
//  AHBerries.h
//  Berries
//
//  Created by Adrian Hamelink on 12/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, AHBerryType) {
    AHBerryTypeUnknown = -1,
    AHBerryTypeOrange = 0,
    AHBerryTypeStrawberry,
    AHBerryTypeBanana,
    AHBerryTypeLemon
};

@interface AHBerries : SKSpriteNode
//lastPosition for when resetting a berry
@property CGPoint lastPosition;
@property AHBerryType berryType;
@property BOOL success;

- (instancetype)initWithBerryType:(AHBerryType)type;
+ (instancetype)spriteNodeWithBerryType:(AHBerryType)type;
+ (SKColor *)colorForBerryType:(AHBerryType)type;
+ (NSString *)nameForType:(AHBerryType)type;

@end
