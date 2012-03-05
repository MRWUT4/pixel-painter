//
//  DODrawingView.m
//  pixel painter
//
//  Created by David Ochmann on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DODrawingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DODrawingView


@synthesize color = _color;
@synthesize scale = _scale;
@synthesize touchPosition = _touchPosition;
@synthesize imageView = _imageView;


-(id)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    
    if(self)
    {
        CATiledLayer *tempTiledLayer = (CATiledLayer*)self.layer;    
        tempTiledLayer.levelsOfDetail = 5;
        tempTiledLayer.levelsOfDetailBias = 2;
        self.opaque=YES;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:self.imageView];
        
        CGRect frame = self.imageView.frame;
        
 //       frame.size.width = frame.size.width * 2;
 //       frame.size.height = frame.size.height * 2;
        
        self.imageView.frame = frame;
        
        /*
        UIImage *scaledImage = [UIImage imageWithCGImage:[self.imageView.image CGImage] scale:4.0 orientation:UIImageOrientationUp];        
        [self.imageView setImage:scaledImage];
        [self.imageView setNeedsDisplay];
        
        [self.imageView setTransform:CGAffineTransformMakeScale(2, 2)];
        [self.imageView setNeedsDisplay];
        
        get bounds
        change frame
        restore bounds
        */
                
        
        CGRect imageFrame = self.imageView.frame;
        
        imageFrame.size.width = floor(imageFrame.size.width * 2);
        imageFrame.size.height = floor(imageFrame.size.height * 2);
        
        /*
        //[self.imageView setFrame:imageFrame];
        [self.imageView setBounds:CGRectMake(0, 0, imageBounds.size.width * 2, imageBounds.size.height * 2)];
        
        [self.imageView setNeedsDisplay];
        */

            /*
        CGRect newRect = CGRectIntegral(CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height));
//        CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
        CGImageRef imageRef = self.imageView.image.CGImage;
        
        NSLog(@"imageRef %@", self.imageView.image.CGImage);
        
        // Build a context that's the same dimensions as the new size
        CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                    imageFrame.size.width * 2,
                                                    imageFrame.size.height * 2,
                                                    CGImageGetBitsPerComponent(imageRef),
                                                    0,
                                                    CGImageGetColorSpace(imageRef),
                                                    CGImageGetBitmapInfo(imageRef));
        
        // Rotate and/or flip the image if required by its orientation
//        CGContextConcatCTM(bitmap, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap, kCGInterpolationNone);
        
        // Draw into the context; this scales the image
        CGContextDrawImage(bitmap, newRect, imageRef);
        
        // Get the resized image from the context and a UIImage
        CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        
        NSLog(@"newImage %f", newImage.size.width);
        
        [self.imageView setImage:newImage];
             */

        UIImage *scaledImage = [self resizeImage:self.imageView.image newSize:imageFrame.size];
//        [self.imageView setImage:scaledImage];
        
        NSLog(@"scaledImage %f", scaledImage.size.width);

    }
    
    return self;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize 
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);  
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();    
    
    return newImage;
}


+(Class)layerClass
{
    return [CATiledLayer class];
}

-(unsigned int)scale
{
    _scale = _scale <= 0 ? 1 : _scale;
    return _scale;
}

/*
- (UIImage *)resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality 
{    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.imageView.image.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}
*/

/*
 * TOUCHES MOVED HANDLER
 */

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchPosition = [[touches anyObject] locationInView:self];
    
    
//    self.touchPosition = CGPointMake((int) (self.touchPosition.x / self.scale), 
//                                     (int) (self.touchPosition.y / self.scale));

    self.touchPosition = CGPointMake((int) (self.touchPosition.x), (int) (self.touchPosition.y));

    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    CGContextRef cgContext = UIGraphicsGetCurrentContext();

//    CGContextSetAllowsAntialiasing(cgContext, NO);
//    CGContextSetShouldAntialias(cgContext, NO);
  
    CGContextScaleCTM(cgContext, self.scale, self.scale);

    CGContextSetFillColorWithColor(cgContext, self.color.CGColor); 
    CGContextFillRect(cgContext, CGRectMake(self.touchPosition.x, self.touchPosition.y, 1, 1));
    CGContextFlush(UIGraphicsGetCurrentContext());

    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
}

/*
 * DRAWING IMPLEMENTATION
 */

-(void)drawRect:(CGRect)r
{
    
}

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
    // The context is appropriately scaled and translated such that you can draw to this context
    // as if you were drawing to the entire layer and the correct content will be rendered.
    // We assume the current CTM will be a non-rotated uniformly scaled
    
    
    // affine transform, which implies that
    // a == d and b == c == 0
    // CGFloat scale = CGContextGetCTM(context).a;
    // While not used here, it may be useful in other situations.
    

    // The clip bounding box indicates the area of the context that
    // is being requested for rendering. While not used here
    // your app may require it to do scaling in other
    // situations.
    // CGRect rect = CGContextGetClipBoundingBox(context);
    
    
    // Set and draw the background color of the entire layer
    // The other option is to set the layer as opaque=NO;
    // eliminate the following two lines of code
    // and set the scroll view background color
    
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,self.bounds);
    
    // draw a simple plus sign
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,35,255);
    CGContextAddLineToPoint(context,35,205);
    CGContextAddLineToPoint(context,135,205);
    CGContextAddLineToPoint(context,135,105);
    CGContextAddLineToPoint(context,185,105);
    CGContextAddLineToPoint(context,185,205);
    CGContextAddLineToPoint(context,285,205);
    CGContextAddLineToPoint(context,285,255);
    CGContextAddLineToPoint(context,185,255);
    CGContextAddLineToPoint(context,185,355);
    CGContextAddLineToPoint(context,135,355);
    CGContextAddLineToPoint(context,135,255);
    CGContextAddLineToPoint(context,35,255);
    CGContextClosePath(context);
    
    // Stroke the simple shape
    CGContextStrokePath(context);
}


@end
