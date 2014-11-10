//
//  AHMenuViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 22/09/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHMenuViewController.h"

@implementation AHMenuViewController

//called when the view controller is created from the storyboard
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //set a SKView as background
    self.backgroundView = [[SKView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:self.backgroundView atIndex:0];
    
    //set a SKScene to show the falling berries
    self.backgroundScene = [[AHFallingBerriesScene alloc] initWithSize:self.view.frame.size];
    [self.backgroundView presentScene:self.backgroundScene];
    self.backgroundScene.backgroundColor = [UIColor colorWithRed:72/255.0 green:127/255.0 blue:0 alpha:1];
}

//generic method to dismiss from storyboard
- (IBAction)dismissSelf:(id)sender
{
    if ([self.dismissDelegate respondsToSelector:@selector(dismissViewController)]) {
        [self.dismissDelegate dismissViewController];
    }
}

@end
