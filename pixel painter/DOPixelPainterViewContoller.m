//
//  DOPixelPainterViewContoller.m
//  pixel painter
//
//  Created by David Ochmann on 07.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOPixelPainterViewContoller.h"
#import "DOConstants.h"

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
@synthesize buttonList = _buttonList;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){}
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{   
    self.buttonList = [[NSArray alloc] initWithObjects:self.buttonFile, self.buttonColor, nil];
    
    [self.subviewManager addSubview:self.colorPickerView];
    [self.subviewManager addSubview:self.fileSettingsView];
    [self.subviewManager hideAlleSubviews];

    [self.navigationView setFrame:CGRectMake(0, NAVIGATION_POSITION_NAVIGATION, self.navigationView.frame.size.width, self.navigationView.frame.size.height)];
  
    self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorPickedNotificationHandler:) name:NOTIFICATION_COLOR_PICKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorGradientPickedNotificationHandler:) name:NOTIFICATION_COLOR_GRADIENT_PICKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorDrawingViewPickedNotificationHandler:) name:NOTIFICATION_COLOR_DRAWINGVIEW_PICKED object:nil];
    
    self.model.color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
    self.gradientView.lock = YES;

    self.model.scrollEnabled = NO;
    
    self.scrollView.contentSize = CGSizeMake(self.drawingView.frame.size.width, self.drawingView.frame.size.height);
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 20;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    
    [self.scrollView setZoomScale:10 animated:NO];
}



/* GETTER / SETTER */

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
        [_model addObserver:self forKeyPath:@"scrollEnabled" options:NSKeyValueObservingOptionNew context:@selector(scrollEnabled)];
        [_model addObserver:self forKeyPath:@"subsite" options:NSKeyValueObservingOptionNew context:@selector(subsite)];
        [_model addObserver:self forKeyPath:@"drawingState" options:NSKeyValueObservingOptionNew context:@selector(drawingState)];        
    }
    
    return _model;
}

/* OBSERVER IMPLEMENTATION */

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
    else if(keyPath == @"scrollEnabled")
    {
        BOOL enabled = self.model.scrollEnabled;
        
        self.buttonMove.selected = enabled;
        self.scrollView.scrollEnabled = enabled;
        self.drawingView.scrollEnabled = enabled;
    }
    else if(keyPath == @"subsite")
    {
        [self openSubsite:self.model.subsite];
    }
    else if(keyPath == @"drawingState")
    {
        [self switchDrawingState:self.model.drawingState];
    }
}

/* NOTIFICATIONS */

- (void)colorPickedNotificationHandler:(NSNotification*)notification
{
    self.gradientView.lock = NO;
    self.model.color = self.colorPickerView.color;
}

- (void)colorGradientPickedNotificationHandler:(NSNotification*)notification
{
    self.gradientView.lock = YES;
    self.model.color = self.colorPickerView.color;    
}

- (void)colorDrawingViewPickedNotificationHandler:(NSNotification*)notification
{
    self.gradientView.lock = NO;
    self.model.color = self.drawingView.color;
    self.model.drawingState = STATE_DRAWING;
    
    [self.colorPickerView hideColorPickerAndResetColorPickerHorizontal];
}



/* IBACTION IMPLEMENTATIONS */

- (IBAction)buttonFolderTouchUpInsideHandler:(id)sender 
{
    switch (self.model.navigationStatus) 
    {            
        case NAVIGATION_STATUS_CLOSED:
            self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
            break;
            
        default:
            self.model.navigationStatus = NAVIGATION_STATUS_CLOSED;
            break;
    }
}

- (IBAction)buttonSubviewTouchUpInsideHandler:(id)sender 
{
    self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
}

- (IBAction)buttonMoveTouchUpInsideHandler:(id)sender 
{
    self.model.scrollEnabled = !self.model.scrollEnabled;
}

- (IBAction)buttonPickerTouchUpInsideHandler:(id)sender 
{
    self.model.drawingState = self.model.drawingState == STATE_DRAWING ? STATE_PICKING : STATE_DRAWING;
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
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.allowsEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    [self.drawingView.imageView setImage: originalImage];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)buttonFileTouchUpInsideHandler:(id)sender 
{
    self.model.navigationStatus = NAVIGATION_STATUS_SUBVIEW;
    self.model.subsite = SUBSITE_FILE;
}

- (IBAction)buttonColorTouchUpInsideHandler:(id)sender 
{
    self.model.navigationStatus = NAVIGATION_STATUS_SUBVIEW;
    self.model.subsite = SUBSITE_COLORPICKER;
}



/* ASSIST FUNCTIONS */

- (void)openSubsite:(unsigned int)subsite
{   
    [self unSelectSubsiteButtons];
    
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
            [self unSelectSubsiteButtons];
            navigationFrame.origin.y = NAVIGATION_POSITION_CLOSED;
            [self.folderView setImage: [UIImage imageNamed:@"rFolderOpen.png"]];
            break;
            
        case NAVIGATION_STATUS_NAVIGATION:
            [self unSelectSubsiteButtons];
            navigationFrame.origin.y = NAVIGATION_POSITION_NAVIGATION;
            [self.folderView setImage: [UIImage imageNamed:@"rFolderClose.png"]];
            break;
            
        case NAVIGATION_STATUS_SUBVIEW:
            navigationFrame.origin.y = NAVIGATION_POSITION_SUBVIEW;
            [self.folderView setImage: [UIImage imageNamed:@"rFolderClose.png"]];
            break;
    }
    
    [UIView beginAnimations:@"animationID" context:NULL];
    [UIView setAnimationDuration:NAVIGATION_ANIMATION_TIME];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    [self.navigationView setFrame:navigationFrame];
    
    [UIView commitAnimations];
}

- (void)unSelectSubsiteButtons
{
    for(uint i = 0; i < self.buttonList.count; ++i)
    {
        UIButton *button = [self.buttonList objectAtIndex:i];
        button.selected = NO;
    }
}

- (void)switchDrawingState:(unsigned int)state
{
    switch (self.model.drawingState) 
    {
        case STATE_DRAWING:
            self.buttonPicker.selected = NO;
            self.drawingView.mode = STATE_DRAWING;
            break;
            
        case STATE_PICKING:
            self.buttonPicker.selected = YES;
            self.drawingView.mode = STATE_PICKING;
            break;
    }
}


/* SCROLL VIEW IMPLEMENTATION */

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.drawingView;
}

/* PCIK PHOTO FROM LIBRARY */





/* UIVIEW IMPLEMENTATION */

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
    [super viewDidUnload];
}

@end
