//
//  DOConstants.h
//  pixel painter
//
//  Created by David Ochmann on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static float const NAVIGATION_ANIMATION_TIME = .4;
static NSString * const NOTIFICATION_COLOR_PICKED = @"NOTIFICATION_COLOR_PICKED";
static NSString * const NOTIFICATION_COLOR_GRADIENT_PICKED = @"NOTIFICATION_COLOR_GRADIENT_PICKED";
static NSString * const NOTIFICATION_COLOR_DRAWINGVIEW_PICKED = @"NOTIFICATION_COLOR_DRAWINGVIEW_PICKED";
static NSString * const NOTIFICATION_COLOR_ERASE_PICKED = @"NOTIFICATION_COLOR_ERASE_PICKED";

typedef enum navigation 
{
    NAVIGATION_STATUS_CLOSED = 0,
    NAVIGATION_POSITION_CLOSED = -352,
    
    NAVIGATION_STATUS_NAVIGATION = 1,
    NAVIGATION_POSITION_NAVIGATION = -288,
    
    NAVIGATION_STATUS_SUBVIEW = 2,
    NAVIGATION_POSITION_SUBVIEW = 0,
} Navigation;

typedef enum subsite
{
    SUBSITE_FILE = 0,
    SUBSITE_COLORPICKER = 1,
} Subsite;

typedef enum drawingState
{
    STATE_DRAWING = 0,
    STATE_PICKING = 1,
    STATE_MOVING = 2,
} DrawingState;


@interface DOConstants : NSObject
@end
