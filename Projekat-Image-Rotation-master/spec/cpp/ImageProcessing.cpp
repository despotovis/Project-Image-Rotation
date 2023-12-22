#include "ImageProcessing.hpp"

using namespace cv;
using namespace std;

ImageMatrix2D GetRotatedImage(Point2i NewBoundry,Point2i OldBoundry,ImageMatrix2D OldImage,double angle,char* direction){
  float rads = (angle * 3.14159265359 ) / 180 ;
  ImageMatrix2D RotatedImage;
  ImageMatrix1D PixelArray;
  pixel ZeroPixel;
  int x,y;
  int OldHeight = OldBoundry.x;
  int OldWidth = OldBoundry.y;
  
  double sinc = sin(rads);
  
  double cosc = sin(radian(90)-rads);
   
  int cy = OldWidth / 2;
  int cx = OldHeight / 2;
  string smer = direction;
  int NewHeight = NewBoundry.x;
  int NewWidth  = NewBoundry.y;
  
  int midx = NewHeight/2 ;
  int midy = NewWidth/2 ;
  RotatedImage.resize(NewHeight,vector<pixel>(NewWidth));
  
  for (int row = 0; row < NewHeight ; row++){

    for (int col= 0; col < NewWidth ; col++){
   
      if (smer == "right"){
      x  = (int)((row-midx ) * cosc - (col-midy) * sinc +cx);
      y  = (int)((col-midy ) * cosc + (row-midx) * sinc +cy);
      
      
      }

      if (smer == "left"){

       x  = (int)((row-midx ) * cosc + (col-midy) * sinc +cx);
       y  = (int)((col-midy ) * cosc - (row-midx) * sinc +cy);

       
      }
      if (x >= 0 && x< OldHeight && y >= 0 && y< OldWidth)
	{
	  RotatedImage[row][col]=(OldImage[x][y]);
	  
	}
      
      
    }
    
    
  }
  
  cout << "Finished" << endl;
  
  return RotatedImage;
  
  

  
}
Point2i FindNewBorder(Point2f CurrentBoundry,double angle){

  Point2i NewBoundry;
  double sinc,cosc;
  
  if(angle < 90) {

    sinc = sin(radian(angle));
    
    cosc = sin(radian(90-angle));
    
    NewBoundry.x =(int)( abs(CurrentBoundry.x * cosc) + abs(CurrentBoundry.y * sinc));
    NewBoundry.y =(int)(abs( CurrentBoundry.x * sinc) + abs(CurrentBoundry.y * cosc));
    cout << NewBoundry.x << " " <<NewBoundry.y << endl;
  }
  else{
    float x = CurrentBoundry.y;
    float y = CurrentBoundry.x;
    float rotangle = angle - 90;
    sinc = sin(radian(rotangle));
    cosc = sin(radian(90-rotangle));
     
    NewBoundry.x =(int)(abs( x * cosc) + abs(y * sinc));
    NewBoundry.y =(int)(abs( x * sinc) + abs(y * cosc));
    

  }
  cout << NewBoundry.x<<" ";
  cout << NewBoundry.y <<endl;
  
  return NewBoundry;
}

double factorial(int x) 
{
	double result_fact=1;

	for (;x>=1;x--){
		result_fact*=x;
	}	
return result_fact;
}

double radian(double x){
	double radians;
	double const pi = 3.14159265358979323846;
	radians=(pi/180)*x;

return radians;
}

double sin_custom(double x,int br_clanova){

	double tejlor=0;
	double rad=radian(x);
	double a,b,c;

	for(int y=0; y!=br_clanova; y++){
		a=power(-1,y);	
		b=factorial((2*y)+1);
		c=power(rad,(2*y)+1);
		tejlor=tejlor+(a*c/b);
}
return tejlor;
}

double power(double base, int exponent)
{
double result=1;
for (exponent; exponent>0; exponent--)
{
result = result * base;
}
return result;
}
