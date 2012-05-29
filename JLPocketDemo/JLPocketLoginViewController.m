//
//  JLPocketLoginViewController.m
//  JLPocketDemo
//
//  Created by Jason Larsen on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JLPocketLoginViewController.h"

@interface JLPocketLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation JLPocketLoginViewController
@synthesize completion = _completion;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;

- (IBAction)saveLogin:(id)sender
{
    // do specified action with username and password
    if (self.completion) self.completion(self.usernameField.text, self.passwordField.text);
    
    // and close the dialog
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
