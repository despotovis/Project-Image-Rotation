#ifndef IMAGEPROCESSING_H
#define IMAGEPROCESSING_H
#include  "common.hpp"

ImageMatrix2D GetRotatedImage (cv::Point2i NewBoundry,cv::Point2i OldBoundry,ImageMatrix2D Oldimage,double angle,char * direction);
cv::Point2i FindNewBorder (cv::Point2f CurrentBoundry,double angle);





double power (double base, int exponent);
double sin_custom (double x , int br_clanova);
double radian (double x);
double factorial (int x);


#endif
