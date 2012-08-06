//
//  DOColorPickerViewController.m
//  pixel painter
//
//  Created by David Ochmann on 05.08.12.
//
//

#import "DOColorPickerViewController.h"

@interface DOColorPickerViewController ()

@end

@implementation DOColorPickerViewController

@synthesize model = _model;
@synthesize textSaturation = _textSaturation;
@synthesize textBrightness = _textBrightness;
@synthesize sliderSaturation = _sliderSaturation;
@synthesize colorMapView = _colorMapView;
@synthesize colorMapViewImage = _colorMapViewImage;
@synthesize colorPicker = _colorPicker;
@synthesize sliderHue = _sliderHue;
@synthesize sliderBrightness = _sliderBrightness;
@synthesize textHue = _textHue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.colorPicker.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setColorMapView:nil];
    [self setColorMapViewImage:nil];
    [self setColorPicker:nil];
    [self setSliderHue:nil];
    [self setSliderSaturation:nil];
    [self setSliderBrightness:nil];
    [self setTextHue:nil];
    [self setTextSaturation:nil];
    [self setTextBrightness:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/* IACTIONS SLIDER */

- (IBAction)sliderHueTouchDragInsideHandler:(UISlider *)sender
{
    [self hideColorPicker];
    
    self.model.hue = sender.value;
    self.model.color = [[UIColor alloc] initWithHue:sender.value
                                         saturation:self.model.saturation
                                         brightness:self.model.brightness
                                              alpha:1];
}

- (IBAction)sliderSaturationTouchDragInsideHandler:(UISlider *)sender
{
    [self hideColorPicker];
    
    self.model.saturation = sender.value;
    self.model.color = [[UIColor alloc] initWithHue:self.model.hue
                                         saturation:sender.value
                                         brightness:self.model.brightness
                                              alpha:1];
}

- (IBAction)sliderBrightnessDragInsideHandler:(UISlider *)sender
{
    [self hideColorPicker];
    
    self.model.brightness = sender.value;
    self.model.color = [[UIColor alloc] initWithHue:self.model.hue
                                         saturation:self.model.saturation
                                         brightness:sender.value
                                              alpha:1];    
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
    self.touchPosition = [[touches anyObject] locationInView:self.view];
    
    UIView *subview = [self.view hitTest:[[touches anyObject] locationInView:self.view] withEvent:nil];
    
    if(subview == self.colorMapView)
    {
        self.colorPicker.hidden = YES;
        
        self.colorPicker.center = self.touchPosition;
        
        self.color = [self.view getPixelColorAtLocation: self.touchPosition];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COLOR_PICKED object:self.color];
        
        self.colorPicker.hidden = NO;
    }
}

- (void)hideColorPicker
{
    self.colorPicker.hidden = YES;
}

@end
