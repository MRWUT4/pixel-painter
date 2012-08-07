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


//@synthesize fileSettingsView = _fileSettingsView;
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
//@synthesize textFieldWidth = _textFieldWidth;
//@synthesize textFieldHeight = _textFieldHeight;
@synthesize colorPickerViewController = _colorPickerViewController;
@synthesize fileSettingsViewController = _fileSettingsViewController;

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
    self.model.drawingViewImage = self.drawingView.imageView;
    
    self.subsiteButtonList = [[NSArray alloc] initWithObjects:self.buttonFile, self.buttonColor, nil];    
    self.applicationButtonList = [[NSArray alloc] initWithObjects:self.buttonPen, self.buttonPicker, self.buttonMove, self.buttonErase, self.buttonPosition, nil];
    
    
    //COLOR PICKER VIEWCONTROLLER
    self.colorPickerViewController = [[DOColorPickerViewController alloc] initWithNibName:NSStringFromClass([DOColorPickerViewController class]) bundle:nil];
    self.colorPickerViewController.model = self.model;
    
    //FILE SETTINGS VIEWCONTROLLER
    self.fileSettingsViewController = [[DOFileSettingsViewController alloc] initWithNibName:NSStringFromClass([DOFileSettingsViewController class]) bundle:nil];
    self.fileSettingsViewController.model = self.model;
    self.fileSettingsViewController.drawingView = self.drawingView;
    self.fileSettingsViewController.imagePickerDelegate = self;
    
    [self.subviewManager initWithSubviewContainer:self.navigationView];
    [self.subviewManager addSubview:self.colorPickerViewController.view];
    [self.subviewManager addSubview:self.fileSettingsViewController.view];
    [self.subviewManager hideAlleSubviews];
    
    
    [self addChildViewController:self.fileSettingsViewController];
    
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
        self.colorPickerViewController.color = color;
    }
    else if(keyPath == @"hue")
    {
        self.colorPickerViewController.sliderHue.value = self.model.hue;
        self.colorPickerViewController.textHue.text = [NSString stringWithFormat:@"HUE %i°", (unsigned int)floor(self.model.hue * 360)];
    }
    else if(keyPath == @"saturation")
    {
        self.colorPickerViewController.sliderSaturation.value = self.model.saturation;
        self.colorPickerViewController.textSaturation.text = [NSString stringWithFormat:@"SATURATION %i%%", (unsigned int)floor(self.model.saturation * 100)];
    }
    else if(keyPath == @"brightness")
    {
        self.colorPickerViewController.sliderBrightness.value = self.model.brightness;
        self.colorPickerViewController.textBrightness.text = [NSString stringWithFormat:@"BRIGHTNESS %i%%", (unsigned int)floor(self.model.brightness * 100)];
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
            self.fileSettingsViewController.textFieldWidth.text = [NSString stringWithFormat:FIELD_RESIZE_WIDTH_TEXT, self.model.width];
            self.fileSettingsViewController.textFieldHeight.text = [NSString stringWithFormat:FIELD_RESIZE_HEIGHT_TEXT, self.model.height];
            
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
    self.model.color = self.colorPickerViewController.color;
    self.model.hue = self.colorPickerViewController.color.hue;
    self.model.brightness = self.colorPickerViewController.color.brightness;
    self.model.saturation = self.colorPickerViewController.color.saturation;
    self.model.applicationState = STATE_DRAWING;
}

- (void)colorDrawingViewPickedNotificationHandler:(NSNotification*)notification
{
    self.model.color = self.drawingView.color;
    self.model.hue = self.colorPickerViewController.color.hue;
    self.model.brightness = self.colorPickerViewController.color.brightness;
    self.model.saturation = self.colorPickerViewController.color.saturation;
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


/*
 * ASSIST FUNCTIONS
 */

- (void)openSubsite:(unsigned int)subsite
{   
    [self unSelectButtonList: self.subsiteButtonList];
    
    if(subsite == SUBSITE_FILE)
    {
        [self.subviewManager displaySubview:self.fileSettingsViewController.view];
        self.buttonFile.selected = YES;
    }
    else if(subsite == SUBSITE_COLORPICKER)
    {
        [self.subviewManager displaySubview:self.colorPickerViewController.view];
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

    [self.fileSettingsViewController setView:nil];
    [self.colorPickerViewController setView:nil];
    
    [super viewDidUnload];
}

@end
