//
//  DOPixelPainterViewContoller.m
//  pixel painter
//
//  Created by David Ochmann on 07.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DOPixelPainterViewContoller.h"

@implementation DOPixelPainterViewContoller

@synthesize colorPickerView = _colorPickerView;
@synthesize fileSettingsView = _fileSettingsView;
@synthesize gradientView = _gradientView;
@synthesize colorPreviewView = _colorPreviewView;
@synthesize navigationView = _navigationView;
@synthesize folderView = _folderView;
@synthesize model = _model;
@synthesize subviewManager = _subviewManager;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){}
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.subviewManager addSubview:self.colorPickerView];
    [self.subviewManager addSubview:self.fileSettingsView];
    [self.subviewManager hideAlleSubviews];
    
    [self.subviewManager displaySubview:self.colorPickerView];
    
    
//    [self.gradientView setTheColor:[[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1]];
//    [self.gradientView setNeedsDisplay];
    
    
//    self.colorPreviewView.color = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1];
    
//  self.model.navigationStatus = NAVIGATION_STATUS_NAVIGATION;
    
    self.model.color = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1];
}

/* GETTER / SETTER */

- (DOPixelPainterModel *)model
{    
    if(!_model) 
    {
        _model = [[DOPixelPainterModel alloc] init];
        [_model addObserver:self forKeyPath:@"navigationStatus" options:NSKeyValueObservingOptionNew context:@selector(navigationStatus)];
        [_model addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:@selector(color)];
    }
    
    return _model;
}

- (DOSubviewManager *) subviewManager
{
    if(!_subviewManager) _subviewManager = [[DOSubviewManager alloc] init];    
    return _subviewManager;
}

/* OBSERVER IMPLEMENTATION */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(keyPath == @"navigationStatus") 
        [self changeNavigationStatus: (NSNumber *)[change valueForKey:@"new"]];
    
    if(keyPath == @"color")
    {
        UIColor *color = (UIColor *)[change valueForKey:@"new"];
        
        NSLog(@"observer %@", color);
        
        self.gradientView.theColor = color;
        [self.gradientView setupGradient];
        [self.gradientView setNeedsDisplay];
        
        self.colorPreviewView.color = color;
    }
}


/* NAVIGATION ANIMATION */

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

- (void)changeNavigationStatus:(NSNumber *)status
{
    CGRect navigationFrame = self.navigationView.frame;
        
    switch([status intValue]) 
    {
        case NAVIGATION_STATUS_CLOSED:
            navigationFrame.origin.y = NAVIGATION_POSITION_CLOSED;
            [self.folderView setImage: [UIImage imageNamed:@"rFolderOpen.png"]];
            break;
            
        case NAVIGATION_STATUS_NAVIGATION:
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

/* FILE IMPLEMENTATION */

- (IBAction)buttonFileTouchUpInsideHandler:(id)sender 
{
    [self.subviewManager displaySubview:self.fileSettingsView];
    self.model.navigationStatus = NAVIGATION_STATUS_SUBVIEW;
}

/* COLOR IMPLEMENTATION */

- (IBAction)buttonColorTouchUpInsideHandler:(id)sender 
{
    [self.subviewManager displaySubview:self.colorPickerView];
    self.model.navigationStatus = NAVIGATION_STATUS_SUBVIEW;
}

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
    [super viewDidUnload];
}

@end
