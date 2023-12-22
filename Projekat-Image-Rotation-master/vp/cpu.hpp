#ifndef _CPU_HPP_
#define _CPU_HPP_

#include "common.hpp"
#include "vp_address.hpp"
#include "rotation.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/tlm_quantumkeeper.h>

class cpu:public sc_core::sc_module
{
public:
  cpu(sc_core::sc_module_name);

  tlm_utils::simple_initiator_socket<cpu> cpu_ic_isoc1;
  tlm_utils::simple_initiator_socket<cpu> cpu_mem_isoc2;
  tlm_utils::simple_initiator_socket<cpu> cpu_mem_isoc1;
  tlm_utils::simple_target_socket<cpu> cpu_ic_tsoc;
  
  void setPath(char *pathB, char *pathI, char *pathO, char *pathA, char *pathD);
  
protected:
  int row, col, Angle;
  unsigned char ready, done;
  Point2i Boundary, NewBoundary;
  ImageMatrix2D Image2D, RotatedImage;
  char *pathBoundary, *pathIn, *pathOut, *pathAngle, *pathDirection;
  double radians = 0;
  std::string direction;

  tlm::tlm_generic_payload pl;
  sc_core::sc_time loct;
  tlm_utils::tlm_quantumkeeper qk;
  
  void CPU_process();
  void cpu_s();
  
  Point2i LoadBoundary(std::string path);
  Point2i FindNewBorder(Point2i CurrentBoundary, double angle);
  
  ImageMatrix2D LoadImageMakeMatrix(std::string path, int rows, int cols);
  void StoreImageToFile(std::string path, ImageMatrix2D image, int x, int y);
  
  int getAngle(std::string path);
  std::string getDirection(std::string path);
  double radian(double x);
  
  typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
  void b_transport(pl_t &, sc_core::sc_time &);
};

#endif
