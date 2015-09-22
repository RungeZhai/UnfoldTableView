//
//  UnfoldTableViewCell.m
//  UnfoldTableViewCellDemo
//
//  Created by liuge on 9/22/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "UnfoldTableViewCell.h"

CGFloat kAnimationDuration = .2;

static dispatch_semaphore_t animationSemaphore;

@implementation UnfoldTableViewCell


+ (void)initialize {
    animationSemaphore = dispatch_semaphore_create(1);
}

- (void)didMoveToSuperview {
    if (!self.superview) return;
        
    [self performUnfoldAnimation];
}

- (void)performUnfoldAnimation {
    CALayer *layer = self.layer;
    
    // 1. change layer's anchorPoint and position so that we can rotate around the top edge
    layer.anchorPoint = (CGPoint){.5, 0};
    CGPoint position = layer.position;
    position.y -= self.bounds.size.height / 2;
    layer.position = position;
    
    CATransform3D transform = CATransform3DIdentity;
    
    CGFloat offset = self.bounds.size.height;
    CGFloat perspectiveD = offset * 4;
    CGFloat scale = 1 - offset / perspectiveD;
    
    // 2. make scene perspective
    transform.m34 = -1 / perspectiveD;
    
    // 3. move towards eye, otherwise the layer we rotated will be hidden by other layers behind it
    transform = CATransform3DTranslate(transform, 0, 0, offset);
    
    // 4. make it proportionally smaller as it is enlarged by moving towards eye
    transform = CATransform3DScale(transform, scale, scale, 1);
    
    // 5. rotate to make unfold effect when rotating back
    layer.transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    
    // 6. add shadow effect
    UIView *shadow = [[UIView alloc] initWithFrame:self.bounds];
    shadow.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    [self addSubview:shadow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(animationSemaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /*
             *  As the whole transform is so complex that if we transform directly to
             *  CATransform3DIdentity, the behavior is not as expected and is very weired.
             *  The solution we use here is we first rotate back to the scene of step 4
             *  which is visually the same as the original scene, and then set the transform
             *  back to CATransform3DIdentity once the animation has completed.
             */
            [UIView animateWithDuration:kAnimationDuration
                             animations:^{
                                 layer.transform = transform;
                                 shadow.backgroundColor = [UIColor clearColor];
                             }
                             completion:^(BOOL finished) {
                                 layer.transform = CATransform3DIdentity;
                                 [shadow removeFromSuperview];
                                 dispatch_semaphore_signal(animationSemaphore);
                             }];
        });
    });
}

@end
