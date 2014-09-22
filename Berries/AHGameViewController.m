//
//  AHViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHGameViewController.h"
#import "AHLabelBarButtonItem.h"
#import <SpriteKit/SpriteKit.h>

@interface AHGameViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet SKView *gameView;
//@property (strong, nonatomic) AHLabelBarButtonItem *timeItem;
//@property (strong, nonatomic) AHLabelBarButtonItem *scoreItem;
@property (strong, nonatomic) UIBarButtonItem *timeItem;
@property (strong, nonatomic) UIBarButtonItem *scoreItem;
@property (strong, nonatomic) UIBarButtonItem *pauseItem;
@property (nonatomic, strong) AHGameScene *gameScene;
@end

@implementation AHGameViewController 

//- (AHLabelBarButtonItem *)timeItem
//{
//    if (!_timeItem)
//    {
//        _timeItem = [[AHLabelBarButtonItem alloc] initWithText:@"0:00"];
//    }
//    return _timeItem;
//}
//
//- (AHLabelBarButtonItem *)scoreItem
//{
//    if (!_scoreItem)
//    {
//        _scoreItem = [[AHLabelBarButtonItem alloc] initWithText:@"2"];
//    }
//    return _scoreItem;
//}

- (UIBarButtonItem *)timeItem
{
    if (!_timeItem)
    {
        _timeItem = [[UIBarButtonItem alloc] initWithTitle:@"0:00" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return _timeItem;
}

- (UIBarButtonItem *)scoreItem
{
    if (!_scoreItem)
    {
        _scoreItem = [[UIBarButtonItem alloc] initWithTitle:@"420" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return _scoreItem;
}

- (UIBarButtonItem *)pauseItem
{
    if (!_pauseItem)
    {
        _pauseItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause:)];
    }
    return _pauseItem;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.navigationBar setItems:@[self.timeItem, self.pauseItem, self.scoreItem]];
    NSLog(@"%@", self.navigationBar.items);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[NSString stringWithFormat:@"Congratulations!\nYou scored %lu points in %lu seconds.", (unsigned long) score, (unsigned long) timeElapsed] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Main Menu", @"Try Again", nil];
    [alert show];
}

- (void)scoreDidChange:(NSUInteger)score
{
    self.scoreItem.title = [NSString stringWithFormat:@"%ld", (unsigned long) score];
}

- (void)timeDidChange:(NSUInteger)elapsed
{
    NSUInteger seconds = elapsed % 60;
    NSUInteger minutes = (elapsed - seconds) / 60;
    self.timeItem.title = [NSString stringWithFormat:@"%lu:%.2lu", (unsigned long) minutes, (unsigned long) seconds];
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
