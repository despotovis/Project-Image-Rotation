import cv2 as cv
import numpy as np
import sys
k = 0
#Za prikazivanje rotirane slike koristiti kao prvi argument primer: python3 output.py ~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Output.txt
pixels = []
boundrys =[]
if len(sys.argv) != 2:
    print("Script wasn't calle properly!")
    exit()

file1 = open(sys.argv[1], "r")
if k == 0:
  text = file1.readline()
  boundrys=text.split(" ")

 
  m =int(boundrys[0])
  n =int(boundrys[1])
  blank_image =np.zeros((m,n,3),np.uint8)
  print (blank_image.shape[0])
  print (blank_image.shape[1])
  k=k+1
if k ==1:
    for i in range (0,m):
        for j in range(0,n):
         

            text = file1.readline()
            pixels=text.split(" ")
            blank_image[i,j,0] = pixels [0]
            blank_image[i,j,1] = pixels [1]
            blank_image[i,j,2] = pixels [2]



cv.imshow("macka",blank_image)
cv.waitKey(0)
cv.destroyAllWindows


