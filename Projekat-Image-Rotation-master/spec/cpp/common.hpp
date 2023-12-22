#ifndef COMMON_H
#define COMMON_H
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp> 
#include <opencv2/imgproc.hpp> 
#include <iostream>
#include <vector>
#include <fstream>


struct pixel{
  int blue;
  int green;
  int red;
 
};

typedef std::vector <std::vector < pixel > > ImageMatrix2D;
typedef std::vector <pixel> ImageMatrix1D;


#endif 
