//
//  LetterPressExplosionTests.m
//  LetterPressExplosionTests
//
//  Created by Daniel Tavares on 28/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "LetterPressExplosionTests.h"
#import "UIView+Explode.h"
@implementation LetterPressExplosionTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view lp_explodeWithCallback:^{
        NSLog(@"callback");
    }];
}

@end
