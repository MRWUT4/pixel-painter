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
@synthesize containerView = _containerView;
@synthesize buttonPen = _buttonPen;
@synthesize buttonErase = _buttonErase;
@synthesize buttonPosition = _buttonPosition;
@synthesize textFieldWidth = _textFieldWidth;
@synthesize textFieldHeight = _textFieldHeight;



- (void)viewDidLoad
{
    [self changeNavigationStatus:[NSNumber numberWithInt:NAVIGATION_STATUS_INITIAL] withAnimation:NO];
    
    self.model.color = [[UIColor alloc] initWithHue:INIT_HUE saturation:INIT_SATURATION brightness:INIT_BRIGHTNESS alpha:INIT_ALPHA];
    self.model.hue = INIT_HUE;
    self.model.saturation = INIT_SATURATION;
    self.model.brightness = INIT_BRIGHTNESS;
    self.model.navigationStatus = NAVIGATION_STATUS_INITIAL;
    self.model.applicationState = STATE_DRAWING;
    self.model.initialized = YES;
    self.model.width = BEGIN_WIDTH;
    self.model.height = BEGIN_HEIGHT;
    
    self.subsiteButtonList = [[NSArray alloc] initWithObjects:self.buttonFile, self.buttonColor, nil];    
    self.applicationButtonList = [[NSArray alloc] initWithObjects:self.buttonPen, self.buttonPicker, self.buttonMove, self.buttonErase, self.buttonPosition, nil];
    
    [self.subviewManager addSubview:self.colorPickerView];
    [self.subviewManager addSubview:self.fileSettingsView];
    [self.subviewManager hideAlleSubviews];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorPickedNotificationHandler:) name:NOTIFICATION_COLOR_PICKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorDrawingViewPickedNotificationHandler:) name:NOTIFICATION_COLOR_DRAWINGVIEW_PICKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorDrawingViewEraseNotificationHandler:) name:NOTIFICATION_COLOR_ERASE_PICKED object:nil];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [self.drawingView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *doubleTapZoomOut = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapZoomOut:)];
    
    [doubleTapZoomOut setNumberOfTapsRequired:2];
    [doubleTapZoomOut setNumberOfTouchesRequired:2];
    [self.drawingView addGestureRecognizer:doubleTapZoomOut];
    
    
    self.scrollView.minimumZoomScale = ZOOM_SCALE_MINIMUM;
    self.scrollView.maximumZoomScale = ZOOM_SCALE_MAXIMUM;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;    
    
    [self.scrollView setZoomScale:20 animated:NO];
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
        [_model addObserver:self forKeyPath:@"width" options:NSKeyValueObservingOptionNew context:@selector(width)];
        [_model addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew context:@selector(height)];
    }
    
    return _model;
}



/* 
 * MODEL OBSERVER IMPLEMENTATION
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(keyPath == @"navigationStatus") 
    {
        [self changeNavigationStatus: (NSNumber *)[change valueForKey:@"new"] withAnimation:YES];
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
    else if(keyPath == @"width" || keyPath == @"height")
    {
        if((self.model.width != 0 && self.model.height != 0) && (self.model.width != self.drawingView.imageView.bounds.size.width || self.model.height != self.drawingView.imageView.bounds.size.height))
        {   
            self.textFieldWidth.text = [NSString stringWithFormat:FIELD_RESIZE_WIDTH_TEXT, self.model.width];
            self.textFieldHeight.text = [NSString stringWithFormat:FIELD_RESIZE_HEIGHT_TEXT, self.model.height];
            
            [self.scrollView setZoomScale:1 animated:NO];
            [self.drawingView changeDrawingViewSize:[NSValue valueWithCGRect:CGRectMake(0, 0, self.model.width, self.model.height)]];       
            [self centerImageWithAnimation:NO];
        }
    }
}



/*
 * NOTIFICATION CENTER
 */

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

