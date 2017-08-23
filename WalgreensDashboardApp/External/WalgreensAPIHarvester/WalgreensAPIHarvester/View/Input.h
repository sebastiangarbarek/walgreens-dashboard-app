//
//  Input.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Input : NSObject

- (void)flush;
- (BOOL)confirmWithQuestion:(char *)question;

@end
