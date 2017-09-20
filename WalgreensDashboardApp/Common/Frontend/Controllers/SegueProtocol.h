//
//  SegueProtocol.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 20/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SegueProtocol <NSObject>

@required
- (void)child:(id)child willPerformSegueWithIdentifier:(NSString *)segueIdentifier;

@end
