#include "cpu.hpp"

using namespace std;
using namespace sc_core;
using namespace sc_dt;
using namespace tlm;

SC_HAS_PROCESS(cpu);
cpu::cpu(sc_module_name name):sc_module(name)
{
  SC_THREAD(CPU_process);
  cpu_ic_tsoc.register_b_transport(this, &cpu::b_transport);
  SC_REPORT_INFO("CPU", "Platform is constructed");
}

void cpu::setPath(char *pathB, char *pathI, char *pathO, char *pathA, char *pathD)
{
  cout << endl;
  pathBoundary = pathB;
  cout << pathBoundary << endl;

  pathIn = pathI;
  cout << pathIn << endl;

  pathOut = pathO;
  cout << pathOut << endl;

  pathAngle = pathA;
  cout << pathAngle << endl;

  pathDirection = pathD;
  cout << pathDirection << endl;
}

int cpu::getAngle(string path) //get value for Angle
{
  Angle = stoi(path);

  return Angle;
}

string cpu::getDirection(string path) //get value for Direction
{
  direction = path;
  
  return direction;
}

Point2i cpu::LoadBoundary(string path)
{
  ifstream myBoundary;
  myBoundary.open(path);
  myBoundary >> Boundary.x >> Boundary.y;
  myBoundary.close();
  SC_REPORT_INFO("CPU", "Loaded boundary");
  cout << endl;
  cout << "Row: " << Boundary.x << ", col: " << Boundary.y << endl;
  
  return Boundary;
}

ImageMatrix2D cpu::LoadImageMakeMatrix(string path, int rows, int cols)
{
  ImageMatrix1D PixelArray;
  pixel tmp;
  ifstream myimage;
  myimage.open(path);

  for(int i = 0; i < rows; i++)
    {
      Image2D.push_back(PixelArray);

      for(int j = 0; j < cols; j++)
	{
	  myimage >> tmp.blue >> tmp.green >> tmp.red;
	  Image2D[i].push_back(tmp);
	}
    }
  
  myimage.close();
  SC_REPORT_INFO("CPU", "Loaded image");
  
  return Image2D;
}

void cpu::StoreImageToFile(string path, ImageMatrix2D image, int x, int y)
{
  int k = 0;

  ofstream outfile;
  outfile.open(path);
  
  if(k == 0)
    {
      outfile << x << " " << y << "\n";
      k = 1;
    }
  
  if(k == 1)
    {
      for(int i = 0; i < image.size(); i++)
	for(int j = 0; j < image[0].size(); j++)
	  outfile << image[i][j].blue << " " << image[i][j].green << " " << image[i][j].red << endl;
    }

  outfile.close();
  SC_REPORT_INFO("CPU", "Image stored");
}

Point2i cpu::FindNewBorder(Point2i CurrentBoundary, double angle)
{
  angle = (double)Angle;
  double  sinc = 0;
  double  cosc = 0;
  double  rad  = 0;
  
  if(angle < 90)
    {
      rad = radian(angle);
      sinc = sin(rad);
      cosc = sin(radian(90) - rad);
   
      NewBoundary.x = (int)(abs(CurrentBoundary.x * cosc) + abs(CurrentBoundary.y * sinc));
      NewBoundary.y = (int)(abs(CurrentBoundary.x * sinc) + abs(CurrentBoundary.y * cosc));
    }
  else
    {
      double x = CurrentBoundary.y;
      double y = CurrentBoundary.x;
      
      rad = radian(angle - 90);
      sinc = sin(rad);
      cosc = sin(radian(90) - rad);
      
      NewBoundary.x = (int)((abs(x * cosc) + abs(y * sinc)));
      NewBoundary.y = (int)((abs( x * sinc) + abs( y * cosc)));
    }

  SC_REPORT_INFO("CPU", "New boundary generated");
  
  return NewBoundary;
}

double cpu::radian(double x)
{
  double pi = 3.14159265358979323846;
  radians = pi * (x / 180);

  return radians;
}

