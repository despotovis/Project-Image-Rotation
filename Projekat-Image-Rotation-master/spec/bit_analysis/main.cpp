#include "common.hpp"
#include "../cpp/FileOps.hpp"
#include "ImageProcessing.hpp"
#include <valgrind/callgrind.h>
using namespace cv;
using namespace std;



int sc_main(int argc,char * argv[])
{
  
  
  if (argc < 5){
    cout << "Error!Use format: "<<
" make run Direction=left Degree=45 Boundry=~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Dimenzije.txt Pathi=~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Input.txt Patho=~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Output.txt" <<endl; 
    
    return 0;
  }
  Point2i Boundry;
  Point2i NewBoundry;
  point_rotated NewDims;
  point_unrotated OldDims;
  Boundry = LoadBoundry(argv[3]);
  OldDims.x=Boundry.x;
  OldDims.y=Boundry.y;
  ImageMatrix2D image,image2;

  
  image = LoadImageMakeMatrix(argv[4],Boundry.x,Boundry.y);


 
  
  //CALLGRIND_START_INSTRUMENTATION;
  //CALLGRIND_TOGGLE_COLLECT;
  NewBoundry = FindNewBorder(Boundry,stod(argv[2]));
  NewDims.x = NewBoundry.x;
  NewDims.y = NewBoundry.y;
  image2=SCGetRotatedImage(NewDims,OldDims,image,stoi(argv[2]),argv[1]);

  //CALLGRIND_TOGGLE_COLLECT;
  //CALLGRIND_STOP_INSTRUMENTATION;









  
    double lookup[MAX_SIZE_LOOKUP];
  LookupGenerateBitAnalysis( lookup,1024);
 

  double delta_cumulative = 0;
  double avgdelta = 0;
  double delta = 0;
  bool pass1 = false;
  bool pass2 = false;
  
  //Odredjivanje broja bita potrebnog sa prikaz u lookup tabeli//
  int W = 1;
  int L = 1;
  int W2= 1;
  //  cout <<"Sin je:"<< lookup[90] << endl;
  lookup_vector lookup_sc;
  
  do{
    for (int i = 1; i < 53; i++){
      W = i;
      for ( int j = 1; j <=W; j++){
	L = j;
	avgdelta = 0;
	delta_cumulative = 0;
        lookup_sc.clear();
	sin_result_sc1 sc_sinx(W,L);
	
	for ( int k = 0; k <= 720 ;k++){
	  sc_sinx = lookup[k];
	  lookup_sc.push_back(sc_sinx);
	  delta = abs(sc_sinx - lookup[k]);
	 
	  delta_cumulative +=delta;
	  
	}

	avgdelta = delta_cumulative/720;
	//cout << sc_sinx[0] << sc_sinx[90] << sc_sinx[180] << endl;//
	cout <<"Srednja greska je: " << avgdelta <<" za format: " << L << " " << W-L << endl;
	
	
	if (avgdelta < 0.00001){
	  pass2 = true;
	  // pass2 = SCGetRotatedImage_FormatChecker(NewBoundry,Boundry,image,stoi(argv[2]),argv[1],lookup_sc,W,L);
	  // cout << lookup_sc.size() << endl;
	  //cout << lookup_sc[0] << lookup_sc[90] <<endl;
	  //if (pass2 == true ) {
	    break;
	}
      





      }
      if  (avgdelta < 0.00001){

	break;}
	   
 
    }
    

    
   
    
    
    //sad prokusavamo da redukujemo broj bita  
  }while (pass2 ==false);
  cout << W << "." << L <<endl;
 
  /*  do{
      for(int i = W ;i > 0 ;i--){
      W2 = i;
      cout << "Format koji proveravamo: " << L <<"."<< W2-L << endl;
      pass2 = SCGetRotatedImage_FormatChecker(NewBoundry,Boundry,image,stoi(argv[2]),argv[1],lookup_sc,W2,L);
      if(pass2 == false){
	cout << "Prva greska se javlja za format: " << L <<"."<< W2-L << endl; 
	break;
	
	
      }
      
    }
    

    }while(pass2 == true);
  
  */
  
 
  StoreImageToFile(argv[5],image2,NewBoundry.x,NewBoundry.y);
  
  
  
  
  

  return 0;
  
} 
