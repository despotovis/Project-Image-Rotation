#ifndef _VP_HPP_
#define _VP_HPP_

#include "common.hpp"
#include "cpu.hpp"
#include "vp_address.hpp"
#include "rotation.hpp"
#include "memory.hpp"
#include "interconnect.hpp"

class vp:sc_core::sc_module
{
public:
  vp(sc_core::sc_module_name);
  cpu soft;
protected:
  rotation hard;
  memory bram;
  interconnect ic;
};

#endif
