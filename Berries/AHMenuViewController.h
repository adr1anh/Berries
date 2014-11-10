//
//  AHMenuViewController.h
//  Berries
//
//  Created by Adrian Hamelink on 22/09/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

@import SpriteKit;

#import "AHFallingBerriesScene.h"
#import "AHDismissViewControllerProtocol.h"
#import "AHGameScene.h"

@interface AHMenuViewController : UIViewController

@property (strong, nonatomic) SKView *backgroundView;
@property (strong, nonatomic) AHFallingBerriesScene *backgroundScene;

@property (nonatomic, weak) id <AHDismissViewControllerProtocol> dismissDelegate;

@end
