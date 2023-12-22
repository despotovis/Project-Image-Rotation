#ifndef _ROTATION_HPP_
#define _ROTATION_HPP_

#include "common.hpp"
#include "vp_address.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/tlm_quantumkeeper.h>

class rotation:public sc_core::sc_module
{
public:
  rotation(sc_core::sc_module_name);

  tlm_utils::simple_target_socket<rotation> rot_ic_tsoc;
  tlm_utils::simple_initiator_socket<rotation> rot_ic_isoc;
  tlm_utils::simple_initiator_socket<rotation> rot_mem_isoc;

protected:
  int rows, cols;
  int nrows, ncols;
  int Angle;
  Point2i Boundary, NewBoundary;
  unsigned char ready, done;
  std::string direction;
  ImageMatrix2D Image2D, RotatedImage;
  
  tlm::tlm_generic_payload pl;
  sc_core::sc_time offset;
  tlm_utils::tlm_quantumkeeper qk;

  ImageMatrix2D GetRotatedImage(Point2i NewBoundary, Point2i OldBoundary, ImageMatrix2D OldImage, sc_angle angle, std::string direction);
  
  typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
  void b_transport(pl_t &, sc_core::sc_time &);
  void rotation_s();  
};

#endif
