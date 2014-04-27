//
//  AHViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 10/02/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "AHMainScene.h"

@interface AHViewController ()

@end

@implementation AHViewController

- (void)loadView
{
    [super loadView];
    CGRect oldFrame = self.view.frame;
    self.view = [[SKView alloc] initWithFrame:oldFrame];
    
    AHMainScene *mainScene = [[AHMainScene alloc] initWithSize:self.view.frame.size];
    [mainScene setBackgroundColor:[UIColor lightGrayColor]];
    [(SKView *)self.view presentScene:mainScene];
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
