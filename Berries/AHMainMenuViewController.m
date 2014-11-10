//
//  AHMainMenuViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 13/07/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHMainMenuViewController.h"

@interface AHMainMenuViewController ()

@property BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;

@end

@implementation AHMainMenuViewController

#pragma mark - Game Center

//Make sure the player is signed in to game center
-(void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        
        //make sure it's created then show it
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        
        //log the error
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        //success
        else if ([GKLocalPlayer localPlayer].authenticated) {
            self.gameCenterEnabled = YES;
            
            //load leaderboard
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                
                //log the error
                if (error)
                    NSLog(@"%@", [error localizedDescription]);
                else
                    self.leaderboardIdentifier = leaderboardIdentifier;
            }];
            
        } else
            self.gameCenterEnabled = NO;
    };
}

//dismiss game center view controller when it tells us it's finished
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//called when leaderboard button is tapped
- (IBAction)showLeaderboard:(id)sender {
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    
    gameCenterViewController.gameCenterDelegate = self;
    
    gameCenterViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gameCenterViewController.leaderboardIdentifier = self.leaderboardIdentifier;
    
    [self presentViewController:gameCenterViewController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //start game center
    [self authenticateLocalPlayer];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //segue can be either "game" or "credits" so we compare the segue identifier
    
    if ([segue.identifier isEqualToString:@"credits"]) {
        
        //check it's class to make sure it has the AHDismissViewControllerProtocol
        if ([segue.destinationViewController isMemberOfClass:[AHMenuViewController class]]) {
            
            //pause the berries from falling
            self.backgroundScene.paused = YES;
            
            //set the delegate so we can dismiss the controller itself
            AHMenuViewController *aboutViewController = (AHMenuViewController *) segue.destinationViewController;
            aboutViewController.dismissDelegate = self;
        }
    }
    
    //same as credits
    if ([segue.identifier isEqualToString:@"game"]) {
        
        if ([segue.destinationViewController isKindOfClass:[AHGameViewController class]]) {
            
            self.backgroundScene.paused = YES;
            
            AHGameViewController *gameViewController = (AHGameViewController *) segue.destinationViewController;
            gameViewController.dismissDelegate = self;
        }
    }
}

//called from the presented view controller by the AHDismissViewControllerProtocol
- (IBAction)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //restart falling berries animation
    self.backgroundScene.paused = NO;
}

//same as dismissViewController: but calls the game segue after dismissal
-(void)dismissViewControllerAndStartNewGame
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        [self performSegueWithIdentifier:@"game" sender:self];
    }];
    self.backgroundScene.paused = NO;
}

@end
