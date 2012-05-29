//
//  NSString+URLEncode.h
//  iNet
//
//  Created by Jason Larsen on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)
- (NSString *)stringByEncodingURLFormat;
- (NSString *)stringByDecodingURLFormat;
@end
