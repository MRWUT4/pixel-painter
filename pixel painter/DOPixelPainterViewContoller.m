//
//  DOPixelPainterViewContoller.m
//  pixel painter
//
//  Created by David Ochmann on 07.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOPixelPainterViewContoller.h"
#import "DOConstants.h"
#import "UIColor-HSVAdditions.h"

@implementation DOPixelPainterViewContoller


@synthesize colorPickerView = _colorPickerView;
@synthesize fileSettingsView = _fileSettingsView;
@synthesize colorPreviewView = _colorPreviewView;
@synthesize drawingView = _drawingView;
@synthesize scrollView = _scrollView;
@synthesize navigationView = _navigationView;
@synthesize folderView = _folderView;
@synthesize model = _model;
@synthesize subviewManager = _subviewManager;
@synthesize buttonMove = _buttonMove;
@synthesize buttonFile = _buttonFile;
@synthesize buttonColor = _buttonColor;
@synthesize buttonPicker = _buttonPicker;
@synthesize subsiteButtonList = _subsiteButtonList;
@synthesize applicationButtonList = _applicationButtonList;
@synthesize buttonPen = _buttonPen;
@synthesize buttonErase = _buttonErase;



- (void)viewDidAppear:(BOOL)animated
{   
    if(!self.model.initialized)
    {
        [self.navigationView setFrame:CGRectMake(NAVIGATION_POSITION_NAVIGATION, 0, self.navigationView.frame.size.width, self.navigationView.frame.size.height)];
        [self.navigationView setNeedsDisplay];
        
        self.model.color = [[UIColor alloc] initWithHue:INIT_HUE saturation:INIT_SATURATION brightness:INIT_BRIGHTNESS alpha:INIT_ALPHA];
        self.model.hue = INIT_HUE;
        self.model.saturation = INIT_SATURATION;
        self.model.brightness = INIT_BRIGHTNESS;
        self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
        self.model.applicationState = STATE_DRAWING;
        self.model.initialized = YES;
        
        
        self.subsiteButtonList = [[NSArray alloc] initWithObjects:self.buttonFile, self.buttonColor, nil];    
        self.applicationButtonList = [[NSArray alloc] initWithObjects:self.buttonPen, self.buttonPicker, self.buttonMove, self.buttonErase, nil];
        
        [self.subviewManager addSubview:self.colorPickerView];
        [self.subviewManager addSubview:self.fileSettingsView];
        [self.subviewManager hideAlleSubviews];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorPickedNotificationHandler:) name:NOTIFICATION_COLOR_PICKED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorDrawingViewPickedNotificationHandler:) name:NOTIFICATION_COLOR_DRAWINGVIEW_PICKED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorDrawingViewEraseNotificationHandler:) name:NOTIFICATION_COLOR_ERASE_PICKED object:nil];
                
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 50;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.delegate = self;    
        
        [self changeDrawingFrame:[NSValue valueWithCGRect:CGRectMake(0, 0, 160, 240)] withAnimation:NO];
        [self.scrollView setZoomScale:10 animated:NO];
    }
}

/* 
 * GETTER / SETTER
 */

- (DOSubviewManager *) subviewManager
{
    if(!_subviewManager) _subviewManager = [[DOSubviewManager alloc] init];    
    return _subviewManager;
}

- (DOPixelPainterModel *)model
{    
    if(!_model) 
    {
        _model = [[DOPixelPainterModel alloc] init];
        [_model addObserver:self forKeyPath:@"navigationStatus" options:NSKeyValueObservingOptionNew context:@selector(navigationStatus)];
        [_model addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:@selector(color)];
        [_model addObserver:self forKeyPath:@"hue" options:NSKeyValueObservingOptionNew context:@selector(hue)];
        [_model addObserver:self forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:@selector(brightness)];
        [_model addObserver:self forKeyPath:@"saturation" options:NSKeyValueObservingOptionNew context:@selector(saturation)];
        [_model addObserver:self forKeyPath:@"subsite" options:NSKeyValueObservingOptionNew context:@selector(subsite)];
        [_model addObserver:self forKeyPath:@"applicationState" options:NSKeyValueObservingOptionNew context:@selector(applicationState)];        
    }
    
    return _model;
}