- (IBAction)buttonPositionTouchUpInsideHandler:(id)sender 
{
    self.model.applicationState = STATE_POSITION;
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

    self.model.width = originalImage.size.width;
    self.model.height = originalImage.size.height;
    
    [self.drawingView.imageView setImage: originalImage];
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)buttonNewTouchUpInsideHandler:(id)sender 
{   
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NEW FILE" 
                                                  message:@"Are you sure you want to clear your current image?" 
                                                  delegate:self 
                                                  cancelButtonTitle:@"NO"
                                                  otherButtonTitles:@"YES",
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

/* IBACTIONS TEXTFIELD SIZE */

- (IBAction)buttonResizeTouchUpInsideHandler:(id)sender 
{    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RESIZE" 
                                                  message:@"\n\n\n" 
                                                  delegate:self 
                                                  cancelButtonTitle:@"NO"
                                                  otherButtonTitles:@"YES",
                                                  nil];    
    
    alertView.tag = ALERTVIEW_RESIZE;
    
        
    UITextField *fieldWidth = [[UITextField alloc] initWithFrame:CGRectMake(20, 49, 245, 25)];
    UITextField *fieldHeight = [[UITextField alloc] initWithFrame:CGRectMake(20, 81, 245, 25)];
    
    NSArray *fieldList = [[NSArray alloc] initWithObjects:fieldWidth, fieldHeight, nil];
    UITextField *field;
    
    for(uint i = 0; i < fieldList.count; i++)
    {
        field = [fieldList objectAtIndex:i];
        
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.backgroundColor = [UIColor whiteColor];
        
        [field addTarget:self action:@selector(textSizeEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        
        [alertView addSubview:field];
    }

    [fieldWidth addTarget:self action:@selector(textSizeWidthEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [fieldHeight addTarget:self action:@selector(textSizeHeightEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    fieldWidth.text = [NSString stringWithFormat:FIELD_RESIZE_WIDTH_TEXT, self.model.width];
    fieldWidth.tag = ALERTVIEW_RESIZE_FIELD_WIDTH_TAG;
    
    fieldHeight.text = [NSString stringWithFormat:FIELD_RESIZE_HEIGHT_TEXT, self.model.height];
    fieldHeight.tag = ALERTVIEW_RESIZE_FIELD_HEIGHT_TAG;

    [alertView show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView 
{
    CGRect alertViewFrame = alertView.frame;
    alertViewFrame.size.height = 190;
    
    if(alertView.tag == ALERTVIEW_RESIZE)
        alertView.frame = alertViewFrame;
}

- (IBAction)textSizeEditingDidBegin:(UITextField *)sender 
{
    sender.text = @"";
}

- (IBAction)textSizeWidthEditingDidEnd:(UITextField *)sender
{
    [self fillEmptySizeTextField:sender withText:FIELD_RESIZE_WIDTH_TEXT andSize:self.model.width];
}

- (IBAction)textSizeHeightEditingDidEnd:(UITextField *)sender
{
    [self fillEmptySizeTextField:sender withText:FIELD_RESIZE_HEIGHT_TEXT andSize:self.model.height];
}

- (void)fillEmptySizeTextField:(UITextField *)sender withText:(NSString *)text andSize:(unsigned int)size
{
    if([sender.text isEqualToString:@""] || [sender.text isEqualToString:@"0"]) 
        sender.text = [NSString stringWithFormat:text, size];
}



/*
 * ALERTVIEW CLICK HANDLER
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) 
    {
        case ALERTVIEW_CLEARDRAWINGVIEW:
            if(buttonIndex == 1) [self.drawingView clearCompleteView];            
            break;
            
        case ALERTVIEW_RESIZE:
            if(buttonIndex == 1)
            {
                self.model.width = [(NSString *)[[((UITextField *)[alertView viewWithTag:ALERTVIEW_RESIZE_FIELD_WIDTH_TAG]).text componentsSeparatedByString:@" "] objectAtIndex:0] intValue];

                self.model.height = [(NSString *)[[((UITextField *)[alertView viewWithTag:ALERTVIEW_RESIZE_FIELD_HEIGHT_TAG]).text componentsSeparatedByString:@" "] objectAtIndex:0] intValue];
            }
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

- (void)changeNavigationStatus:(NSNumber *)status withAnimation:(BOOL)animation
{    
    CGRect navigationFrame = self.navigationView.frame;
    CGRect scrollViewFrame = self.scrollView.frame;

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
    
    
    if(animation)
    {
        [UIView beginAnimations:@"animation0" context:NULL];
        [UIView setAnimationDuration:ANIMATION_NAVIGATION];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    }    
    
    int flapWidth = self.containerView.frame.size.width + navigationFrame.origin.x - NVAIGATION_FLAP_WIDTH;
    
    scrollViewFrame.origin.x = flapWidth;
    scrollViewFrame.size.width = self.containerView.frame.size.width - flapWidth;
     
    self.scrollView.frame = scrollViewFrame;
    self.navigationView.frame = navigationFrame;
    
    [self centerImageWithAnimation:NO];
    
    if(animation)
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
            self.drawingView.mode = STATE_MOVING;
            break;
            
        case STATE_ERASING:
            self.buttonErase.selected = YES;
            self.drawingView.mode = STATE_ERASING;
            break;
            
        case STATE_POSITION:
            self.buttonPosition.selected = YES;
//            self.drawingView.mode = STATE_POSITION;
            self.drawingView.mode = STATE_FILLING;
            break;
    }
}



/* 
 * SCROLL VIEW IMPLEMENTATION
 */

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.drawingView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerImageWithAnimation:NO];
}

- (void)centerImageWithAnimation:(BOOL)animation
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect frameToCenter = self.drawingView.frame;
     
    // center horizontally
    if(frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if(frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    if(animation)
    {
        [UIView beginAnimations:@"animation1" context:NULL];
        [UIView setAnimationDuration:ANIMATION_REPOSITION];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    }
        
    self.drawingView.frame = frameToCenter;
    
    if(animation) 
        [UIView commitAnimations];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer 
{
    if(self.model.applicationState == STATE_MOVING)
    { 
        float newScale = [self.scrollView zoomScale] * ZOOM_STEP;
        newScale = newScale >= ZOOM_SCALE_MAXIMUM ? 1 : newScale;
        
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (void)handleDoubleTapZoomOut:(UIGestureRecognizer *)gestureRecognizer 
{
    if(self.model.applicationState == STATE_MOVING && self.scrollView.zoomScale != 1)
    {
        CGRect zoomRect = [self zoomRectForScale:1 withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center 
{
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollView frame].size.height / scale;
    zoomRect.size.width  = [self.scrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



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
    [self setContainerView:nil];
    [self setButtonPosition:nil];
    [self setTextFieldWidth:nil];
    [self setTextFieldHeight:nil];
    [super viewDidUnload];
}

@end
