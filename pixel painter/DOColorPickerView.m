//
//  DOColorPickerView.m
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOColorPickerView.h"


@implementation DOColorPickerView


@synthesize gradientView = _gradientView;
@synthesize colorMapView = _colorMapView;
@synthesize colorMapViewImage = _colorMapViewImage;
@synthesize touchPosition = _touchPosition;
@synthesize color = _color;
@synthesize colorPicker = _colorPicker;
@synthesize colorPickerHorizontal = _colorPickerHorizontal;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self.colorPicker setUserInteractionEnabled:NO];
        [self.colorPickerHorizontal setUserInteractionEnabled:NO];   
    }
    
    return self;
}


/* GETTER / SETTER */

- (UIView *)gradientView
{
    id subview = [[self subviews] objectAtIndex:0];
    UIView *gradientView = [subview isKindOfClass:[GradientView class]] ? subview : nil;
                            
    return gradientView;
}

- (UIImageView *)colorMapView
{
    id subview = [[self subviews] objectAtIndex:1];
    UIImageView *colorMapView = [subview isKindOfClass:[DOColorMapView class]] ? subview : nil;
    
    return colorMapView;    
}

- (UIImageView *)colorMapViewImage
{
    id subview = [[self.colorMapView subviews] objectAtIndex:0];
    UIImageView *colorMapSubview = [subview isKindOfClass:[UIImageView class]] ? subview : nil;
    
    return colorMapSubview;    
}

- (UIImageView *)colorPicker
{
    id subview = [[self subviews] objectAtIndex:2];
    UIImageView *colorPicker = [subview isKindOfClass:[UIImageView class]] ? subview : nil;
    
    return colorPicker;    
}

- (UIImageView *)colorPickerHorizontal
{
    id subview = [[self subviews] objectAtIndex:3];
    UIImageView *colorPickerHorizontal = [subview isKindOfClass:[UIImageView class]] ? subview : nil;
    
    return colorPickerHorizontal;    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchPosition = [[touches anyObject] locationInView:self];    
 
    UIView *subview = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
        
    if(subview == self.colorMapView)
    {   
        self.colorPicker.hidden = NO;
        self.colorPickerHorizontal.hidden = YES;
        
        self.colorPicker.center = self.touchPosition; 
        
        self.color = [self getPixelColorAtLocation: self.touchPosition];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_PICKED object:self];
    }
    if(subview == self.gradientView)
    {    
        self.colorPicker.hidden = YES;
        self.colorPickerHorizontal.hidden = NO;
        
        CGRect colorPickerHorizontalFrame = self.colorPickerHorizontal.frame;
        colorPickerHorizontalFrame.origin.x = self.touchPosition.x - colorPickerHorizontalFrame.size.width * .5;
        
        self.colorPickerHorizontal.frame = colorPickerHorizontalFrame; 
        
        self.color = [self getPixelColorAtLocation: self.touchPosition];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_GRADIENT_PICKED object:self];
    }
    
}


@end