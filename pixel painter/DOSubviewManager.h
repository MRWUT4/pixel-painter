//
//  DOSubviewManager.h
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOSubviewManager : NSObject

@property (strong, nonatomic) NSMutableArray *subviewList;

@property (strong, nonatomic) UIView *activeSubview;

- (void)addSubview:(UIView *) subview;

- (void)displaySubview:(UIView *) subview;

- (void)hideAlleSubviews;

@end
