//
//  PhilanderyTests.m
//  PhilanderyTests
//
//  Created by Philandery Andery on 7/1/14.
//  Copyright (c) 2014 Philandery.app. All rights reserved.
//

#import "PCViewController.h"

SpecBegin(PCViewController)

it(@"displays", ^{
    PCViewController *vc = [[PCViewController alloc] init];
    expect(vc.view).willNot.beNil();
    expect(vc.view).to.haveValidSnapshotNamed(@"default");
});

SpecEnd
