//
//  PCChooseFromAddressBookViewController.m
//  Philandery
//
//  Created by Phil Andery on 7/2/14.
//  Copyright (c) 2014 Philandery.app. All rights reserved.
//

#import "PCChooseFromAddressBookViewController.h"

@interface PCChooseFromAddressBookViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, readonly, strong) UITextField *lookupByNameField;
@property(nonatomic, readonly, strong) NSArray *lookupByNameFieldVerticalConstraints;
@property(nonatomic, readonly, strong) RHAddressBook *addressBook;
@property(nonatomic, readonly, strong) NSArray *people;
@property(nonatomic, readonly, strong) UITableView *peopleTableView;
@end

@implementation PCChooseFromAddressBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self setupKeyboard];
    [self setupAddressBook];
}

- (void)setupKeyboard
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardOffScreen:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    [self updateLookupByNameFieldPosition:-CGRectGetHeight(keyboardFrame)/1.5];
}

-(void)keyboardOffScreen:(NSNotification *)notification
{
    [self updateLookupByNameFieldPosition:0];
}

- (void)updateLookupByNameFieldPosition:(CGFloat)position
{
    NSLayoutConstraint *verticalConstraint = self.lookupByNameFieldVerticalConstraints.lastObject;
    verticalConstraint.constant = position;
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)setupAddressBook
{
    RHAuthorizationStatus status = [RHAddressBook authorizationStatus];
    switch (status) {
        case RHAuthorizationStatusDenied:
        case RHAuthorizationStatusRestricted:
            [self addressBookDeniedOrRestricted];
            break;
        case RHAuthorizationStatusNotDetermined:
            _addressBook = [[RHAddressBook alloc] init];
            [self requestAddressBookAccess];
            break;
        case RHAuthorizationStatusAuthorized:
            _addressBook = [[RHAddressBook alloc] init];
            [self setup];
            break;
    }
}

- (void)requestAddressBookAccess
{
    @weakify(self);
    [self.addressBook requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
        @strongify(self);
        if (granted && !error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setup];
            });
        } else {
            [self addressBookDeniedOrRestricted];
        }
    }];
}

- (void)addressBookDeniedOrRestricted
{
    // TODO: tell the user to enable access in settings
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Address Book Access"
                                                    message:@"Access to the address book is currently denied or restricted."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setup
{
    UITextField *lookupByNameField = [[UITextField alloc] init];
    _lookupByNameField = lookupByNameField;
    lookupByNameField.textColor = [UIColor blackColor];
    lookupByNameField.placeholder = @"Enter a Name ...";
    [lookupByNameField addTarget:self action:@selector(lookupByName:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:lookupByNameField];
    [self.lookupByNameField alignCenterXWithView:self.view predicate:@"0"];
    _lookupByNameFieldVerticalConstraints = [self.lookupByNameField alignCenterYWithView:self.view predicate:@"0"];
    [lookupByNameField becomeFirstResponder];
    
    UITableView *peopleTableView = [[UITableView alloc] init];
    _peopleTableView = peopleTableView;
    peopleTableView.dataSource = self;
    peopleTableView.delegate = self;
    peopleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    peopleTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:peopleTableView];
    [peopleTableView constrainTopSpaceToView:self.lookupByNameField predicate:@"12"];
    [peopleTableView alignCenterXWithView:self.view predicate:@"0"];
    [peopleTableView constrainWidthToView:self.view predicate:@"0"];
    [peopleTableView constrainHeightToView:self.view predicate:@"0"];
}

- (void)lookupByName:(id)sender
{
    _people = [self.addressBook peopleWithName:self.lookupByNameField.text];
    [self.peopleTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(self.people.count, 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.people.count < indexPath.row + 1) {
        return nil;
    }
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        RHPerson *person = (RHPerson *)self.people[indexPath.row];
        cell.textLabel.text = person.name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
