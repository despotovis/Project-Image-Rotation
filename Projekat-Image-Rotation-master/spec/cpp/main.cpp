#include "common.hpp"
#include "FileOps.hpp"
#include "ImageProcessing.hpp"
#include <valgrind/callgrind.h>
using namespace cv;
using namespace std;



int main (int argc,char * argv[])
{


  if (argc < 5){
    cout << "Error!: To run properly use the following formulation: "<<
" make run Direction=left Degree=45 Boundry=~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Dimenzije.txt Pathi=~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Input.txt Patho=~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Output.txt"
<<endl; 

    return 0;
  }

 
  
  
  
  
  Point2f Boundry;

  Point2f NewBoundry;
 
  Boundry = LoadBoundry(argv[3]);
  
  ImageMatrix2D image,image2;

  
  image = LoadImageMakeMatrix(argv[4],Boundry.x,Boundry.y);


 
  
  CALLGRIND_START_INSTRUMENTATION;
  CALLGRIND_TOGGLE_COLLECT;
  NewBoundry = FindNewBorder(Boundry,stod(argv[2]));

  image2=GetRotatedImage(NewBoundry,Boundry,image,stod(argv[2]),argv[1]);

  CALLGRIND_TOGGLE_COLLECT;
  CALLGRIND_STOP_INSTRUMENTATION;
  StoreImageToFile(argv[5],image2,NewBoundry.x,NewBoundry.y);
  
  
  
  
  

  return 0;
  
} 
