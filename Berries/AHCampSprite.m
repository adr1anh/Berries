//
//  AHCampSprite.m
//  Berries
//
//  Created by Adrian Hamelink on 29/10/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHCampSprite.h"

@implementation AHCampSprite

+ (instancetype)berryCampWithType:(AHBerryType)type size:(CGFloat)size
{
    return [[AHCampSprite alloc] initWithBerryType:type size:size];
}

//designated Initializer
- (instancetype)initWithBerryType:(AHBerryType)type size:(CGFloat)size
{
    NSString *berryTypeName = [AHBerrySprite nameForType:type];
    
    //make sure it's a real berry type, and find the carpet image for it
    if (berryTypeName) {
        self = [super initWithImageNamed:[berryTypeName stringByAppendingString:@"Carpet"]];
    }
    
    if (self) {
        //set the anchor point to top left
        self.size = CGSizeMake(size, size);
        self.anchorPoint = CGPointMake(0, 1);
        
        //Name the camp
        self.name = [berryTypeName stringByAppendingString:@"Camp"];
        
        self.berryType = type;
    }
    return self;
}

@end
