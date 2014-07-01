//
//  PCViewController.m
//  Philandery
//
//  Created by Phil Andery on 7/1/14.
//  Copyright (c) 2014 Philandery.app. All rights reserved.
//

#import "PCViewController.h"

@implementation PCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel *deviceLabel = [[UILabel alloc] init];
    deviceLabel.text = [self deviceId];
    [self.view addSubview:deviceLabel];
    [deviceLabel alignCenterWithView:self.view];
}

- (NSString *)deviceId
{
    return [Identify deviceId];
}

@end
