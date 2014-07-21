//
//  AHViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHGameViewController.h"
#import <SpriteKit/SpriteKit.h>

@interface AHGameViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet SKView *gameView;
@property (nonatomic, strong) AHGameScene *gameScene;
@end

@implementation AHGameViewController 

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        self.gameScene = [[AHGameScene alloc] initWithSize:self.gameView.frame.size];
//        [self.gameView presentScene:self.gameScene transition:[SKTransition flipHorizontalWithDuration:.5]];
    } else if (buttonIndex == 1) {
        [self startNewGame];
    }
}

- (IBAction)pause:(id *)sender
{
    self.gameScene.paused = !self.gameScene.paused;
}

- (void)startNewGame
{
    self.gameScene = [[AHGameScene alloc] initWithSize:self.gameView.frame.size];
    self.gameScene.gameDelegate = self;
    [self.gameView presentScene:self.gameScene transition:[SKTransition flipHorizontalWithDuration:.5]];
    
    self.scoreBar.topItem.title = @"0";
    self.timeItem.title = @"0:00";
}

#pragma mark GameSceneProtocol

- (void)gameEndedAt:(NSDate *)time after:(NSUInteger)timeElapsed andScore:(NSUInteger)score
{
    self.gameScene.paused = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[NSString stringWithFormat:@"Congratulations!\nYou scored %i points in %i seconds.", score, timeElapsed] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Main Menu", @"Try Again", nil];
    [alert show];
}

- (void)scoreDidChange:(NSUInteger)score
{
    self.scoreBar.topItem.title = [NSString stringWithFormat:@"%i", score];
}

- (void)timeDidChange:(NSUInteger)elapsed
{
    NSUInteger seconds = elapsed % 60;
    NSUInteger minutes = (elapsed - seconds) / 60;
    self.timeItem.title = [NSString stringWithFormat:@"%i:%.2i", minutes, seconds];
}

- (void)loadView
{
    [super loadView];
    
    self.gameScene = [[AHGameScene alloc] initWithSize:self.gameView.frame.size];
    [self.gameScene setGameDelegate:self];
    [self.gameView presentScene:self.gameScene];
    self.gameView.showsDrawCount = YES;
    self.gameView.showsFPS = YES;
    self.gameView.showsNodeCount = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
