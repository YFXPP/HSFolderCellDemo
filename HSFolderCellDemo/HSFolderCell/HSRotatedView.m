//
//  HSRotatedView.m
//  HSFolderCellDemo
//
//  Created by He Shun on 2018/3/6.
//  Copyright © 2018年 He Shun. All rights reserved.
//

#import "HSRotatedView.h"

@interface HSRotatedView()<CAAnimationDelegate>

@end

@implementation HSRotatedView

#pragma mark public
- (void)addBackView:(CGFloat)height color:(UIColor *)color{
    HSRotatedView * view = [[HSRotatedView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = color;
    view.layer.anchorPoint = CGPointMake(0.5, 1);
    view.layer.transform = [view transform3d];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    self.backView = view;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:height]];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.bounds.size.height - height / 2],
                           [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                           ]];
}


- (CATransform3D)transform3d{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 2.5 / -2000;
    return transform;
}

#pragma mark private
- (void)rotatedX:(CGFloat)angle{
    CATransform3D allTransform = CATransform3DIdentity;
    CATransform3D rotateTransform = CATransform3DMakeRotation(angle, 1, 0, 0);
    allTransform = CATransform3DConcat(allTransform, rotateTransform);
    allTransform = CATransform3DConcat(allTransform, [self transform3d]);
    self.layer.transform = allTransform;
}

#pragma mark animations
- (void)foldingAnimation:(NSString *)timing from:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay hidden:(BOOL)hidden{
    CABasicAnimation * rotateAnimation = [[CABasicAnimation alloc] init];
    rotateAnimation.keyPath = @"transform.rotation.x";
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timing];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:from];
    rotateAnimation.toValue = [NSNumber numberWithFloat:to];
    rotateAnimation.duration = duration;
    rotateAnimation.delegate = self;
    //动画结束后保持在结束后的状态
    rotateAnimation.fillMode = kCAFillModeForwards;
    [rotateAnimation setRemovedOnCompletion:NO];
    rotateAnimation.beginTime = CACurrentMediaTime() + delay;
    
    self.hiddenAfterAnimation = hidden;
    
    [self.layer addAnimation:rotateAnimation forKey:@"rotation.x"];
}

#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    self.layer.shouldRasterize = YES;
    self.alpha = 1;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(self.hiddenAfterAnimation){
        self.alpha = 0;
    }
    
    [self.layer removeAllAnimations];
    self.layer.shouldRasterize = NO;
    [self rotatedX:0];
}






@end
