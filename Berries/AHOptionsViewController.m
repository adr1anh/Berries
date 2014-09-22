//
//  AHOptionsViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 18/08/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHOptionsViewController.h"

@interface AHOptionsViewController ()
@property (strong, nonatomic) IBOutlet SKView *backgroundView;
@property (strong, nonatomic) AHFallingBerriesScene *backgroundScene;
@end

@implementation AHOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundScene = [[AHFallingBerriesScene alloc] initWithSize:self.backgroundView.frame.size];
    [self.backgroundView presentScene:self.backgroundScene];
    self.backgroundScene.backgroundColor = [UIColor colorWithRed:0.25 green:0.7 blue:1/3 alpha:0.5];
    self.backgroundScene.velocity = 0.75;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
