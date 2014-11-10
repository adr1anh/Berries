//
//  AHGame.m
//  Berries
//
//  Created by Adrian Hamelink on 19/10/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHGame.h"

@interface AHGame ()
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@end

@implementation AHGame

- (instancetype)init
{
    if (self = [super init]) {
        
        //load the leaderboard
        [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
            if (error)
                NSLog(@"%@", [error localizedDescription]);
            else
                self.leaderboardIdentifier = leaderboardIdentifier;
        }];
        
        //register for the notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameLost:) name:@"gameLost" object:nil];
        
        //start timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
    return self;
}

//send score to Game Center
- (void)reportScore:(GKScore *)score
{
    //check if the eaderboard has been set
    if (score) {
        
        //submit score
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error)
                NSLog(@"%@", [error localizedDescription]);
        }];
    }
}

//called every second
- (void)updateTime:(NSTimer *)timer
{
    //update time
    self.timeElapsed++;
    
    //send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTime"
                                                        object:self
                                                      userInfo:@{@"time" : [NSNumber numberWithUnsignedInteger:self.timeElapsed]}];
    //spawn one berry
    [[NSNotificationCenter defaultCenter] postNotificationName:@"spawnBerry" object:self];
    
    //depending on the difficulty, spawn another
    NSUInteger score = ceil(self.score / 10.0); //bigger than 1
    NSUInteger random = 1 + arc4random_uniform(4); //between 1 and 4
    if (random < score) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"spawnBerry" object:self];
    }
}

//update score
- (void)addPoint
{
    self.score++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreChanged"
                                                        object:self
                                                      userInfo:@{@"score" : [NSNumber numberWithUnsignedInteger:self.score]}];
}

//game is lost
- (void)gameLost:(NSNotification *)notification
{
    //remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //stop timer
    [self.timer invalidate];
    
    //format score
    NSDictionary *saveData = @{@"score" : [NSNumber numberWithUnsignedInteger:self.score],
                               @"date" : [NSDate date],
                               @"time" : [NSNumber numberWithUnsignedInteger:self.timeElapsed]};
    
    //save it to the settings if it's a high score
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *lastScore  = [defaults dictionaryForKey:@"topScore"];
    
    //does a high score exist?
    if (!lastScore) {
        [defaults setObject:saveData forKey:@"topScore"];
    } else {
        if ([lastScore objectForKey:@"score"]) {
            //if this score is the best, save it
            if ([lastScore[@"score"] unsignedIntegerValue] < [saveData[@"score"] unsignedIntegerValue]) {
                [defaults setObject:saveData forKey:@"topScore"];
            }
        }
    }
    [defaults synchronize];
    
    //create the score object
    if (self.leaderboardIdentifier) {
        GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardIdentifier];
        score.value = self.score;
        
        //send to game center
        [self reportScore:score];
    }
    
    //stop the game
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endGame"
                                                        object:self
                                                      userInfo:saveData];
}

@end
