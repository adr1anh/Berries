//
//  AHViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHGameViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "AHGameScene.h"

@interface AHGameViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet SKView *gameView;
@property (nonatomic, strong) AHGameScene *gameScene;
@end

@implementation AHGameViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(endGame:) name:@"EndGame" object:nil];
}

- (void)endGame:(NSNotification *)notification
{
    self.gameScene.paused = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You lost" message:@"Try again!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Main Menu", @"Restart", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.gameScene = [[AHGameScene alloc] initWithSize:self.gameView.frame.size];
        [self.gameView presentScene:self.gameScene transition:[SKTransition flipHorizontalWithDuration:.5]];
    } else if (buttonIndex == 1) {
        self.gameScene = [[AHGameScene alloc] initWithSize:self.gameView.frame.size];
        [self.gameView presentScene:self.gameScene transition:[SKTransition flipHorizontalWithDuration:.5]];
    }
}

- (void)startNewGame
{
    
}

- (void)loadView
{
    [super loadView];
    
    self.gameScene = [[AHGameScene alloc] initWithSize:self.gameView.frame.size];
    [self.gameView presentScene:self.gameScene];
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
