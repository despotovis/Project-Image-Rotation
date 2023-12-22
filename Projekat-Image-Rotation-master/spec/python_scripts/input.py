import cv2 as cv
import numpy
import sys
#Primer poziva:python3 input.py ~/Desktop/Projekat/github/Projekat-Image-Rotation/data/macka.jpg ~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Dimenzije.txt ~/Desktop/Projekat/github/Projekat-Image-Rotation/data/Input.txt

# Argument 1 slika Argument 2 tekstulni fajl u koji ce se upisati dimenzije Argument 3 Upisati vrednosti pixela u fajl

if len(sys.argv) != 4:
        print("Sript was not called properly!")
        exit()
              
img=cv.imread(sys.argv[1])
cv.imshow('cat',img)
height = img.shape[0]
width = img.shape[1]
file = open (sys.argv[2] , "w")
file.write (str(height) + ' ' + str(width) )
file.close()  
file = open (sys.argv[3] , "w")

for i in range (0,height):
	for j in range (0,width):
	
		array1 =img[i,j,0]
		array2 =img[i,j,1]
		array3 =img[i,j,2]
		content=str(array1);
		file.write(content + ' ')
		content=str(array2);
		file.write(content + ' ')
		content=str(array3);
		file.write(content + ' '+ '\n')
		
file.close()
cv.waitKey(0)
cv.destroyAllWindows
