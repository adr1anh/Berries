//
//  AHGameViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHGameViewController.h"

@interface AHGameViewController ()

@property (strong, nonatomic) SKView *gameView;
@property (weak, nonatomic) IBOutlet UIView *scoreBarView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) AHGameScene *gameScene;
@property (strong, nonatomic) AHFallingBerriesScene *pauseScene;

@end

@implementation AHGameViewController

//create the game view
- (SKView *)gameView
{
    //lazy instantiation (if the variable isn't initialized, create it, then return it every other time)
    if (!_gameView) {
        
        //create it below the status bar
        CGRect gameViewFrame = CGRectMake(0,
                                          self.scoreBarView.frame.size.height,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height - self.scoreBarView.frame.size.height);
        _gameView = [[SKView alloc] initWithFrame:gameViewFrame];
        
        //since we can only make an SKView transparent on iOS 8, we first make sure the method is available, otherwise we set a background color
        if ([_gameView respondsToSelector:@selector(setAllowsTransparency:)])
            _gameView.allowsTransparency = YES;
        else
            _gameView.backgroundColor = [UIColor colorWithRed:53/255.0 green:116/255.0 blue:64/255.0 alpha:1];
    }
    return _gameView;
}

//called when the end of game alert view (main menu/try again) gets an answer
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //tapped "Main Menu"
    if (buttonIndex == 0) {
        if ([self.dismissDelegate respondsToSelector:@selector(dismissViewController)])
            [self.dismissDelegate dismissViewController];
    }
    
    //tapper "New Game"
    if (buttonIndex == 1) {
        if ([self.dismissDelegate respondsToSelector:@selector(dismissViewControllerAndStartNewGame)])
            [self.dismissDelegate dismissViewControllerAndStartNewGame];
    }
}

- (AHFallingBerriesScene *)pauseScene
{
    if (!_pauseScene) {
        _pauseScene = [[AHFallingBerriesScene alloc] initWithSize:self.gameScene.size];
        _pauseScene.backgroundColor = [UIColor colorWithRed:72/255.0 green:127/255.0 blue:0 alpha:1];
        
        SKLabelNode *pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"KGSecondChancesSolid"];
        pauseLabel.fontColor = [SKColor whiteColor];
        pauseLabel.fontSize = 56.0;
        pauseLabel.text = @"Pause";
        pauseLabel.zPosition = 2;
        pauseLabel.position = CGPointMake(_pauseScene.size.width / 2,
                                          _pauseScene.size.height * 3/4);
        
        [_pauseScene addChild:pauseLabel];
    }
    return _pauseScene;
}

- (IBAction)pausePressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGame" object:nil userInfo:@{@"paused" : @(self.gameScene.paused),
                                                                                                  @"animated" : @(YES)}];
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    button.alpha = .5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled = YES;
        button.alpha = 1;
    });
}

#pragma mark Notifications

//update time label
- (void)updateTime:(NSNotification *)notification
{
    //check if we got a value in the notification's userInfo
    id timeInfo = [notification.userInfo objectForKey:@"time"];
    if (timeInfo) {
        
        //format the time as mm:ss
        NSUInteger elapsed = [(NSNumber *)timeInfo unsignedIntegerValue];
        NSUInteger seconds = elapsed % 60;
        NSUInteger minutes = (elapsed - seconds) / 60;
        
        //set the label
        self.timeLabel.text = [NSString stringWithFormat:@"%lu:%.2lu", (unsigned long) minutes, (unsigned long) seconds];
    }
}

//update score label, similar to updateTime:
- (void)updateScore:(NSNotification *)notification
{
    id scoreInfo = [notification.userInfo objectForKey:@"score"];
    if (scoreInfo) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%lu", [(NSNumber *)scoreInfo unsignedLongValue]];
    }
}

//game is ended
- (void)endGame:(NSNotification *)notification
{
    //remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //check if we got all values from the userInfo
    NSInteger score = [[notification.userInfo objectForKey:@"score"] integerValue];
    NSInteger highScore = [[notification.userInfo objectForKey:@"highScore"] integerValue];
    
    
    NSString *message;
    if (score == highScore) {
        message = [NSString stringWithFormat:@"New High Score!\nYou scored %lu points!", (long) score];
    } else {
        message = [NSString stringWithFormat:@"Congratulations!\nYou scored %lu points!\nBest: %lu", (long) score, (long) highScore];
    }
    //show score and ask what to do
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Main Menu", @"Try Again", nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert show];
    });
}

- (void)pauseGame:(NSNotification *)notification
{
    id pausedInfo = [notification.userInfo objectForKey:@"paused"];
    id animateInfo = [notification.userInfo objectForKey:@"animated"];
    
    if (pausedInfo) {
        BOOL gamePaused = [pausedInfo boolValue];
        
        if (!gamePaused) {
            self.gameScene.paused = !gamePaused;
            self.pauseScene.paused = gamePaused;
            
            if (animateInfo) {
                if ([animateInfo boolValue])
                    [self.gameView presentScene:self.pauseScene  transition:[SKTransition moveInWithDirection:SKTransitionDirectionDown duration:1]];
                else
                    [self.gameView presentScene:self.pauseScene];
            }
        } else {
            if (animateInfo) {
                if ([animateInfo boolValue]) {
                    [self.gameView presentScene:self.gameScene transition:[SKTransition revealWithDirection:SKTransitionDirectionDown duration:1]];
                    self.pauseScene.paused = gamePaused;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.gameScene.paused = !gamePaused;
                    });
                } else {
                    [self.gameView presentScene:self.gameScene];
                }
            }
        }
    }
}

#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    
    //add gradient to the view's background via a CALayer
    CAGradientLayer *viewGradient = [CAGradientLayer layer];
    //set it's frame to it's views bounds
    viewGradient.frame = self.view.bounds;
    //set the colors via an array
    viewGradient.colors = @[(id)[[UIColor colorWithRed:81/255.0 green:149/255.0 blue:13/255.0 alpha:1] CGColor],
                            (id)[[UIColor colorWithRed:38/255.0 green:120/255.0 blue:13/255.0 alpha:1] CGColor]];
    //add the layer to the view
    [self.view.layer insertSublayer:viewGradient atIndex:0];
    
    //same as above but for the score bar
    CAGradientLayer *navigationGradient = [CAGradientLayer layer];
    navigationGradient.frame = self.scoreBarView.bounds;
    navigationGradient.colors = @[(id)[[UIColor colorWithRed:53/255.0 green:116/255.0 blue:64/255.0 alpha:1] CGColor],
                                  (id)[[UIColor colorWithRed:2/255.0 green:64/255.0 blue:12/255.0 alpha:1] CGColor]];
    [self.scoreBarView.layer insertSublayer:navigationGradient atIndex:0];
    
    //create the gameScene (SKScene)
    self.gameScene = [[AHGameScene alloc] initWithSize:self.gameView.frame.size];
    
    //add the gameView (SKView)
    [self.view insertSubview:self.gameView belowSubview:self.scoreBarView];
    
    //present the scene in the view
    [self.gameView presentScene:self.gameScene];
}

//register all notification observers
- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateScore:) name:@"scoreChanged" object:nil];
    [center addObserver:self selector:@selector(endGame:) name:@"endGame" object:nil];
    [center addObserver:self selector:@selector(updateTime:) name:@"updateTime" object:nil];
    [center addObserver:self selector:@selector(pauseGame:) name:@"pauseGame" object:nil];
    
    [super viewWillAppear:animated];
}

@end
