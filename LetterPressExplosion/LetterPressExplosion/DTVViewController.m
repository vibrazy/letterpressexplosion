//
//  DTVViewController.m
//  LetterPressExplosion
//
//  Created by Daniel Tavares on 28/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "DTVViewController.h"
#import "UIView+CoreAnimation.h"

@interface DTVViewController ()

@end

@implementation DTVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    __unsafe_unretained typeof(self) weakSelf = self;
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setTappedGestureWithBlock:^{
        //  [weakSelf createLabel1];
        //[weakSelf createLabel2];
        [weakSelf createLetterPressImages];
    }];
    
    UIView *bob = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [bob setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:bob];
    
    __unsafe_unretained typeof(bob) bobSelf = bob;
    [bob setTappedGestureWithBlock:^{
        [bobSelf explode];
        [bobSelf setTappedGestureWithBlock:nil];
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
        [weakSelf explode];
        [weakSelf setTappedGestureWithBlock:nil];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
