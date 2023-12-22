#ifndef FILEOPS_H
#define FILEOPS_h
#include "common.hpp"

cv::Point2i LoadBoundry(std::string path);

ImageMatrix2D LoadImageMakeMatrix(std::string path,int rows,int cols);

void StoreImageToFile(std::string path,ImageMatrix2D image,int x,int y);



#endif
