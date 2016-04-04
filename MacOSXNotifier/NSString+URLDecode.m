//
//  NSString+URLDecode.m
//  MacOSXNotifier
//
//  Created by Isaac H. on 4/04/2016.
//  Copyright © 2016 Isaac H. All rights reserved.
//

#import "NSString+URLDecode.h"

@implementation NSString (URLDecode)
- (NSString *)URLDecode
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByRemovingPercentEncoding];
    return result;
}
@end
