//
//  DOTabBarViewContoller.m
//  pixel painter
//
//  Created by David Ochmann on 02.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOTabBarViewContoller.h"

@implementation DOTabBarViewContoller

- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items
{
    NSLog(@"%@", items);
}

@end
