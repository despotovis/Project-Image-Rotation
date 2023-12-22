#ifndef _COMMON_HPP_
#define _COMMON_HPP_

#define SC_INCLUDE_FX
#include <iostream>
#include <vector>
#include <systemc>
#include <fstream>

#define PI 3.141592653589793116
#define LOOKUP_TABLE_SIZE 1024
#define W_FL 18
#define I_FL 2
#define Q_FL sc_dt::SC_RND
#define O_FL sc_dt::SC_SAT
#define ANGLE_BITS 9
#define MAX_SIZE_LOOKUP 1024 //9 bita 512 lokac za reprezentaciju svih vrednosti sinusa + 90 za cos//
#define MAX_BITS_ROTATED 13
#define MAX_BITS_UNROTATED 11
#define MAX_ROTATED_PADDING 12
#define MAX_UNROTATED_PADDING 10

struct pixel
{
  int blue, green, red;
};

struct Point2i
{
  int x, y;
};

typedef sc_dt::sc_fix_fast sin_result_sc1;
typedef sc_dt::sc_fixed_fast <W_FL, I_FL, Q_FL, O_FL>  sin_result_sc;
//typedef sc_dt::sc_uint<8> SC_pixel_value_type;
typedef std::vector<std::vector<pixel>> ImageMatrix2D;
typedef std::vector<pixel> ImageMatrix1D;
typedef std::vector <sin_result_sc> lookup_vector;
typedef sc_dt::sc_int<MAX_BITS_ROTATED> rotated_size;
typedef sc_dt::sc_uint<MAX_BITS_UNROTATED>unrotated_size;
typedef sc_dt::sc_int<MAX_ROTATED_PADDING>rotated_padding;
typedef sc_dt::sc_uint<MAX_UNROTATED_PADDING>unrotated_padding;
typedef sc_dt::sc_uint<ANGLE_BITS> sc_angle;

struct point_unrotated
{
  unrotated_size x;
  unrotated_size y;
};

struct point_rotated
{
  rotated_size x;
  rotated_size y;
};

#endif
