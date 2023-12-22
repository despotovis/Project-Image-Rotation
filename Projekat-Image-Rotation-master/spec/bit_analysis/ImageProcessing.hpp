#ifndef IMAGEPROCESSING_H
#define IMAGEPROCESSING_H
#include  "common.hpp"

ImageMatrix2D SCGetRotatedImage (point_rotated NewBoundry,point_unrotated OldBoundry,ImageMatrix2D Oldimage,sc_angle angle,char * direction);
cv::Point2i FindNewBorder (cv::Point2i CurrentBoundry,double angle);
void LookupGenerateBitAnalysis(double * lookup, int n);
bool SCGetRotatedImage_FormatChecker(cv::Point2i NewBoundry,cv::Point2i OldBoundry,ImageMatrix2D OldImage,int angle,char* direction,lookup_vector lookup_tabela,int w,int i);



double power (double base, int exponent);
double sin_custom (double x , int br_clanova);
double radian (double x);
double factorial (int x);


#endif