/* 
 * OBSERVER IMPLEMENTATION
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(keyPath == @"navigationStatus") 
    {
        [self changeNavigationStatus: (NSNumber *)[change valueForKey:@"new"]];
    }
    else if(keyPath == @"color")
    {
        UIColor *color = (UIColor *)[change valueForKey:@"new"];
        
        self.colorPreviewView.color = color;
        
        self.drawingView.color = color;
        self.colorPickerView.color = color;
    }
    else if(keyPath == @"hue")
    {
        self.colorPickerView.sliderHue.value = self.model.hue;
        self.colorPickerView.textHue.text = [NSString stringWithFormat:@"HUE %i°", (unsigned int)floor(self.model.hue * 360)];
    }
    else if(keyPath == @"saturation")
    {
        self.colorPickerView.sliderSaturation.value = self.model.saturation;
        self.colorPickerView.textSaturation.text = [NSString stringWithFormat:@"SATURATION %i%%", (unsigned int)floor(self.model.saturation * 100)];
    }
    else if(keyPath == @"brightness")
    {
        self.colorPickerView.sliderBrightness.value = self.model.brightness;
        self.colorPickerView.textBrightness.text = [NSString stringWithFormat:@"BRIGHTNESS %i%%", (unsigned int)floor(self.model.brightness * 100)];
    }
    else if(keyPath == @"subsite")
    {
        self.model.applicationState = STATE_DRAWING;
        [self openSubsite:self.model.subsite];
    }
    else if(keyPath == @"applicationState")
    {
        [self switchDrawingState:self.model.applicationState];
    }
}

/* NOTIFICATIONS */

- (void)colorPickedNotificationHandler:(NSNotification*)notification
{
    self.model.color = self.colorPickerView.color;
    self.model.hue = self.colorPickerView.color.hue;
    self.model.brightness = self.colorPickerView.color.brightness;
    self.model.saturation = self.colorPickerView.color.saturation;
    self.model.applicationState = STATE_DRAWING;
}

- (void)colorDrawingViewPickedNotificationHandler:(NSNotification*)notification
{
    self.model.color = self.drawingView.color;
    self.model.hue = self.colorPickerView.color.hue;
    self.model.brightness = self.colorPickerView.color.brightness;
    self.model.saturation = self.colorPickerView.color.saturation;
    self.model.applicationState = STATE_DRAWING;
}

- (void)colorDrawingViewEraseNotificationHandler:(NSNotification*)notification
{
    self.model.applicationState = STATE_ERASING;
}



/* 
 * IBACTION IMPLEMENTATIONS 
 */

- (IBAction)buttonMoveTouchUpInsideHandler:(id)sender 
{
    self.model.applicationState = STATE_MOVING;
}

- (IBAction)buttonPickerTouchUpInsideHandler:(id)sender 
{
    self.model.applicationState = STATE_PICKING;
}

- (IBAction)buttonPenTouchUpInsideHandler:(id)sender 
{
    self.model.applicationState = STATE_DRAWING;
}

- (IBAction)buttonFolderTouchUpInsideHandler:(id)sender 
{
    switch (self.model.navigationStatus) 
    {            
        case NAVIGATION_STATUS_CLOSED:
            self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
            break;
        
        case NAVIGATION_STATUS_NAVIGATION:
            self.model.navigationStatus = NAVIGATION_STATUS_CLOSED;
            break;
            
        default:
            self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
            break;
    }
}

/* IBACTIONS COLORPICKER SUBVIEW */

- (IBAction)buttonColorTouchUpInsideHandler:(id)sender 
{
    self.model.navigationStatus = NAVIGATION_STATUS_SUBVIEW;
    self.model.subsite = SUBSITE_COLORPICKER;
}

- (IBAction)buttonEraseTouchUpInsideHandler:(id)sender 
{    
    self.model.applicationState = STATE_ERASING;
}

