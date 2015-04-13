//
//  UIView+CoreAnimation.h
//  CoreAnimationPlayGround
//
//  Created by Daniel Tavares on 27/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

typedef void(^ExplodeCompletion)(void);

@interface UIView (Explode)

@property (nonatomic, copy) ExplodeCompletion completionCallback;

- (void)lp_explode;
- (void)lp_explodeWithCallback:(ExplodeCompletion)callback;

@end
