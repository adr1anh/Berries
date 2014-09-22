//
//  AHMainMenuViewController.m
//  Berries
//
//  Created by Adrian Hamelink on 13/07/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHMainMenuViewController.h"
#import "AHFallingBerriesScene.h"

@interface AHMainMenuViewController ()
@property (strong, nonatomic) IBOutlet SKView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) AHFallingBerriesScene *backgroundScene;
@end

@implementation AHMainMenuViewController
- (IBAction)newGame:(id)sender {
    self.backgroundScene.paused = YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.backgroundScene = [[AHFallingBerriesScene alloc] initWithSize:self.backgroundView.frame.size];
    [self.backgroundView presentScene:self.backgroundScene];
    self.backgroundView.showsFPS = YES;
    self.backgroundScene.backgroundColor = [UIColor colorWithRed:0.25 green:0.7 blue:1/3 alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
