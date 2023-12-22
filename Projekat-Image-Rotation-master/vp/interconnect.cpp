#include "interconnect.hpp"

using namespace std;
using namespace sc_core;
using namespace sc_dt;
using namespace tlm;

interconnect::interconnect(sc_module_name name):sc_module(name),
						offset(SC_ZERO_TIME)
{
  ic_rot_tsoc.register_b_transport(this, &interconnect::b_transport);
  ic_cpu_tsoc.register_b_transport(this, &interconnect::b_transport);
  //ic_cpu_tsoc2.register_b_transport(this, &interconnect::b_transport);
  SC_REPORT_INFO("INTERCONNECT", "Platform is constructed");
}

void interconnect::b_transport(pl_t& pl, sc_time& offset)
{
  uint64 taddr = 0;
  tlm_command cmd = pl.get_command();
  uint64 addr = pl.get_address();
  unsigned char *data = pl.get_data_ptr();

  switch(cmd)
    {
    case TLM_WRITE_COMMAND:
      {
	if(addr >= VP_ADDRESS_ROTATION && addr <= VP_ADDRESS_ROTATION_READY)
	  {
	    taddr = addr & 0x000FFFFF;
	    pl.set_address(taddr);
	    ic_rot_isoc -> b_transport(pl, offset);
	    pl.set_address(addr);
	  }
	//else if(addr >= VP_ADDRESS_MEMORY && addr <= VP_ADDRESS_MEMORY_ROTATED_IMAGE)
	//{
	//taddr = addr & 0x000FFFFF;
	//pl.set_address(taddr);
	//ic_mem_isoc -> b_transport(pl, offset);
	///pl.set_address(addr);
	//}
	else if(addr == VP_ADDRESS_CPU)
	  ic_cpu_isoc -> b_transport(pl, offset);

	pl.set_address(addr);
      }
      break;
      //case TLM_READ_COMMAND:
      //{
      //taddr = addr & 0x0000000F;
      //pl.set_address(taddr);
      //ic_mem_isoc -> b_transport(pl, offset);
      //pl.set_address(addr);
      //}
      //break;
    default:
      pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
      SC_REPORT_ERROR("INTERCONNECT", "TLM bad command");
    }
  offset += sc_time(5, SC_NS);
}
