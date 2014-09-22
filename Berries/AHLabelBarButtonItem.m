//
//  AHTimeBarButtonItem.m
//  Berries
//
//  Created by Adrian Hamelink on 13/08/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import "AHLabelBarButtonItem.h"

@interface AHLabelBarButtonItem ()
@property (nonatomic, strong) UILabel* labelView;
@end

@implementation AHLabelBarButtonItem

- (UILabel *)labelView
{
    if (!_labelView) {
        _labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _labelView.textColor = [UIColor blackColor];
        _labelView.font = [UIFont fontWithName:@"KGSecondChancesSolid" size:22];
        _labelView.backgroundColor = [UIColor redColor];
    }
    return _labelView;
}

- (void)setLabel:(NSString *)label
{
    self.labelView.text = label;
}

- (instancetype)initWithText:(NSString *)text
{
    AHLabelBarButtonItem *item = [[AHLabelBarButtonItem alloc] initWithCustomView:self.labelView];
    item.label = text;
    return item;
}

- (instancetype)initWithCustomView:(UIView *)customView
{
    return [super initWithCustomView:customView];
}

@end
