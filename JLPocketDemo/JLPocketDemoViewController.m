//
//  JLPocketDemoViewController.m
//  JLPocketDemo
//
//  Created by Jason Larsen on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JLPocketDemoViewController.h"
#import "JLPocketLoginViewController.h"
#import "JLPocket.h"

@interface JLPocketDemoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end

@implementation JLPocketDemoViewController
@synthesize webview;

- (void)pocketCurrentPage {
	NSString *pageTitle = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
	[JLPocket save:self.webview.request.URL title:pageTitle completion:^(NSString *response, NSString *error) {
		if (error) {
			NSLog(@"Error saving link: %@", error);
		}
		else {
			NSLog(@"Link saved: %@", response);
		}
	}];
}

- (IBAction)pressedPocket:(id)sender
{	
	// authenticate if neccessary, else just save link
    if (![JLPocket isAuthenticated]) {
		[self performSegueWithIdentifier:@"ShowLogin" sender:nil];
    }
	else {
		[self pocketCurrentPage];
	}
}

- (IBAction)pressedClearKeys:(id)sender
{
	[JLPocket clearFromKeychain];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowLogin"]) {
		JLPocketLoginViewController *loginViewController = segue.destinationViewController;
		loginViewController.completion = ^(NSString *username, NSString *password) {
			[JLPocket authUsername:username password:password completion:^(NSString *response, NSString *error) {
				if (error) {
					NSLog(@"Error authenticating: %@", error);
				}
				else {
					// We authenticated correctly. Go ahead and save.
					[self pocketCurrentPage];
				}
			}];
		};
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
