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

+ (instancetype)spriteNodeWithBerryType:(AHBerryType)type size:(CGSize)size
{
    return [[AHCamp alloc] initWithBerryType:type size:size];
}

- (instancetype)initWithBerryType:(AHBerryType)type size:(CGSize)size
{
    self = [super initWithColor:[AHBerries colorForBerryType:type] size:size];
    if (self) {
        self.berryType = type;
    }
    return self;
}

@end
