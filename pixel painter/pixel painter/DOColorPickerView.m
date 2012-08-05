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
@synthesize colorPicker = _colorPicker;
@synthesize sliderHue = _sliderHue;
@synthesize sliderSaturation = _sliderSaturation;
@synthesize sliderBrightness = _sliderBrightness;
@synthesize textHue = _textHue;
@synthesize textSaturation = _textSaturation;
@synthesize textBrightness = _textBrightness;
@synthesize colorMapViewImage = _colorMapViewImage;
@synthesize touchPosition = _touchPosition;
@synthesize color = _color;


/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.colorPicker.userInteractionEnabled = NO;
    }
    
    return self;
}
*/


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
    self.touchPosition = [[touches anyObject] locationInView:self.view];
    
    UIView *subview = [self.view hitTest:[[touches anyObject] locationInView:self.view] withEvent:nil];
    
    if(subview == self.colorMapView)
    {   
        self.colorPicker.hidden = YES;
        
        self.colorPicker.center = self.touchPosition; 
        
        self.color = [self.view getPixelColorAtLocation: self.touchPosition];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_PICKED object:self];
        
        self.colorPicker.hidden = NO;
    }
}

- (void)hideColorPicker
{
    self.colorPicker.hidden = YES;
}

- (void)viewDidUnload {
    [self setColorMapView:nil];
    [self setColorPicker:nil];
    [self setSliderHue:nil];
    [self setSliderSaturation:nil];
    [self setSliderBrightness:nil];
    [self setColorMapViewImage:nil];
    [self setTextHue:nil];
    [self setTextSaturation:nil];
    [self setTextBrightness:nil];
    [super viewDidUnload];
}
@end