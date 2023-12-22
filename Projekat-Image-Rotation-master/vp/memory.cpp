#include "common.hpp"
#include "memory.hpp"
#include <sstream>

using namespace std;
using namespace sc_core;
using namespace tlm;
using namespace sc_dt;

memory::memory(sc_module_name name):sc_module(name)
				    //mem_ic_tsoc("ic_mem_soc")
{
  mem_rot_tsoc.register_b_transport(this, &memory::b_transport);
  mem_cpu_tsoc1.register_b_transport(this, &memory::b_transport);
  mem_cpu_tsoc2.register_b_transport(this, &memory::b_transport);
  SC_REPORT_INFO("MEMORY", "Platform is constructed.");
}

void memory::b_transport(pl_t& pl, sc_time& offset)
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
	  case MEMORY_BOUNDARY_ROW:  //MEMORY place 0
	    rows = *((int*)pl.get_data_ptr());
	    pl.set_response_status(TLM_OK_RESPONSE);
	    msg(pl);
	    break;
	  case MEMORY_BOUNDARY_COL:  //MEMORY place 1
	    cols = *((int*)pl.get_data_ptr());
	    pl.set_response_status(TLM_OK_RESPONSE);
	    msg(pl);
	    break;
	  case MEMORY_IMAGE:         //MEMORY place 2
	    Image2D = *((ImageMatrix2D*)pl.get_data_ptr());
	    pl.set_response_status(TLM_OK_RESPONSE);
	    SC_REPORT_INFO("Memory", "Image received");
	    break;
	  case MEMORY_ANGLE:         //MEMORY place 3
	    Angle = *((int*)pl.get_data_ptr());
	    pl.set_response_status(TLM_OK_RESPONSE);
	    msg(pl);
	    break;
	  case MEMORY_DIRECTION:     //MEMORY place 4
	    direction = *((string*)pl.get_data_ptr());
	    pl.set_response_status(TLM_OK_RESPONSE);
	    msgs(pl);
	    break;
	  case MEMORY_BOUNDARY_NROW: //MEMORY place 5
	    nrows = *((int*)pl.get_data_ptr());
	    pl.set_response_status(TLM_OK_RESPONSE);
	    msg(pl);
	    break;
	  case MEMORY_BOUNDARY_NCOL: //MEMORY place 6
	    ncols = *((int*)pl.get_data_ptr());
	    pl.set_response_status(TLM_OK_RESPONSE);
	    msg(pl);
	    break;
	  case MEMORY_ROTATED_IMAGE:         //MEMORY place 7
	    RotatedImage2D = *((ImageMatrix2D*)pl.get_data_ptr());
	    pl.set_response_status(TLM_OK_RESPONSE);
	    SC_REPORT_INFO("Memory", "Rotated image received");
	    break;
	  default:
	    pl.set_response_status(TLM_ADDRESS_ERROR_RESPONSE);
	    SC_REPORT_ERROR("MEMORY", "Invalid address");
	    break; 
	  }
      }
      break;
    case TLM_READ_COMMAND:
      {
	switch(addr)
	  {
	  case MEMORY_BOUNDARY_ROW:  //MEMORY place 0
	    pl.set_data_ptr((unsigned char *)& rows);
	    pl.set_response_status(TLM_OK_RESPONSE);
	    break;
	  case MEMORY_BOUNDARY_COL:  //MEMORY place 1
	    pl.set_data_ptr((unsigned char *)& cols);
	    pl.set_response_status(TLM_OK_RESPONSE);
	    break;
	  case MEMORY_IMAGE:         //MEMORY place 2
	    pl.set_data_ptr((unsigned char *)& Image2D);
	    pl.set_response_status(TLM_OK_RESPONSE);
	    break;
	  case MEMORY_ANGLE:         //MEMORY place 3
	    pl.set_data_ptr((unsigned char *)& Angle);
	    pl.set_response_status(TLM_OK_RESPONSE);
	    break;
	  case MEMORY_DIRECTION:     //MEMORY place 4
	    pl.set_data_ptr((unsigned char *)& direction);
	    pl.set_response_status(TLM_OK_RESPONSE);
	    break;
	  case MEMORY_BOUNDARY_NROW: //MEMORY place 5
	    pl.set_data_ptr((unsigned char *)& nrows);
	    pl.set_response_status(TLM_OK_RESPONSE);
	    break;
	  case MEMORY_BOUNDARY_NCOL: //MEMORY place 6
	    pl.set_data_ptr((unsigned char *)& ncols);
	    pl.set_response_status(TLM_OK_RESPONSE);
	    break;
	  default:
	    pl.set_response_status(TLM_ADDRESS_ERROR_RESPONSE);
	    SC_REPORT_INFO("MEMORY", "Invalid address");
	    break;
	  case MEMORY_ROTATED_IMAGE:         //MEMORY place 7
	    pl.set_data_ptr((unsigned char *)& RotatedImage2D);
	    pl.set_response_status(TLM_OK_RESPONSE);
	    break;
	  }
      }
      break;
    default:
      pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
      SC_REPORT_INFO("MEMORY", "TLM invalid command");
      break;
    }
  offset += sc_time(5, SC_NS);
}

void memory::msg(const pl_t& pl)
{
  stringstream ss;
  ss << hex << pl.get_address();
  int val = *((int*)pl.get_data_ptr());
  string cmd = pl.get_command() == TLM_READ_COMMAND ? "read " : "write ";
  string msg = cmd + " val: " + to_string((int)val) + ", addr: " + ss.str();
  msg += ", at " + sc_time_stamp().to_string();

  SC_REPORT_INFO("MEMORY", msg.c_str());
}

void memory::msgs(const pl_t& pl)
{
  stringstream ss;
  ss << hex << pl.get_address();
  string val = *((string*)pl.get_data_ptr());
  string cmd = pl.get_command() == TLM_READ_COMMAND ? "read " : "write ";
  string msgs = cmd + " val: " + val + ", addr: " + ss.str();
  msgs += ", at " + sc_time_stamp().to_string();

  SC_REPORT_INFO("MEMORY", msgs.c_str());
}
  
  
				      
