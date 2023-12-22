#include "vp.hpp"

using namespace sc_core;

vp::vp(sc_module_name name):
  sc_module(name),
  soft("cpu"),
  hard("rotation"),
  ic("interconnect"),
  bram("memory")
{
  soft.cpu_ic_isoc1.bind(ic.ic_cpu_tsoc);
  soft.cpu_mem_isoc2.bind(bram.mem_cpu_tsoc2);
  soft.cpu_mem_isoc1.bind(bram.mem_cpu_tsoc1);
  ic.ic_cpu_isoc.bind(soft.cpu_ic_tsoc);
  ic.ic_rot_isoc.bind(hard.rot_ic_tsoc);
  hard.rot_ic_isoc.bind(ic.ic_rot_tsoc);
  hard.rot_mem_isoc.bind(bram.mem_rot_tsoc);

  SC_REPORT_INFO("VP", "Platform is constructed");
}
  
