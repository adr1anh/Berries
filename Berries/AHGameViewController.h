//
//  AHViewController.h
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHGameScene.h"

@interface AHGameViewController : UIViewController <UIAlertViewDelegate, AHGameSceneDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *scoreBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *timeItem;

@end
