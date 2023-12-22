#ifndef _MEMORY_HPP_
#define _MEMORY_HPP_

#include "common.hpp"
#include "vp_address.hpp"
#include <systemc>
#include <tlm>
#include <tlm_utils/simple_target_socket.h>

class memory:public sc_core::sc_module
{
public:
  memory(sc_core::sc_module_name);

  tlm_utils::simple_target_socket<memory> mem_rot_tsoc;
  tlm_utils::simple_target_socket<memory> mem_cpu_tsoc1;
  tlm_utils::simple_target_socket<memory> mem_cpu_tsoc2;
  
protected:
  ImageMatrix2D Image2D, RotatedImage2D;
  int rows, nrows;
  int cols, ncols;
  int Angle;
  std::string direction;
  
  typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
  void b_transport(pl_t&, sc_core::sc_time&);
  void msg(const pl_t&);
  void msgs(const pl_t&);
};

#endif