/* IBACTIONS FILE SUBVIEW */

- (IBAction)buttonFileTouchUpInsideHandler:(id)sender 
{
    self.model.navigationStatus = NAVIGATION_STATUS_SUBVIEW;
    self.model.subsite = SUBSITE_FILE;
}

- (IBAction)buttonSaveTouchUpInsideHandler:(id)sender 
{
    UIImageView *drawingViewImage = self.drawingView.imageView;
    
    UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(drawingViewImage.image.CGImage, drawingViewImage.bounds)];
    
    NSData *imageData = UIImagePNGRepresentation(image); 
    UIImage *imagePNG = [UIImage imageWithData:imageData];
        
    CGImageRef croppedImage = CGImageCreateWithImageInRect([imagePNG CGImage], drawingViewImage.bounds);    
    UIImage *finalImage = [UIImage imageWithCGImage:croppedImage];
    
    UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);
}

- (IBAction)buttonOpenTouchUpInsideHandler:(id)sender 
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.allowsEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self changeDrawingFrame:[NSValue valueWithCGRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)] withAnimation:NO];
    
    [self.drawingView.imageView setImage: originalImage];
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)buttonNewTouchUpInsideHandler:(id)sender 
{   
//    [self changeDrawingFrame:[NSValue valueWithCGRect:CGRectMake(0, 0, 400, 200)]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Clear image" 
                                                  message:@"Are you sure you want to clear your image?" 
                                                  delegate:self 
                                                  cancelButtonTitle:@"YES"
                                                  otherButtonTitles:@"NO",
                                                  nil];
    alertView.tag = ALERTVIEW_CLEARDRAWINGVIEW;
    [alertView show];
}

/* IACTIONS SLIDER */

- (IBAction)sliderHueTouchDragInsideHandler:(UISlider *)sender 
{   
    [self.colorPickerView hideColorPicker];
    
    self.model.hue = sender.value;
    self.model.color = [[UIColor alloc] initWithHue:sender.value 
                                        saturation:self.model.saturation 
                                        brightness:self.model.brightness 
                                        alpha:1];
}

- (IBAction)sliderSaturationTouchDragInsideHandler:(UISlider *)sender 
{    
    [self.colorPickerView hideColorPicker];
    
    self.model.saturation = sender.value;
    self.model.color = [[UIColor alloc] initWithHue:self.model.hue 
                                        saturation:sender.value
                                        brightness:self.model.brightness 
                                        alpha:1];
}

- (IBAction)sliderBrightnessDragInsideHandler:(UISlider *)sender 
{
    [self.colorPickerView hideColorPicker];
    
    self.model.brightness = sender.value;
    self.model.color = [[UIColor alloc] initWithHue:self.model.hue 
                                        saturation:self.model.saturation
                                        brightness:sender.value 
                                        alpha:1];

}



/*
 * ALERTVIEW CLICK HANDLER
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) 
    {
        case ALERTVIEW_CLEARDRAWINGVIEW:
            //if(!buttonIndex) [self.drawingView clearCompleteView];            
            break;
    }
}



/*
 * ASSIST FUNCTIONS
 */

- (void)openSubsite:(unsigned int)subsite
{   
    [self unSelectButtonList: self.subsiteButtonList];
    
    if(subsite == SUBSITE_FILE)
    {
        [self.subviewManager displaySubview:self.fileSettingsView];
        self.buttonFile.selected = YES;
    }
    else if(subsite == SUBSITE_COLORPICKER)
    {
        [self.subviewManager displaySubview:self.colorPickerView];
        self.buttonColor.selected = YES;
    }
}

