//
//  AHDismissViewControllerProtocol.h
//  Berries
//
//  Created by Adrian Hamelink on 22/09/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

@protocol AHDismissViewControllerProtocol <NSObject>

-(void)dismissViewController;

@optional

-(void)dismissViewControllerAndStartNewGame;

@end