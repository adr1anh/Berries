//
//  AHCamp.m
//  Berries
//
//  Created by Adrian Hamelink on 12/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHCamp.h"

@interface AHCamp ()
@end

@implementation AHCamp

+ (instancetype)spriteNodeWithSize:(CGSize)size
{
    return [[AHCamp alloc] initWithBerrySize:size];
}

- (instancetype)initWithBerrySize:(CGSize)size
{
    return [self initWithBerryType:AHBerryTypeUnknown size:size];
}

+ (instancetype)spriteNodeWithBerryType:(AHBerryType)type size:(CGSize)size
{
    return [[AHCamp alloc] initWithBerryType:type size:size];
}

//Designated Initializer
- (instancetype)initWithBerryType:(AHBerryType)type size:(CGSize)size
{
    if ([AHBerries nameForType:type]) {
        self = [super initWithImageNamed:[[AHBerries nameForType:type] stringByAppendingString:@"Camp"]];
    } else {
        self = [super initWithColor:[AHBerries colorForBerryType:type] size:size];
    }
    if (self) {
        //Name the camp
        self.name = [[AHBerries nameForType:type] stringByAppendingString:@"Camp"];
        
        //Check if not unknown
//        if (type != AHBerryTypeUnknown) {
//            //Add a greyscale fruit as background
//            SKSpriteNode *greyFruit = [SKSpriteNode spriteNodeWithImageNamed:[[AHBerries nameForType:type] stringByAppendingString:@"Grey"]];
//            greyFruit.position = CGPointZero;
//            [self addChild:greyFruit];
//        }
        
        //What berry type should this camp accept
        self.berryType = type;
    }
    return self;
}

@end