- (void)changeNavigationStatus:(NSNumber *)status
{    
    CGRect navigationFrame = self.navigationView.frame;
    
    switch([status intValue]) 
    {
        case NAVIGATION_STATUS_CLOSED:
            [self unSelectButtonList: self.subsiteButtonList];
            navigationFrame.origin.x = NAVIGATION_POSITION_CLOSED;
            [self.folderView setImage: [UIImage imageNamed:@"rFolderOpen.png"]];
            break;
            
        case NAVIGATION_STATUS_NAVIGATION:
            [self unSelectButtonList: self.subsiteButtonList];
            navigationFrame.origin.x = NAVIGATION_POSITION_NAVIGATION;
            [self.folderView setImage: [UIImage imageNamed:@"rFolderClose.png"]];
            break;
            
        case NAVIGATION_STATUS_SUBVIEW:
            navigationFrame.origin.x = NAVIGATION_POSITION_SUBVIEW;
            [self.folderView setImage: [UIImage imageNamed:@"rFolderClose.png"]];
            break;
    }
    
    [UIView beginAnimations:@"animation0" context:NULL];
    [UIView setAnimationDuration:ANIMATION_NAVIGATION];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    [self.navigationView setFrame:navigationFrame];
    
    [UIView commitAnimations];
}

- (void)unSelectButtonList:(NSArray *)list;
{
    for(uint i = 0; i < list.count; ++i)
    {
        UIButton *button = [list objectAtIndex:i];
        button.selected = NO;
    }
}

- (void)switchDrawingState:(unsigned int)state
{
    [self unSelectButtonList: self.applicationButtonList];

    self.scrollView.scrollEnabled = NO;
    self.drawingView.scrollEnabled = NO;
    
    switch (self.model.applicationState) 
    {
        case STATE_DRAWING:
            self.buttonPen.selected = YES;
            self.drawingView.mode = STATE_DRAWING;
            break;
            
        case STATE_PICKING:
            self.buttonPicker.selected = YES;
            self.drawingView.mode = STATE_PICKING;
            break;
      
        case STATE_MOVING:
            self.buttonMove.selected = YES;
            self.scrollView.scrollEnabled = YES;
            self.drawingView.scrollEnabled = YES;
            break;
            
        case STATE_ERASING:
            self.buttonErase.selected = YES;
            self.drawingView.mode = STATE_ERASING;
            break;
    }
}



/* 
 * SCROLL VIEW PROTOCOL IMPLEMENTATION
 */

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.drawingView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self centerImageWithAnimation:YES];
}

- (void)changeDrawingFrame:(NSValue *)rectangle withAnimation:(BOOL)animation
{   
    [self.scrollView setZoomScale:1 animated:NO];
    
    CGRect drawingViewFrame = rectangle.CGRectValue;
 
    self.drawingView.imageView.center = CGPointMake(drawingViewFrame.size.width * .5, drawingViewFrame.size.height * .5);
    self.drawingView.imageView.bounds = drawingViewFrame;
    
//    self.drawingView.bounds = drawingViewFrame;
    
    self.drawingView.frame = drawingViewFrame;
    
//    self.scrollView.contentSize = drawingViewFrame.size;
    
    [self centerImageWithAnimation:NO];
}

- (void)centerImageWithAnimation:(BOOL)animation
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect frameToCenter = self.drawingView.frame;
 
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;

    if(animation)
    {
        [UIView beginAnimations:@"animation0" context:NULL];
        [UIView setAnimationDuration:ANIMATION_REPOSITION];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    }
        
    self.drawingView.frame = frameToCenter;
    
    if(animation) 
        [UIView commitAnimations];
}

/* REVIEW
 
- (void)positionTransform
{
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(1, 1);
    self.frame = oldFrame;

    oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(0.5,0.5);
    self.frame = oldFrame;
}

 */

/* 
 * UIVIEW IMPLEMENTATION
 */

- (void)viewDidUnload 
{
    [self setFolderView:nil];
    [self setNavigationView:nil];
    [self setFolderView:nil];
    [self setColorPickerView:nil];
    [self setFileSettingsView:nil];
    [self setColorPreviewView:nil];
    [self setDrawingView:nil];
    [self setScrollView:nil];
    [self setButtonMove:nil];
    [self setButtonFile:nil];
    [self setButtonColor:nil];
    [self setButtonPicker:nil];
    [self setButtonErase:nil];
    [super viewDidUnload];
}

@end
