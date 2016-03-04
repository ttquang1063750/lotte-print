//
//  GradientBackground.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 3/1/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit
class GradientBackground: NSObject {
    class func gradientImage(textSize:CGSize)->UIImage{
        let width:CGFloat = textSize.width        // max 1024 due to Core Graphics limitations
        let height:CGFloat = textSize.height      // max 1024 due to Core Graphics limitations
        
        // create a new bitmap image context
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        
        // get context
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        // push context to make it current (need to do this manually because we are not drawing in a UIView)
        UIGraphicsPushContext(context);
        
        //draw gradient
        let glossGradient:CGGradientRef
        let rgbColorspace:CGColorSpaceRef
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [ (252/255), (221/255), (120/255), 0.85,  // Start color
            (252/255), (221/255), (120/255), 0.95] // End color

        rgbColorspace = CGColorSpaceCreateDeviceRGB()!
        glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations)!
        let startCenter:CGPoint = CGPointMake(0, 0)
        let endCenter:CGPoint = CGPointMake(textSize.width, 0)
        CGContextDrawLinearGradient(context, glossGradient, startCenter, endCenter, CGGradientDrawingOptions.DrawsBeforeStartLocation)
        
        // pop context
        UIGraphicsPopContext();
        
        // get a UIImage from the image context
        let gradientImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // clean up drawing environment
        UIGraphicsEndImageContext();
        
        return  gradientImage;
    }
}
