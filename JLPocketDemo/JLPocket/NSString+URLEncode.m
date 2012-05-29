//
//  NSString+URLEncode.m
//  iNet
//
//  Created by Jason Larsen on 3/17/12.
//  Copyright (c) 2012 http://jasonlarsen.me. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)
- (NSString *)stringByEncodingURLFormat
{
    NSString *escaped = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return escaped;
}

- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}
@end
