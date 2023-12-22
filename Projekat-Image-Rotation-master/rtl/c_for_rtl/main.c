int main()
{ 
  unsigned char ready = 1;
  unsigned char start = 1;

  int new_height_i;
  int new_width_i;

  int old_height_i;
  int old_width_i;

  int midx_i;
  int midy_i;

  int cx_i;
  int cy_i;
  
  int pixel_data_r_in[old_height_i * old_width_i];
  int pixel_data_b_in[old_height_i * old_width_i];
  int pixel_data_g_in[old_height_i * old_width_i];

  int pixel_reg_r;
  int pixel_reg_b;
  int pixel_reg_g;

  int pixel_data_r_out [new_height_i * new_width_i];
  int pixel_data_g_out [new_height_i * new_width_i];
  int pixel_data_b_out [new_height_i * new_width_i];

  int pixel_address_o;

  unsigned char l_r_i; // left 0 right 1 //
 
  int row =0;
  int col =0;

  int x_o;
  int y_o;

  double sinc_i;
  double cosc_i;

  
 idle:
    ready = 1;
    if (start)
    {
        start = 0;
        goto direction_decision;
    }
    else
    {
        goto idle;
    } 
  
 direction_decision:
  if(l_r_i == 0)
    {
    goto point_calculation_left;
    }
  else
    {
    goto point_calculation_right;
    }
  

 point_calculation_left:
  x_o  = (row-midx ) * cosc - (col-midy) * sinc +cx;
  y_o  = (col-midy ) * cosc + (row-midx) * sinc +cy;
  
  
  if (x_o >= 0 && x_o < OldHeight && y_o >= 0 && y_o < OldWidth)
    {
      goto calculate_data_adress; 
    }
  
 point_calculation_right:
  x_o  = (row-midx ) * cosc + (col-midy) * sinc +cx;
  y_o  = (col-midy ) * cosc - (row-midx) * sinc +cy;

  if (x_o >= 0 && x_o < OldHeight && y_o >= 0 && y_o < OldWidth)
    {
      goto calculate_data_adress; 
    }

 calculate_data_adress:
  pixel_adress_in = old_heigth * x_o + y_o;
  pixel_adress_out= new_heigth * row + col;
  
  goto load_input_data;

 load_input_data:
  pixel_reg_r = pixel_data_r_in [pixel_adress_in];
  pixel_reg_b = pixel_data_b_in [pixel_adress_in];
  pixel_reg_g = pixel_data_g_in [pixel_adress_in];
  
  goto store_output_data;

 store_output_data:

  pixel_data_r_out[pixel_adress_out] = pixel_reg_r;
  pixel_data_g_out[pixel_adress_out] = pixel_reg_g;
  pixel_data_b_out[pixel_adress_out] = pixel_reg_b;
  col = col + 1;

  if (col  == new_width_i)
    {
    if (row == new_heigth_i)
      {
      goto idle;
      }
    else
      {
	row = row +1;
	goto reset_col;
      }
    }
  else
    {
    if(l_r_i == 0)
      {
	goto point_calculation_left;
      }
    else
      {
	goto point_calculation_right;
      }
    }

 reset_col:
  col = 0;
  if(l_r_i == 0)
    {
      goto point_calculation_left;
    }
  else
    {
      goto point_calculation_right;
    }
 
  }
  
  return 0;



}
