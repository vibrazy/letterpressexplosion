//
//  UIView+CoreAnimation.m
//  CoreAnimationPlayGround
//
//  Created by Daniel Tavares on 27/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "UIView+CoreAnimation.h"

static NSString *GESTURE_BLOCK = @"GESTURE_BLOCK";

@implementation UIView (CoreAnimation)

float randomFloat()
{
    return (float)rand()/(float)RAND_MAX;
}

- (void)dealloc
{
    NSLog(@"removing %@", self);
}

-(void)setTappedGestureWithBlock:(GESTURE_Tapped)block
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.numberOfTapsRequired=1;
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self,&GESTURE_BLOCK,block, OBJC_ASSOCIATION_COPY);
}

-(void)tapped:(UIGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateEnded)
    {
        GESTURE_Tapped block = (GESTURE_Tapped)objc_getAssociatedObject(self, &GESTURE_BLOCK);
        
        if (block)
        {
            block();
            block = nil;
        }
    }
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (void)explode
{
    
    /*
     [self saveTilesOfSize:(CGSize){256, 256} forImage:big toDirectory:directoryPath usingPrefix:@"bigimage_"];
     dispatch_async(dispatch_get_main_queue(), ^{
     [scrollView setNeedsDisplay];
     });
     */
    float size = self.frame.size.width/5;
    CGSize imageSize = CGSizeMake(size, size);
    
    CGFloat cols = self.frame.size.width / imageSize.width ;
    CGFloat rows = self.frame.size.height /imageSize.height;
    
    int fullColumns = floorf(cols);
    int fullRows = floorf(rows);
    
    CGFloat remainderWidth = self.frame.size.width  -
    (fullColumns * imageSize.width);
    CGFloat remainderHeight = self.frame.size.height -
    (fullRows * imageSize.height );
    
    
    if (cols > fullColumns) fullColumns++;
    if (rows > fullRows) fullRows++;
    
    CGRect originalFrame = self.layer.frame;
    CGRect originalBounds = self.layer.bounds;
    
   
    CGImageRef fullImage = [self imageFromLayer:self.layer].CGImage;
    
    //if its an image, set it to nil
    if ([self isKindOfClass:[UIImageView class]])
    {
        [(UIImageView*)self setImage:nil];
    }
    
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int y = 0; y < fullRows; ++y)
    {
        for (int x = 0; x < fullColumns; ++x)
        {
            CGSize tileSize = imageSize;
            
            if (x + 1 == fullColumns && remainderWidth > 0)
            {
                // Last column
                tileSize.width = remainderWidth;
            }
            if (y + 1 == fullRows && remainderHeight > 0)
            {
                // Last row
                tileSize.height = remainderHeight;
            }
            
            CGRect layerRect = (CGRect){{x*imageSize.width, y*imageSize.height},
                tileSize};
            
            CGImageRef tileImage = CGImageCreateWithImageInRect(fullImage,layerRect);
            
            ParticleLayer *l = [ParticleLayer layer];
            l.frame = layerRect;
            l.contents = (__bridge id)(tileImage);
            l.borderWidth = 0.0f;
            l.borderColor = [UIColor blackColor].CGColor;
            l.particlePath = [self pathForLayer:l parentRect:originalFrame];
            [self.layer addSublayer:l];
            
            CGImageRelease(tileImage);
        }
    }
    
    [self.layer setFrame:originalFrame];
    [self.layer setBounds:originalBounds];

    
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    
    [[self.layer sublayers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ParticleLayer *l = (ParticleLayer *)obj;
        
        //Path
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = l.particlePath.CGPath;
        moveAnim.removedOnCompletion = YES;
        moveAnim.fillMode=kCAFillModeForwards;
        NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],nil];
        [moveAnim setTimingFunctions:timingFunctions];
        
        float r = randomFloat();

        NSTimeInterval speed = 2.35*r;
        
        CAKeyframeAnimation *transformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        CATransform3D startingScale = l.transform;
        CATransform3D endingScale = CATransform3DConcat(CATransform3DMakeScale(randomFloat(), randomFloat(), randomFloat()), CATransform3DMakeRotation(M_PI*(1+randomFloat()), randomFloat(), randomFloat(), randomFloat()));
        
        NSArray *boundsValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:startingScale],
                                 
                                 [NSValue valueWithCATransform3D:endingScale], nil];
        [transformAnim setValues:boundsValues];
        
        NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:speed*.25], nil];
        [transformAnim setKeyTimes:times];
        
        
        timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                    nil];
        [transformAnim setTimingFunctions:timingFunctions];
        transformAnim.fillMode = kCAFillModeForwards;
        transformAnim.removedOnCompletion = NO;
        
        //alpha
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0f];
        opacityAnim.toValue = [NSNumber numberWithFloat:0.f];
        opacityAnim.removedOnCompletion = NO;
        opacityAnim.fillMode =kCAFillModeForwards;
       
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim,transformAnim,opacityAnim, nil];
        animGroup.duration = speed;
        animGroup.fillMode =kCAFillModeForwards;
        animGroup.delegate = self;
        [animGroup setValue:l forKey:@"animationLayer"];
        [l addAnimation:animGroup forKey:nil];
        
        //take it off screen
        [l setPosition:CGPointMake(0, -600)];
        
    }];
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    ParticleLayer *layer = [theAnimation valueForKey:@"animationLayer"];
    
    if (layer)
    {
        //make sure we dont have any more
        if ([[self.layer sublayers] count]==1)
        {
            [self removeFromSuperview];
        }
        else
        {
            [layer removeFromSuperlayer];
        }
    }
}

-(UIBezierPath *)pathForLayer:(CALayer *)layer parentRect:(CGRect)rect
{
    
    UIBezierPath *particlePath = [UIBezierPath bezierPath];
    [particlePath moveToPoint:layer.position];
    
    float r = ((float)rand()/(float)RAND_MAX) + 0.3f;
    float r2 = ((float)rand()/(float)RAND_MAX)+ 0.4f;
    float r3 = r*r2;
    
    int upOrDown = (r <= 0.5) ? 1 : -1;
    
    CGPoint curvePoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    float maxHeight = (self.superview.frame.size.height*0.85) * randomFloat();
    float maxLeftRightShift = 1.f * randomFloat();
    
    CGFloat layerYPosAndHeight = (self.superview.frame.size.height-((layer.position.y+layer.frame.size.height)))*randomFloat();
    CGFloat layerXPosAndHeight = (self.superview.frame.size.width-((layer.position.x+layer.frame.size.width)))*r3;
    
    float endY = self.superview.frame.size.height-self.frame.origin.y;
    
    if (layer.position.x <= rect.size.width*0.5)
    {
        //going left
        endPoint = CGPointMake(-layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown)*maxLeftRightShift,-layerYPosAndHeight);
    }
    else
    {
        endPoint = CGPointMake(layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown+rect.size.width)*maxLeftRightShift, -layerYPosAndHeight);
    }
    
    [particlePath addQuadCurveToPoint:endPoint
                     controlPoint:curvePoint];
    
    return particlePath;
    
}

@end