void cpu::CPU_process()
{
  qk.reset();

  LoadBoundary(pathBoundary);

  SC_REPORT_INFO("CPU", "Row sent to memory"); //Boundary.x sent to memory
  pl.set_command(TLM_WRITE_COMMAND);
  pl.set_address(MEMORY_BOUNDARY_ROW);
  pl.set_data_ptr((unsigned char *)&Boundary.x);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);

  cpu_mem_isoc1 -> b_transport(pl, loct);
  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);

  SC_REPORT_INFO("CPU", "Col sent to memory"); //Boundary.y sent to memory
  pl.set_command(TLM_WRITE_COMMAND);
  pl.set_address(MEMORY_BOUNDARY_COL);
  pl.set_data_ptr((unsigned char *)&Boundary.y);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);

  cpu_mem_isoc1 -> b_transport(pl, loct);
  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);

  LoadImageMakeMatrix(pathIn, Boundary.x, Boundary.y); //Loading image

  SC_REPORT_INFO("CPU", "Image sent to memory"); //Image sent to memory
  pl.set_command(TLM_WRITE_COMMAND);
  pl.set_address(MEMORY_IMAGE);
  pl.set_data_ptr((unsigned char *)&Image2D);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);

  cpu_mem_isoc1 -> b_transport(pl, loct);
  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);
 
  getAngle(pathAngle); //Loading Angle

  SC_REPORT_INFO("CPU", "Angle sent to memory"); //Angle sent memory
  pl.set_command(TLM_WRITE_COMMAND);
  pl.set_address(MEMORY_ANGLE);
  pl.set_data_ptr((unsigned char *)&Angle);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);
  
  cpu_mem_isoc1 -> b_transport(pl, loct);
  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);

  getDirection(pathDirection); //Loading direction

  SC_REPORT_INFO("CPU", "Direction sent to memory"); //Direction sent to memory
  pl.set_command(TLM_WRITE_COMMAND);
  pl.set_address(MEMORY_DIRECTION);
  pl.set_data_ptr((unsigned char *)&direction);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);
  
  cpu_mem_isoc1 -> b_transport(pl, loct);
  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);
  
  FindNewBorder(Boundary, Angle); //Loading NewBoundary

  SC_REPORT_INFO("CPU", "NewRow sent to memory"); //NewBoundary.x sent to memory
  pl.set_command(TLM_WRITE_COMMAND);
  pl.set_address(MEMORY_BOUNDARY_NROW);
  pl.set_data_ptr((unsigned char *)&NewBoundary.x);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);

  cpu_mem_isoc1 -> b_transport(pl, loct);
  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);

  SC_REPORT_INFO("CPU", "NewCol sent to memory"); //NewBoundary.y sent to memory
  pl.set_command(TLM_WRITE_COMMAND);
  pl.set_address(MEMORY_BOUNDARY_NCOL);
  pl.set_data_ptr((unsigned char *)&NewBoundary.y);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);

  cpu_mem_isoc1 -> b_transport(pl, loct);
  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);

  SC_REPORT_INFO("CPU", "Ready sent to Rotation"); //Ready sent to Rotation
  pl.set_command(TLM_WRITE_COMMAND); 
  pl.set_address(VP_ADDRESS_ROTATION_READY);
  pl.set_data_ptr((unsigned char *)&ready);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);

  cpu_ic_isoc1 -> b_transport(pl, loct);
  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);
}

void cpu::cpu_s()
{
  SC_REPORT_INFO("ROTATION", "Rotated image loaded from memory");     //Image loaded from memory
  pl.set_command(TLM_READ_COMMAND);
  pl.set_address(MEMORY_ROTATED_IMAGE);
  pl.set_data_ptr((unsigned char*)& RotatedImage);
  pl.set_response_status(TLM_INCOMPLETE_RESPONSE);
  cpu_mem_isoc2 -> b_transport(pl, loct);

  RotatedImage = *((ImageMatrix2D*)pl.get_data_ptr());             //Loading image

  qk.set_and_sync(loct);
  loct += sc_time(5, SC_NS);

  StoreImageToFile(pathOut, RotatedImage, NewBoundary.x, NewBoundary.y);
}

void cpu::b_transport(pl_t& pl, sc_time& offset)
{
  tlm_command cmd = pl.get_command();
  uint64 addr = pl.get_address();
  unsigned char *data = pl.get_data_ptr();

  switch(cmd)
    {
    case TLM_WRITE_COMMAND:
      {
	switch(addr)
	  {
	  case VP_ADDRESS_CPU:
	    done = *((unsigned char*)pl.get_data_ptr());
	    SC_REPORT_INFO("CPU", "Rotated image loaded from memory");
	    pl.set_response_status(TLM_OK_RESPONSE);
	    cpu_s();
	    break;
	  default:
	    SC_REPORT_INFO("CPU", "Invalid address");
	    break;
	  }
      }
      break;
    default:
      SC_REPORT_INFO("CPU", "Invalid TLM command");
      break;
    }
  
  offset += sc_time(5, SC_NS);
}
