//
//  DOSubviewManager.m
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOSubviewManager.h"

@implementation DOSubviewManager

@synthesize subviewList = _subviewList;
@synthesize activeSubview = _activeSubview;


/* GETTER / SETTER */

-(NSMutableArray *) subviewList
{
    if(!_subviewList) _subviewList = [[NSMutableArray alloc] initWithCapacity:2];
    return _subviewList;
}

-(void) addSubview:(UIView *) subview
{
    [self.subviewList addObject:subview];
}

- (void)hideAlleSubviews
{
    UIView *subview = nil;
    
    for(int i = 0; i < self.subviewList.count; ++i)
    {
        subview = [self.subviewList objectAtIndex:i];
        subview.hidden = YES;
    }
}

-(void) displaySubview:(UIView *)subview
{
    if(self.activeSubview) self.activeSubview.hidden = YES;
    
    self.activeSubview = subview;
    subview.hidden = NO;
}

@end
