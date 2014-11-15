//
//  BTButton.m
//  StarbucksCount
//
//  Created by Brian Tung on 11/10/14.
//  Copyright (c) 2014 Flame Co. All rights reserved.
//

#import "BTButton.h"

NSString *const BTElementView = @"BTElementView";
NSString *const BTElementKeyPath = @"BTElementKeyPath";
NSString *const BTElementFromValue = @"BTElementFromValue";
NSString *const BTElementToValue = @"BTElementToValue";

#define kDURATION   0.35

@interface BTButton ()

@property (nonatomic, strong) CAShapeLayer *shape;
@property (nonatomic, assign) CGFloat radius;

@end

@implementation BTButton

- (void)layoutSubviews
{
    // Yay for math!
    CGFloat x = MAX(CGRectGetMidX(self.frame), self.superview.frame.size.width - CGRectGetMidX(self.frame));
    CGFloat y = MAX(CGRectGetMidY(self.frame), self.superview.frame.size.height - CGRectGetMidY(self.frame));
    self.radius = sqrt(x*x + y*y);
    
    self.shape.frame = (CGRect){CGRectGetMidX(self.frame) - self.radius,
        CGRectGetMidY(self.frame) - self.radius, self.radius * 2, self.radius * 2};
    self.shape.anchorPoint = CGPointMake(0.5, 0.5);
    self.shape.path = [UIBezierPath bezierPathWithOvalInRect:(CGRect){0, 0, self.radius * 2, self.radius * 2}].CGPath;
}

- (void)awakeFromNib
{
    self.shape = [CAShapeLayer layer];
    self.shape.fillColor = self.tintColor.CGColor;
    self.shape.transform = CATransform3DMakeScale(0.0001, 0.0001, 0.0001);
    
    [self.superview.layer insertSublayer:self.shape atIndex:0];
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = self.frame.size.height / 4;
    
    NSLog(@"%@", self.titleLabel.text);
    
    [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonPressed:(UIButton *)sender
{
    // Reset
    self.layer.borderWidth = 0;
    
    CABasicAnimation *scaleAnimation = [self animateKeyPath:@"transform.scale"
                                                  fromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0001, 0.0001, 0.0001)]
                                                    toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]
                                                     timing:kCAMediaTimingFunctionEaseIn];
    [self.shape addAnimation:scaleAnimation forKey:@"scaleUp"];
    
    CABasicAnimation *borderAnimation = [self animateKeyPath:@"borderWidth" fromValue:@0 toValue:@1 timing:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:borderAnimation forKey:@"borderUp"];
    
    for (NSDictionary *element in self.animationElements) {
        if ([element[BTElementKeyPath] isEqualToString:@"textColor"] && [element[BTElementView] isKindOfClass:[UILabel class]]) {
            [UIView transitionWithView:element[BTElementView]
                              duration:kDURATION
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [(UILabel *)element[BTElementView] setTextColor:element[BTElementToValue]];
                            }
                            completion:nil];
        } else if ([element[BTElementKeyPath] isEqualToString:@"tintColor"] && [element[BTElementView] isKindOfClass:[UIButton class]]) {
            [UIView transitionWithView:element[BTElementView]
                              duration:kDURATION
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                [(UIButton *)element[BTElementView] setTintColor:element[BTElementToValue]];
                            }
                            completion:nil];
        } else {
            CABasicAnimation *elementAnimation = [self animateKeyPath:element[BTElementKeyPath]
                                                            fromValue:element[BTElementFromValue]
                                                              toValue:element[BTElementToValue]
                                                               timing:kCAMediaTimingFunctionEaseIn];
            [element[BTElementView] addAnimation:elementAnimation forKey:element[BTElementKeyPath]];
        }
    }
}

- (CABasicAnimation *)animateKeyPath:(NSString *)keyPath fromValue:(id)from toValue:(id)to timing:(NSString *)timing
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = from;
    animation.toValue = to;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timing];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = kDURATION;
    return animation;
}

@end
