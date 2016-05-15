//
//  CVFBabyMon.m
//  BabyMon
//
//  Created by John Brewer on 5/14/16.
//  Copyright © 2016 Jera Design LLC. All rights reserved.
//

#import "CVFBabyMon.h"
#import "CVFTemperatureNotifications.h"

@implementation CVFBabyMon

NSString *const CVFTemperatureUpdateNotification = @"CVFTemperatureUpdateNotification";
NSString *const CVFFeverAlertNotification = @"CVFFeverAlertNotification";

//const int FEVER_THRESH = 31115; // 100.4 degrees F in 100ths of a Kelvin.
//const int FEVER_THRESH = 31015; // 98.6 degrees F in 100ths of a Kelvin.
const int FEVER_THRESH = 30875; // 35.6 C (~96 F) (per NIH forehead study)

using namespace cv;

-(void)processMat1:(cv::Mat)thermal mat2:(cv::Mat)ycbcr
{
    double min, max;
    cv::minMaxLoc(thermal, &min, &max);
    
    double maxKelvin = max / 100;
    double maxFahr = maxKelvin * 9.0 / 5.0 - 459.67;
    [[NSNotificationCenter defaultCenter] postNotificationName:CVFTemperatureUpdateNotification
                                                        object:[NSNumber numberWithFloat:maxFahr]];
    
    if (max > FEVER_THRESH) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CVFFeverAlertNotification
                                                            object:nil];
    }

    MatIterator_<uint16_t> it, end;
    for( it = thermal.begin<uint16_t>(), end = thermal.end<uint16_t>(); it != end; ++it) {
        if (*it < FEVER_THRESH) {
            *it = 0;
        }
    }
    
    Mat ycrcb(ycbcr.rows, ycbcr.cols, CV_8UC3);
    
    int from_to[] = { 0,0, 1,2, 2,1 };
    cv::mixChannels(&ycbcr, 1, &ycrcb, 1, from_to, 3);
    Mat rgbMat;
    cvtColor(ycrcb, rgbMat, CV_YCrCb2RGB);
    
    Mat planes[3];
    split(rgbMat,planes);
    cvtColor(planes[0], rgbMat, CV_GRAY2RGB);
    
    Mat mask;
    resize(thermal, mask, rgbMat.size());
    
    mask.convertTo(mask, CV_8U, 255.0 / 3885.0, -1858.5);
    
//    cvtColor(mask, rgbMat, CV_GRAY2RGB);

    Mat red(rgbMat.rows, rgbMat.cols, CV_8UC3, Scalar(255, 0, 0));
    
    red.copyTo(rgbMat, mask);
    
    [self matReady:rgbMat];
}

@end
