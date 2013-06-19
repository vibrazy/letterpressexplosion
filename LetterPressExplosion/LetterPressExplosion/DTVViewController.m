//
//  DTVViewController.m
//  LetterPressExplosion
//
//  Created by Daniel Tavares on 28/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "DTVViewController.h"
#import "UIView+Explode.h"
#import "objc/runtime.h"

typedef void(^GESTURE_Tapped)(void);
static NSString *GESTURE_BLOCK = @"GESTURE_BLOCK";

@interface UIView (PrivateExtensions)

-(void)setTappedGestureWithBlock:(GESTURE_Tapped)block;

@end

@implementation DTVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self createLetterPressImages];
    
    __unsafe_unretained typeof(self) weakSelf = self;
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setTappedGestureWithBlock:^{
        [weakSelf createLetterPressImages];
    }];
}
-(void)createLetterPressImages
{
    UIImage *letterPressImage = [UIImage imageNamed:@"letterpress.png"];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:letterPressImage];
    [imgV setContentMode:UIViewContentModeScaleAspectFit];
    [imgV setCenter:self.view.center];
    
    __unsafe_unretained typeof(imgV) weakSelf = imgV;
    [self.view addSubview:imgV];
    
    [imgV setTappedGestureWithBlock:^{
        [weakSelf lp_explode];
        [weakSelf setTappedGestureWithBlock:nil];
    }];
}


@end

@implementation UIView (PrivateExtensions)

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

@end
