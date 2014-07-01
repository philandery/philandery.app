//
//  PhilanderyTests.m
//  PhilanderyTests
//
//  Created by Philandery Andery on 7/1/14.
//  Copyright (c) 2014 Philandery.app. All rights reserved.
//

#import "PCViewController.h"

SpecBegin(PCViewController)

__block id mockIdentify = nil;

beforeEach(^{
    mockIdentify = [OCMockObject mockForClass:[Identify class]];
    [[[mockIdentify stub] andReturn:@"device id"] deviceId];
});

afterEach(^{
    [mockIdentify stopMocking];
});

it(@"displays device ID", ^{
    PCViewController *vc = [[PCViewController alloc] init];
    expect(vc.view).willNot.beNil();
    expect(vc.view).to.haveValidSnapshotNamed(@"default");
});

SpecEnd
