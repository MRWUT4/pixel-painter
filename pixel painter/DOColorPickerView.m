//
//  DOColorPickerView.m
//  pixel painter
//
//  Created by David Ochmann on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOColorPickerView.h"


@implementation DOColorPickerView


@synthesize colorMapView = _colorMapView;
@synthesize colorMapViewImage = _colorMapViewImage;
@synthesize touchPosition = _touchPosition;
@synthesize color = _color;
@synthesize colorPicker = _colorPicker;
@synthesize sliderHue = _sliderHue;
@synthesize sliderBrightness = _sliderBrightness;
@synthesize sliderSaturation = _sliderSaturation;
@synthesize textHue = _textHue;
@synthesize textBrightness = _textBrightness;
@synthesize textSaturation = _textSaturation;


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



/*
 * GETTER / SETTER
 */

- (void)setColor:(UIColor *)color
{
    _color = color;
}

- (UISlider *)sliderHue
{
    return (UISlider *)[self viewWithTag:4];
}

- (UISlider *)sliderBrightness
{
    return (UISlider *)[self viewWithTag:5];
}

- (UISlider *)sliderSaturation
{
    return (UISlider *)[self viewWithTag:6];
}

-(UITextView *)textHue
{
    return (UITextView *)[self viewWithTag:7];
}

-(UITextView *)textBrightness
{
    return (UITextView *)[self viewWithTag:8];
}

-(UITextView *)textSaturation
{
    return (UITextView *)[self viewWithTag:9];
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
}

- (void)hideColorPicker
{
    self.colorPicker.hidden = YES;
}

@end