//
//  BTButton.h
//  StarbucksCount
//
//  Created by Brian Tung on 11/10/14.
//  Copyright (c) 2014 Flame Co. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const BTElementView;
FOUNDATION_EXPORT NSString *const BTElementKeyPath;
FOUNDATION_EXPORT NSString *const BTElementFromValue;
FOUNDATION_EXPORT NSString *const BTElementToValue;

@interface BTButton : UIButton

@property (nonatomic, assign) NSTimeInterval animationDuration UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSArray *animationElements;

@end
