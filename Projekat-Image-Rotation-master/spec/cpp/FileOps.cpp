#include "FileOps.hpp"
#include <string>
using namespace std;
using namespace cv;


Point2i LoadBoundry(string path)
{
  
  Point2i Boundry;
  ifstream myBoundry;
  myBoundry.open(path);
  myBoundry>>Boundry.x>>Boundry.y;
  myBoundry.close();
  return Boundry;
}

ImageMatrix2D LoadImageMakeMatrix(string path,int rows, int cols){
  ImageMatrix2D Image2D;
  ImageMatrix1D PixelArray;
  pixel tmp;
  ifstream myimage;
  myimage.open(path);
  
  for ( int i = 0 ; i < rows; i++){
    
    Image2D.push_back(PixelArray);
    
    for (int j = 0 ; j < cols; j++){

      myimage >> tmp.blue >>tmp.green >>tmp.red;

      Image2D[i].push_back(tmp);

      
    }
  }

  myimage.close();
  return Image2D;
  
}

void StoreImageToFile(string path,ImageMatrix2D image,int x,int y){
  int k = 0;
  
  
  ofstream outfile;
  outfile.open(path);
  if (k == 0){
    outfile << x << " " << y << "\n";
    k=1;
  }
  if (k == 1){
    
    for (int i = 0; i < image.size(); i++)
      
      for(int j = 0; j < image[0].size(); j++)
	
	outfile << image[i][j].blue <<" "<< image[i][j].green<<" "<<image[i][j].red<<endl;
  }


  cout << "Finished 2" <<endl;
  outfile.close();
  
  
}
