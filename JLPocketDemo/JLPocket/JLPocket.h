//
//  JLPocket.h
//
//  A wrapper around the Pocket API
//
//  Why it's better than the ReadItLaterFull/Lite they give you:
//      *USES SSKeychain to store account information, __NOT__ NSUserDefaults
//      * Uses blocks. No more gross delegates.
//  Why it may not be better:
//      * I really haven't tested it much. It authenticates and saves links at least. I haven't tested
//        registering.
//
//  DON'T FORGET to add SSKeychain.m, NSString+URLEncode.m, and Security.framework to your build or you will be sad. :(
//
//  Created by Jason Larsen on 5/25/12.
//  Copyright (c) 2012 Jason Larsen. All rights reserved.
//  http://jasonlarsen.me

typedef void(^JLPocketCompletionBlock)(NSString *response, NSString *error);

@interface JLPocket : NSObject

#pragma mark - Authentication
+ (BOOL)isAuthenticated;
+ (void)authUsername:(NSString*)username password:(NSString *)password completion:(JLPocketCompletionBlock)completion;
+ (void)signupWithUsername:(NSString *)username password:(NSString *)password completion:(JLPocketCompletionBlock)completion;
+ (void)clearFromKeychain;

#pragma mark - Saving
+ (void)save:(NSURL *)url title:(NSString *)title completion:(JLPocketCompletionBlock)completion;

@end
