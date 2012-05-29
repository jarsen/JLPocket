//
//  JLPocket.m
//
//  Created by Jason Larsen on 5/25/12.
//  Copyright (c) 2012 Jason Larsen. All rights reserved.
//	http://jasonlarsen.me

#import "JLPocket.h"
#import "NSString+URLEncode.h"
#import "SSKeychain.h"

@implementation JLPocket

#pragma mark - API Key
static NSString *apikey = @"yourAPIKeyHere";	//Enter your apikey here : get one at http://getpocket.com/api/signup/ 
static NSString *nameOfYourApp = @"JLPocket"; //Enter the name of your application here (optional - for user-agent string)

#pragma mark - Keychain Constants
static NSString *serviceName = @"Pocket";


#pragma mark - Authentication

+ (BOOL)isAuthenticated
{
    NSArray *accounts = [SSKeychain accountsForService:serviceName];
    if (accounts.count == 0) {
        NSLog(@"No account saved");
        return NO;
    }
    return YES;
}

+ (BOOL)saveUserToKeychain:(NSString *)username password:(NSString *)password
{
    NSError *error;
    [SSKeychain setPassword:password forService:serviceName account:username error:&error];
    if ([error code] != SSKeychainErrorNone) {
        NSLog(@"Error saving account information: %@", error);
        return NO;
    }
    return YES;
}

+ (JLPocketCompletionBlock)createLoginBlockForUser:(NSString *)username password:(NSString *)password completionBlock:(JLPocketCompletionBlock)completion
{
    return ^(NSString *response, NSString *error){
        if (!error) {
			[JLPocket saveUserToKeychain:username password:password];
		}
        completion(response, error);
    };
}

+ (void)authUsername:(NSString *)username password:(NSString *)password completion:(JLPocketCompletionBlock)completion
{
	
	JLPocket *pocket = [[JLPocket alloc] init];
    JLPocketCompletionBlock newCompletion = [JLPocket createLoginBlockForUser:username password:password completionBlock:completion];
	[pocket sendRequest:@"auth" username:username password:password params:nil completion:newCompletion];
}

+ (void)signupWithUsername:(NSString *)username password:(NSString *)password completion:(JLPocketCompletionBlock)completion
{
	
	JLPocket *pocket = [[JLPocket alloc] init];
    JLPocketCompletionBlock newCompletion = [JLPocket createLoginBlockForUser:username password:password completionBlock:completion];
	[pocket sendRequest:@"signup" username:username password:password params:nil completion:newCompletion];
	
}

// removes whatever account information for Pocket stored in the keychain
// this is good for if they change their password and all of a sudden you're not authenticating anymore
// perhaps include in the error handling portion of your block
+ (void)clearFromKeychain
{
	NSError *error;
	NSArray *accounts = [SSKeychain accountsForService:serviceName error:&error];
	if ([error code] == SSKeychainErrorNone) {
		[accounts enumerateObjectsUsingBlock:^(id account, NSUInteger idx, BOOL *stop) {
			NSError *deleteError;
			NSString *accountName = [account objectForKey:kSSKeychainAccountKey];
			[SSKeychain deletePasswordForService:serviceName account:accountName error:&deleteError];
			if ([deleteError code] != SSKeychainErrorNone) {
				NSLog(@"Error deleting: %@", deleteError);
			}
		}];
	}
	else {
		NSLog(@"Error getting accounts: %@", error);
	}
}

#pragma mark - Saving
+ (void)save:(NSURL *)url title:(NSString *)title completion:(JLPocketCompletionBlock)completion
{	
    if ([self isAuthenticated]) {
        NSArray *accounts = [SSKeychain accountsForService:serviceName];
        assert(accounts.count > 0);
        NSString *username = [[accounts objectAtIndex:0] objectForKey:kSSKeychainAccountKey];
        NSString *password = [SSKeychain passwordForService:serviceName account:username];
        
        
        JLPocket *pocket = [[JLPocket alloc] init];
        NSString *params = [NSString stringWithFormat:@"url=%@&title=%@",
                            [url.absoluteString stringByEncodingURLFormat],
                            [title stringByEncodingURLFormat]];
        [pocket sendRequest:@"add"
                   username:username
                   password:password
                     params:params
                 completion:completion];
    } else {
        NSLog(@"Whoops... you're not authenticated yet.");
    }	
}

# pragma mark - Request Handling

-(void)sendRequest:(NSString *)method username:(NSString *)username password:(NSString *)password params:(NSString *)additionalParams completion:(JLPocketCompletionBlock)completion
{
		
	// Create Request
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://readitlaterlist.com/v2/%@", method]];
	NSMutableURLRequest *request =  [ [NSMutableURLRequest alloc] initWithURL:url
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:90];
	
    
	// Setup Request Data/Params
	NSMutableString *params = [NSMutableString stringWithFormat:@"apikey=%@&username=%@&password=%@", apikey, username, [password stringByEncodingURLFormat]];
	if (additionalParams != nil) {
		[params appendFormat:@"&%@", additionalParams];
	}
	NSData *paramsData = [ NSData dataWithBytes:[params UTF8String] length:[params length] ];
	
	// Fill Request
	[request setHTTPMethod:@"POST"];
    NSString *userAgent = [nameOfYourApp isEqualToString:@""] ? @"JLPocket" : nameOfYourApp;
	[request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:paramsData];
	
    
	// Send request asynchronously
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        if (completion) {
            NSString *responseString = nil;
            if (!error) {
                responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            }
            completion(responseString, [error localizedDescription]);
        }
    }];
	
}

@end
