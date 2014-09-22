//
//  AHTimeBarButtonItem.h
//  Berries
//
//  Created by Adrian Hamelink on 13/08/14.
//  Copyright (c) 2014 Adrian Hamelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHLabelBarButtonItem : UIBarButtonItem

@property (nonatomic, strong) NSString* label;

- (instancetype)initWithText:(NSString *)text;

@end
