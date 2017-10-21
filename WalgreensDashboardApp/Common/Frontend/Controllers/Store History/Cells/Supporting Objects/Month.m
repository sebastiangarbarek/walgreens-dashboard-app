//
//  Month.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "Month.h"

@implementation Month

- (instancetype)initWithMonthNumber:(NSNumber *)monthNumber {
    self = [super init];
    
    if (self) {
        switch ([monthNumber integerValue]) {
            case 1:
                self.monthName = @"Jan";
                break;
            case 2:
                self.monthName = @"Feb";
                break;
            case 3:
                self.monthName = @"Mar";
                break;
            case 4:
                self.monthName = @"Apr";
                break;
            case 5:
                self.monthName = @"May";
                break;
            case 6:
                self.monthName = @"Jun";
                break;
            case 7:
                self.monthName = @"Jul";
                break;
            case 8:
                self.monthName = @"Aug";
                break;
            case 9:
                self.monthName = @"Sep";
                break;
            case 10:
                self.monthName = @"Oct";
                break;
            case 11:
                self.monthName = @"Nov";
                break;
            case 12:
                self.monthName = @"Dec";
                break;
            default:
                break;
        }
        
        self.monthNumber = monthNumber;
    }
    
    return self;
}

@end
