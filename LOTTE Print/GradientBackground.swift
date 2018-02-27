//
//  GradientBackground.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 3/1/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit
class GradientBackground: NSObject {
    class func gradientImage(_ textSize:CGSize)->UIImage{
        let width:CGFloat = textSize.width        // max 1024 due to Core Graphics limitations
        let height:CGFloat = textSize.height      // max 1024 due to Core Graphics limitations
        
        // create a new bitmap image context
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // get context
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        // push context to make it current (need to do this manually because we are not drawing in a UIView)
        UIGraphicsPushContext(context);
        
        //draw gradient
        let glossGradient:CGGradient
        let rgbColorspace:CGColorSpace
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [ (189/255), (165/255), (91/255), 1.0,  // Start color
            (252/255), (221/255), (120/255), 1.0] // End color

        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace, colorComponents: components, locations: locations, count: num_locations)!
        let startCenter:CGPoint = CGPoint(x: 0, y: 0)
        let endCenter:CGPoint = CGPoint(x: textSize.width, y: 0)
        context.drawLinearGradient(glossGradient, start: startCenter, end: endCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        // pop context
        UIGraphicsPopContext();
        
        // get a UIImage from the image context
        let gradientImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        
        // clean up drawing environment
        UIGraphicsEndImageContext();
        
        return  gradientImage;
    }
}
