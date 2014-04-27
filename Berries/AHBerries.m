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
        case AHBerryTypeApple: {
            return SKColorFromRGB(0xc6000f);
        }
            
        case AHBerryTypeCherry: {
            return SKColorFromRGB(0xff2f3f);
        }
            
        case AHBerryTypeLemon: {
            return SKColorFromRGB(0xfff200);
        }
            
        case AHBerryTypeOrange: {
            return SKColorFromRGB(0xff7f27);
        }
    }
}

+ (NSString *)imageNameForType:(AHBerryType)type
{
    switch (type) {
        case AHBerryTypeApple: {
            return @"Apple";
        }
            
        case AHBerryTypeCherry: {
            return @"Cherry";
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
