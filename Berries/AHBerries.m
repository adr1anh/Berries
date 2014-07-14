//
//  AHBerries.m
//  Berries
//
//  Created by Adrian Hamelink on 12/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHBerries.h"

@implementation AHBerries

- (instancetype)initWithBerryType:(AHBerryType)type
{
    self = [super initWithImageNamed:[AHBerries imageNameForType:type]];
    if (self) {
        self.color = [AHBerries colorForBerryType:type];
        self.success = NO;
        self.berryType = type;
    }
    return self;
}

+ (instancetype)spriteNodeWithBerryType:(AHBerryType)type
{
    return [[AHBerries alloc] initWithBerryType:type];
}

#define SKColorFromRGB(rgbValue) [SKColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

+ (SKColor *)colorForBerryType:(AHBerryType)type {
    switch (type) {
        case AHBerryTypeBanana: {
            return SKColorFromRGB(0xffe100);
        }
            
        case AHBerryTypeStrawberry: {
            return SKColorFromRGB(0xe6445a);
        }
            
        case AHBerryTypeLemon: {
            return SKColorFromRGB(0xf7cc01);
        }
            
        case AHBerryTypeOrange: {
            return SKColorFromRGB(0xffc000);
        }
    }
}

+ (NSString *)imageNameForType:(AHBerryType)type
{
    switch (type) {
        case AHBerryTypeBanana: {
            return @"Banana";
        }
            
        case AHBerryTypeStrawberry: {
            return @"Strawberry";
        }
            
        case AHBerryTypeLemon: {
            return @"Lemon";
        }
            
        case AHBerryTypeOrange: {
            return @"Orange";
        }
    }
}

@end
