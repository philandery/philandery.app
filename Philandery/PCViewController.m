//
//  PCViewController.m
//  Philandery
//
//  Created by Phil Andery on 7/1/14.
//  Copyright (c) 2014 Philandery.app. All rights reserved.
//

#import "PCViewController.h"
#import "PCChooseFromAddressBookViewController.h"

@implementation PCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *deviceLabel = [[UILabel alloc] init];
    deviceLabel.text = [self deviceId];
    [self.view addSubview:deviceLabel];
    [deviceLabel alignCenterWithView:self.view];
    
    UIButton *chooseFromAddressBookButton = [[UIButton alloc] init];
    [chooseFromAddressBookButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chooseFromAddressBookButton setTitle:@"Choose From Address Book" forState:UIControlStateNormal];
    [self.view addSubview:chooseFromAddressBookButton];
    [chooseFromAddressBookButton alignTopEdgeWithView:deviceLabel predicate:@"20"];
    [chooseFromAddressBookButton alignCenterXWithView:deviceLabel predicate:@"0"];
    [chooseFromAddressBookButton addTarget:self action:@selector(chooseFromAddressBookTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSString *)deviceId
{
    return [Identify deviceId];
}

- (void)chooseFromAddressBookTapped:(id)sender
{
    PCChooseFromAddressBookViewController *vc = [[PCChooseFromAddressBookViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
