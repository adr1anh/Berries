//
//  AHBerrySprite.h
//  Berries
//
//  Created by Adrian Hamelink on 12/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

@import SpriteKit;

typedef NS_ENUM(NSUInteger, AHBerryType) {
    AHBerryTypeUnknown = -1,
    AHBerryTypeOrange = 0,
    AHBerryTypeStrawberry,
    AHBerryTypeBanana,
    AHBerryTypeCherry,
    AHBerryTypeApple
};

typedef NS_ENUM(NSUInteger, AHRottingStage) {
    AHRottingStageSaved = 0,
    AHRottingStageHealthy = 1,
    AHRottingStageDry,
    AHRottingStageRotten,
    AHRottingStageDead
};

@interface AHBerrySprite : SKSpriteNode

@property AHBerryType berryType;
@property AHRottingStage rottingStage;
@property (nonatomic) CGFloat scale;
@property AHBerrySprite *imageSprite;

- (instancetype)initWithBerryType:(AHBerryType)type;
+ (instancetype)spriteNodeWithBerryType:(AHBerryType)type;
+ (NSString *)nameForType:(AHBerryType)type;

- (void)appear;
- (void)disappear;

@end
