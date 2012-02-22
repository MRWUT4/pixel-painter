//
//  DOPixelPainterViewContoller.h
//  pixel painter
//
//  Created by David Ochmann on 07.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOFolderView.h"
#import "DONavigationView.h"
#import "DOPixelPainterModel.h"

@interface DOPixelPainterViewContoller : UIViewController

@property (strong, nonatomic) DOPixelPainterModel *model;

@property (strong, nonatomic) IBOutlet DONavigationView *navigationView;

@property (strong, nonatomic) IBOutlet DOFolderView *folderView;

- (IBAction)folderButtonTouchUpInsideHandler:(id)sender;

- (void)changeNavigationStatus:(NSNumber *)to;

@end
