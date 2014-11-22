//
//  AHVGameViewController.h
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

@import SpriteKit;

#import "AHDismissViewControllerProtocol.h"
#import "AHGameScene.h"
#import "AHFallingBerriesScene.h"

@interface AHGameViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, weak) id <AHDismissViewControllerProtocol> dismissDelegate;

@end

