//
//  AHMainScene.h
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, AHDifficulty) {
    AHDifficultyEasy = 2,           // 2 camps: bottom, top
    AHDifficultyMedium = 4,         // 4 camps: top left, top right, bottom left, bottom right
    AHDifficultyHard = 6,           // 6 camps: same as medium, but also left and right of the grey camp
};

@interface AHMainScene : SKScene

@end
