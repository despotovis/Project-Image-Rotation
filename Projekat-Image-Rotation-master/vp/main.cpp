#include "vp.hpp"

using namespace std;

int sc_main(int argc, char *argv[])
{
  if(argc < 5)
    {
      cout << "Invalid make. Try example below." << endl;
      cout << "Example: make run Angle=45 Direction=left" << endl;
      
      return 0;
    }
  
  vp uut("VirPlat");
  uut.soft.setPath(argv[1], argv[2], argv[3], argv[4], argv[5]);
  
  sc_start(2, sc_core::SC_SEC);

  return 0;
}
