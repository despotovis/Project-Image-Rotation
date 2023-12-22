#ifndef _INTERCONNECT_HPP_
#define _INTERCONNECT_HPP_

#include "common.hpp"
#include "vp_address.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/simple_initiator_socket.h>

class interconnect:public sc_core::sc_module
{
public:
  interconnect(sc_core::sc_module_name);

  tlm_utils::simple_target_socket<interconnect> ic_cpu_tsoc;
  //tlm_utils::simple_target_socket<interconnect> ic_cpu_tsoc2;
  tlm_utils::simple_initiator_socket<interconnect> ic_cpu_isoc;
    
  tlm_utils::simple_target_socket<interconnect> ic_rot_tsoc;
  tlm_utils::simple_initiator_socket<interconnect> ic_rot_isoc;

  //tlm_utils::simple_initiator_socket<interconnect> ic_mem_isoc;

protected:
  sc_core::sc_time offset;
  typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
  void b_transport(pl_t&, sc_core::sc_time&);
};

#endif
