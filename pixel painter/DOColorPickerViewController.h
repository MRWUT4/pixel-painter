//
//  DOSecondViewController.h
//  pixel painter
//
//  Created by David Ochmann on 29.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOColorPickerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *colorMapOutlet;

@property (nonatomic) CGPoint touchPosition;


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesHandler:(NSSet *)touches;


@end
