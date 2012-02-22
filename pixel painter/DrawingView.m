//
//  DrawingView.m
//  pixel perfect
//
//  Created by David Ochmann on 30.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawingView.h"
//#import "UIColor-DOHexColor.h"
//#import "Model.h"

@implementation DrawingView

@synthesize drawImage;
@synthesize color;

/*
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) 
    {
        scale = 8;
        color = [UIColor colorWithHex:0x000000];
        
        drawImage = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:drawImage];
    }
    return self;
}
 */

/*
 * SETTER
 */

- (void)setScale:(CGFloat)pScale
{
    scale = pScale;
}

/*
 * GETTER
 */

- (CGFloat)scale
{
    return scale;
}

/*
 * TOUCHES MOVED HANDLER
 */
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchPosition = [[touches anyObject] locationInView:drawImage];
    
    touchPosition.x = (int) (touchPosition.x / scale);
    touchPosition.y = (int) (touchPosition.y / scale);

    UIGraphicsBeginImageContext(self.frame.size);
    [drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cgContext = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(cgContext, scale, scale);
    
    CGContextSetFillColorWithColor(cgContext, color.CGColor); 
    CGContextFillRect(cgContext, CGRectMake(touchPosition.x, touchPosition.y, 1, 1));
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
}
*/
@end
