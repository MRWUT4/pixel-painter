//
//  DOPixelPainterModel.h
//  pixel painter
//
//  Created by David Ochmann on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static float const NAVIGATION_ANIMATION_TIME = .4;

enum 
{
    NAVIGATION_STATUS_CLOSED = 0,
    NAVIGATION_POSITION_CLOSED = -352,

    NAVIGATION_STATUS_NAVIGATION = 1,
    NAVIGATION_POSITION_NAVIGATION = -288,

    NAVIGATION_STATUS_SUBVIEW = 2,
    NAVIGATION_POSITION_SUBVIEW = 0,
};


@interface DOPixelPainterModel : NSObject


@property(nonatomic, assign) unsigned int navigationStatus;

@end
