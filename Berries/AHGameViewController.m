//
//  AHViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHGameViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "AHMainScene.h"

@interface AHGameViewController ()
@property (nonatomic, strong) AHMainScene *gameScene;
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
        self.gameScene = [[AHMainScene alloc] initWithSize:self.view.frame.size];
        [(SKView *)self.view presentScene:self.gameScene transition:[SKTransition flipHorizontalWithDuration:.5]];
    } else if (buttonIndex == 1) {
        self.gameScene = [[AHMainScene alloc] initWithSize:self.view.frame.size];
        [(SKView *)self.view presentScene:self.gameScene transition:[SKTransition flipHorizontalWithDuration:.5]];
    }
}

- (void)startNewGame
{
    
}

- (void)loadView
{
    [super loadView];
    CGRect oldFrame = self.view.frame;
    self.view = [[SKView alloc] initWithFrame:oldFrame];
    
    self.gameScene = [[AHMainScene alloc] initWithSize:self.view.frame.size];
    [(SKView *)self.view presentScene:self.gameScene];
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
