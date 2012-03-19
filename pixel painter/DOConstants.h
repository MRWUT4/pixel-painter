//
//  DOConstants.h
//  pixel painter
//
//  Created by David Ochmann on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static float const ANIMATION_KEYBOARD = .25;
static float const ANIMATION_NAVIGATION = .4;
static float const ANIMATION_REPOSITION = .3;
static float const ZOOM_STEP = 2;
static float const ZOOM_SCALE_MINIMUM = 1;
static float const ZOOM_SCALE_MAXIMUM = 50;
static int const MAX_DRAWING_SIZE = 10000;

static NSString * const NOTIFICATION_COLOR_PICKED = @"NOTIFICATION_COLOR_PICKED";
static NSString * const NOTIFICATION_COLOR_GRADIENT_PICKED = @"NOTIFICATION_COLOR_GRADIENT_PICKED";
static NSString * const NOTIFICATION_COLOR_DRAWINGVIEW_PICKED = @"NOTIFICATION_COLOR_DRAWINGVIEW_PICKED";
static NSString * const NOTIFICATION_COLOR_ERASE_PICKED = @"NOTIFICATION_COLOR_ERASE_PICKED";

typedef enum navigation 
{
    NAVIGATION_STATUS_CLOSED = 0,
    NAVIGATION_POSITION_CLOSED = -272,
    
    NAVIGATION_STATUS_NAVIGATION = 1,
    NAVIGATION_POSITION_NAVIGATION = -208,
    
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
    STATE_ERASING = 3,
} DrawingState;

typedef enum color
{
    INIT_HUE = 0,
    INIT_BRIGHTNESS = 0,
    INIT_SATURATION = 1,
    INIT_ALPHA = 1,
} Color;

typedef enum alerts
{
    ALERTVIEW_CLEARDRAWINGVIEW = 0,
} Alerts;

@interface DOConstants : NSObject
@end
