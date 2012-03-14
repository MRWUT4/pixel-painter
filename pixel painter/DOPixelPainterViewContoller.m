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
@synthesize gradientView = _gradientView;
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
    self.model.color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
    self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
    self.model.applicationState = STATE_DRAWING;
    self.model.navigationAnimationTime = NAVIGATION_ANIMATION_TIME;
    
    self.subsiteButtonList = [[NSArray alloc] initWithObjects:self.buttonFile, self.buttonColor, nil];    
    self.applicationButtonList = [[NSArray alloc] initWithObjects:self.buttonPen, self.buttonPicker, self.buttonMove, self.buttonErase, nil];
    
    [self.subviewManager addSubview:self.colorPickerView];
    [self.subviewManager addSubview:self.fileSettingsView];
    [self.subviewManager hideAlleSubviews];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorPickedNotificationHandler:) name:NOTIFICATION_COLOR_PICKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorGradientPickedNotificationHandler:) name:NOTIFICATION_COLOR_GRADIENT_PICKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorDrawingViewPickedNotificationHandler:) name:NOTIFICATION_COLOR_DRAWINGVIEW_PICKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorDrawingViewEraseNotificationHandler:) name:NOTIFICATION_COLOR_ERASE_PICKED object:nil];
    
    self.gradientView.lock = YES;

    self.scrollView.contentSize = CGSizeMake(self.drawingView.frame.size.width, self.drawingView.frame.size.height);
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 50;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;    
    [self.scrollView setZoomScale:10 animated:NO];
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
        
        self.gradientView.theColor = color;
        [self.gradientView setupGradient];
        [self.gradientView setNeedsDisplay];
        
        self.colorPreviewView.color = color;
        
        self.drawingView.color = color;
        self.colorPickerView.color = color;
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
    self.gradientView.lock = NO;
    self.model.color = self.colorPickerView.color;
    self.model.applicationState = STATE_DRAWING;
}

- (void)colorGradientPickedNotificationHandler:(NSNotification*)notification
{
    self.gradientView.lock = YES;
    self.model.color = self.colorPickerView.color;    
    self.model.applicationState = STATE_DRAWING;
}

- (void)colorDrawingViewPickedNotificationHandler:(NSNotification*)notification
{
    self.gradientView.lock = NO;
    self.model.color = self.drawingView.color;
    self.model.applicationState = STATE_DRAWING;
    
    [self.colorPickerView hideColorPickerAndResetColorPickerHorizontal];
}

- (void)colorDrawingViewEraseNotificationHandler:(NSNotification*)notification
{
//    self.model.color = nil;
    self.model.applicationState = STATE_ERASING;
}



/* 
 * IBACTION IMPLEMENTATIONS 
 */

/*
- (IBAction)buttonSubviewTouchUpInsideHandler:(id)sender 
{
    self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
}
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    [self.drawingView.imageView setImage: originalImage];
    [self dismissModalViewControllerAnimated:YES];
}

/* IBACTIONS FILE SUBVIEW */

- (IBAction)buttonFileTouchUpInsideHandler:(id)sender 
{
    self.model.navigationStatus = NAVIGATION_STATUS_SUBVIEW;
    self.model.subsite = SUBSITE_FILE;
}

- (IBAction)buttonSaveTouchUpInsideHandler:(id)sender 
{
    UIImage *image = [UIImage imageWithCGImage:self.drawingView.imageView.image.CGImage];
    NSData *imageData = UIImagePNGRepresentation ( image ); 
    UIImage *imagePNG = [UIImage imageWithData:imageData];
    
    UIImageWriteToSavedPhotosAlbum(imagePNG, nil, nil, nil);
}

- (IBAction)buttonPullTouchUpInsideHandler:(id)sender 
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.allowsEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

/* IACTIONS SLIDER */

- (IBAction)sliderHueValueChangedHandler:(UISlider *)sender 
{    
    UIColor *color = self.model.color;
    
    self.model.color = [[UIColor alloc] initWithHue:sender.value 
                                saturation:color.saturation 
                                brightness:color.brightness 
                                alpha:1];
    
    NSLog(@"color %@", color);
}

- (IBAction)sliderBrightnessValueChangedHandler:(UISlider *)sender 
{
    NSLog(@"brightness %f", sender.value);
}

- (IBAction)sliderSaturationValueChangedHandler:(UISlider *)sender 
{
    NSLog(@"saturation %f", sender.value);
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
    
    [UIView beginAnimations:@"animationID" context:NULL];
    [UIView setAnimationDuration:self.model.navigationAnimationTime];
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
    [self setGradientView:nil];
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
