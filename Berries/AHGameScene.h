//
//  AHGameScene.h
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, AHDifficulty) {
    AHDifficultyEasy = 2,           // 2 camps: bottom, top
    AHDifficultyMedium = 3,         // 3 camps: top left, top right, bottom
    AHDifficultyHard = 4,           // 4 camps: top left, top right, bottom left, bottom right
};

@protocol AHGameSceneDelegate <SKSceneDelegate>
@optional
- (void)scoreDidChange:(NSUInteger)score;
- (void)gameEndedAt:(NSDate *)time after:(NSUInteger)timeElapsed andScore:(NSUInteger)score;
- (void)timeDidChange:(NSUInteger)elapsed;
@end

@interface AHGameScene : SKScene

@property (nonatomic, weak) id <AHGameSceneDelegate> gameDelegate;

@end
