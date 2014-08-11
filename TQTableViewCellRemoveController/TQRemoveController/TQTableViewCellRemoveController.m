//
//  TQTableViewCellRemoveController.m
//  TQTableViewCellRemoveController
//
//  Created by qfu on 8/11/14.
//  Copyright (c) 2014 qfu. All rights reserved.
//

#import "TQTableViewCellRemoveController.h"
#import "POP.h"

#define TURN_R 480

@interface TQTableViewCellRemoveController()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UITableViewCell *handlingViewCell;

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic,strong) POPAnimatableProperty *animatableProperty;

@end


@implementation TQTableViewCellRemoveController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlepanGestureRecognizer:)];
        self.panGestureRecognizer.maximumNumberOfTouches = 1;
        self.panGestureRecognizer.delegate = self;
        [self.tableView addGestureRecognizer:self.panGestureRecognizer];
        
        self.animatableProperty = [POPAnimatableProperty propertyWithName:@"TQTableViewCellAnimatableProperty"
                                                              initializer:^(POPMutableAnimatableProperty *prop){
                                                                  prop.writeBlock = ^(UIView *view, const CGFloat values[]) {
                                                                      
                                                                      view.transform = [self transformWithPoint:CGPointMake(values[0], values[1])];
                                                                      view.alpha     = (view.bounds.size.width - fabsf(values[0]))/view.bounds.size.width;
                                                                      
                                                                  };
                                                                  prop.readBlock = ^(UIView *view, CGFloat values[]) {
                                                                      
                                                                      values[0] = view.transform.tx;
                                                                      values[1] = view.transform.ty;
                                                                  };
                                                                  
                                                                  prop.threshold = 1.0;
                                                              }];
        
    }
    return self;
}

#pragma mark - UIPanGestureRecognizer

- (void)handlepanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer translationInView:self.tableView];
    CGPoint locationPoint = [panGestureRecognizer locationInView:self.tableView];
    
    switch (panGestureRecognizer.state)
    {
        case UIGestureRecognizerStatePossible:
        {
            
        }
            break;
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:locationPoint];
            
            self.handlingViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.handlingViewCell)
            {
                self.handlingViewCell.transform = [self transformWithPoint:point];
                self.handlingViewCell.alpha     = (panGestureRecognizer.view.bounds.size.width - fabsf(point.x))/ panGestureRecognizer.view.bounds.size.width;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.handlingViewCell)
            {
                CGPoint velocity = [panGestureRecognizer velocityInView:self.tableView];
                
                if (fabsf(point.x) > panGestureRecognizer.view.bounds.size.width / 2 || fabsf(velocity.x) > 2000)
                {
                    NSInteger k = point.x > 0 ? 1 : -1;
                    
                    POPSpringAnimation *anim = [POPSpringAnimation animation];
                    anim.property = self.animatableProperty;
                    anim.springBounciness = 0;
                    anim.springSpeed = 15;
                    anim.velocity = [NSValue valueWithCGPoint:velocity];
                    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(panGestureRecognizer.view.bounds.size.width * k, point.y)];
                    [anim setCompletionBlock:^(POPAnimation *animation, BOOL completion){
                        
                        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.handlingViewCell];
                        
                        if (indexPath && self.delegate && [self.delegate respondsToSelector:@selector(didRemoveTableViewCellWithIndexPath:)])
                        {
                            [self.delegate didRemoveTableViewCellWithIndexPath:indexPath];
                        }
                        
                        self.handlingViewCell.alpha = 0;
                        
                    }];
                    [self.handlingViewCell pop_addAnimation:anim forKey:@"cellDeleteAnimation"];
                    
                }
                else
                {   
                    POPSpringAnimation *anim = [POPSpringAnimation animation];
                    anim.property = self.animatableProperty;
                    anim.springBounciness = 15;
                    anim.springSpeed = 15;
                    anim.velocity = [NSValue valueWithCGPoint:[panGestureRecognizer velocityInView:self.tableView]];
                    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
                    [self.handlingViewCell pop_addAnimation:anim forKey:@"cellBackAnimation"];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isEqual:self.tableView])
    {
        UIView *cell = [gestureRecognizer view];
        CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
        
        // Check for horizontal gesture
        if (fabsf(translation.x) > fabsf(translation.y))
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isEqual:self.tableView])
    {
        UIView *cell = [gestureRecognizer view];
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:[cell superview]];
        
        if (fabsf(translation.x) > fabsf(translation.y))
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
    
    return NO;
}

#pragma mark - TransformWithPoint

- (CGAffineTransform )transformWithPoint:(CGPoint)point
{
    CGFloat Px = point.x;
    
    if (fabsf(Px) <=50)
    {
        Px = 0;
    }
    else
    {
        Px = point.x - (50 * point.x/fabsf(point.x));
    }
    
    double r2 = pow(TURN_R, 2);
    double x2 = pow(Px, 2);
    
    double y = sqrt(r2 - x2);
    
    CGFloat offsetY = TURN_R - y;
    CGFloat offsetX = point.x;
    
    double rad = atan(Px/sqrt(r2 - x2));
    
    return CGAffineTransformRotate(CGAffineTransformMakeTranslation(offsetX, offsetY), rad);
}

@end
