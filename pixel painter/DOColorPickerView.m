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
        self.colorPicker.userInteractionEnabled = NO;
        self.colorPickerHorizontal.userInteractionEnabled = NO;
    }
    
    return self;
}


/* GETTER / SETTER */

- (UIView *)gradientView
{
    return [self viewWithTag:10];
}

- (UIView *)colorMapView
{   
    return [self viewWithTag:1];
}

- (UIImageView *)colorMapViewImage
{    
    return (UIImageView *)[self.colorMapView viewWithTag:0];    
}

- (UIImageView *)colorPicker
{
    return (UIImageView *)[self viewWithTag:2];  
}

- (UIImageView *)colorPickerHorizontal
{
    return (UIImageView *)[self viewWithTag:3];
}

/* TOUCHES HANDLER */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [self pickColorAtTouches:touches];    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self pickColorAtTouches:touches];
}

- (void)pickColorAtTouches:(NSSet *)touches
{
    self.touchPosition = [[touches anyObject] locationInView:self];    
    
    UIView *subview = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if(subview == self.colorMapView)
    {   
        self.colorPicker.hidden = YES;
        
        self.colorPicker.center = self.touchPosition; 
        
        self.color = [self getPixelColorAtLocation: self.touchPosition];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_PICKED object:self];
        
        self.colorPicker.hidden = NO;
        self.colorPickerHorizontal.hidden = YES;
    }
    if(subview == self.gradientView)
    {                   
        self.colorPickerHorizontal.hidden = YES;
        
        CGRect colorPickerHorizontalFrame = self.colorPickerHorizontal.frame;
        colorPickerHorizontalFrame.origin.x = self.touchPosition.x - colorPickerHorizontalFrame.size.width * .5;
        self.colorPickerHorizontal.frame = colorPickerHorizontalFrame; 
        
        self.color = [self getPixelColorAtLocation: self.touchPosition];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_GRADIENT_PICKED object:self];
        
        self.colorPicker.hidden = YES;
        self.colorPickerHorizontal.hidden = NO;
    }
}

- (void)hideBothColorPickers
{
    self.colorPickerHorizontal.hidden = YES;
    self.colorPicker.hidden = YES;
}

- (void)hideColorPickerAndResetColorPickerHorizontal
{
    CGRect colorPickerHorizontalFrame = self.colorPickerHorizontal.frame;
    colorPickerHorizontalFrame.origin.x = self.gradientView.frame.origin.x - colorPickerHorizontalFrame.size.width * .5;
    self.colorPickerHorizontal.frame = colorPickerHorizontalFrame;
    
    self.colorPicker.hidden = YES;
    self.colorPickerHorizontal.hidden = NO;
}

@end