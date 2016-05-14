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

-(void)processMat1:(cv::Mat)mat1 mat2:(cv::Mat)ycbcr
{
#pragma unused(mat1)
    Mat ycrcb(ycbcr.rows, ycbcr.cols, CV_8UC3);
    
    int from_to[] = { 0,0, 1,2, 2,1 };
    cv::mixChannels(&ycbcr, 1, &ycrcb, 1, from_to, 3);
    Mat rgbMat;
    cvtColor(ycrcb, rgbMat, CV_YCrCb2RGB);
    
    [self matReady:rgbMat];
}

@end
