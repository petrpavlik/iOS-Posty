//
//  DateFormatter.m
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

+ (NSString*) stringFromDate : (NSDate*) date
{
    NSParameterAssert(date);
    
    NSDate *current = [NSDate date];
    
    static NSDateFormatter* todayFormatter = nil;
    static NSDateFormatter* olderFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        todayFormatter = [[NSDateFormatter alloc] init];
        olderFormatter = [[NSDateFormatter alloc] init];
        
        [todayFormatter setDoesRelativeDateFormatting: YES];
        [olderFormatter setDoesRelativeDateFormatting: YES];
        
        todayFormatter.dateStyle = NSDateFormatterNoStyle;
        todayFormatter.timeStyle = NSDateFormatterShortStyle;
        
        olderFormatter.dateStyle = NSDateFormatterShortStyle;
        olderFormatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:current];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    
    if ([comp1 day]   == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year]) {
        return [todayFormatter stringFromDate: date];
    }
    else {
        return [olderFormatter stringFromDate: date];
    }
}


@end
