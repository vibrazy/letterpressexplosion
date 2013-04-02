//
//  UIView+CoreAnimation.h
//  CoreAnimationPlayGround
//
//  Created by Daniel Tavares on 27/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objc/runtime.h"
#import <QuartzCore/QuartzCore.h>
#import "ParticleLayer.h"


typedef void(^GESTURE_Tapped)(void);

float randomFloat();

@interface UIView (CoreAnimation)
- (void)explode;
-(void)setTappedGestureWithBlock:(GESTURE_Tapped)block;
@end
