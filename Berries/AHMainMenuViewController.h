//
//  AHMainMenuViewController.h
//  Berries
//
//  Created by Adrian Hamelink on 13/07/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

@import GameKit;
@import SpriteKit;

#import "AHDismissViewControllerProtocol.h"
#import "AHMenuViewController.h"
#import "AHFallingBerriesScene.h"
#import "AHGameViewController.h"

@interface AHMainMenuViewController : AHMenuViewController <AHDismissViewControllerProtocol, GKGameCenterControllerDelegate>

@end
