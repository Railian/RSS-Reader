//
//  DateUtils.h
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/20/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSDate *)seasonFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
