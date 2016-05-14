//
//  CVFBabyMon.m
//  BabyMon
//
//  Created by John Brewer on 5/14/16.
//  Copyright © 2016 Jera Design LLC. All rights reserved.
//

#import "CVFBabyMon.h"

@implementation CVFBabyMon

using namespace cv;

-(void)processMat1:(cv::Mat)mat1 mat2:(cv::Mat)mat2
{
#pragma unused(mat2)
    cv::Mat equalized;
    
    double min, max;
    
    MatIterator_<uint16_t> it, end;
    for( it = mat1.begin<uint16_t>(), end = mat1.end<uint16_t>(); it != end; ++it) {
        if (*it < 13500) {
            *it = 13500;
        }
    }
    
    cv::minMaxLoc(mat1, &min, &max);
    NSLog(@"min: %f max: %f", min, max);
    normalize(mat1, equalized, 0, 16384, cv::NORM_MINMAX);
    equalized.convertTo(equalized, CV_8UC1, 0.015625);
    [self matReady:equalized];
}

@end
