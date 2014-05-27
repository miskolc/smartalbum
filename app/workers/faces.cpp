#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
#include <stdio.h>
#include <unistd.h>
using namespace std;
using namespace cv;
char buf[4096];
extern "C" char* detect_faces(char* input_file, char* output_file);
 
int main(int argc, char** argv) {
  if(argc<2){
    fprintf(stderr, "usage:n%s <image>n%s <image> <outimg>n", argv[0], argv[0]);
    exit(-1);
  }
  //fprintf(stderr, "usage:n%s <image>n%s <image> <outimg>n", argv[0], argv[0]);
  
  printf("%s", detect_faces(argv[1], argc<3 ? NULL : argv[2]));
  exit(0);
}

vector<Rect> selectFaces(vector<Rect> faces) {
  double medie = 0;
  for(unsigned int i = 0; i < faces.size(); i++){
    Rect f = faces[i];
    medie += f.width*f.height;
  }
  medie = medie / faces.size();
  //sprintf(buf + strlen(buf), "%i\n", (int)medie);
  vector<Rect> newfaces;
  for(unsigned int i = 0; i < faces.size(); i++){
    Rect f = faces[i];
    //sprintf(buf + strlen(buf), "%i %i\n", (int)medie, (int)(f.width*f.height));
    if(((f.width*f.height) > medie/2) && ((f.width*f.height) < medie*2)) {
      newfaces.push_back(f); 
      //sprintf(buf + strlen(buf), "%i\n", (int)(f.width*f.height));
    }
    
  }
  
  //sprintf(buf + strlen(buf), "%i\n", (int)newfaces.size());

  return newfaces;
}
 
char* detect_faces(char* input_file, char* output_file) {
  //fprintf(stderr, "usage: %s  %s \n", input_file, output_file);
  buf[0] = '\0';
  CascadeClassifier cascade;

  if(!cascade.load("/home/dragos/Programming/rails/spring-races/smartalbum/app/workers/lbpcascade_frontalface.xml")) exit(-2); //load classifier cascade
  //fprintf(stderr, "usage: %s  %s \n", input_file, output_file);

  Mat imgbw, image = imread((string)input_file); //read image
  //fprintf(stderr, "Citeste img: %s  %s \n", input_file, output_file);
  if(image.empty()) exit(-3);
  //fprintf(stderr, "Nu e goala: %s  %s \n", input_file, output_file);
  cvtColor(image, imgbw, CV_BGR2GRAY); //create a grayscale copy
  equalizeHist(imgbw, imgbw); //apply histogram equalization
  vector<Rect> faces;
  cascade.detectMultiScale(imgbw, faces, 1.2, 2); //detect faces
  double medie = 0;
  for(unsigned int i = 0; i < faces.size(); i++){
    Rect f = faces[i];
    medie += f.width*f.height;
  }
  medie = medie / faces.size();
  vector<Rect> newfaces;
  for(unsigned int i = 0; i < faces.size(); i++){
    Rect f = faces[i];
    if(((f.width*f.height) > medie/4) && ((f.width*f.height) < medie*4))
	newfaces.push_back(f); 
  }
  faces = selectFaces(newfaces) ;
  for(unsigned int i = 0; i < faces.size(); i++){
    Rect f = faces[i];
    //draw rectangles on the image where faces were detected
    rectangle(image, Point(f.x, f.y), Point(f.x + f.width, f.y + f.height), Scalar(255, 0, 0), 4, 8);
    //fill buffer with easy to parse face representation
    sprintf(buf + strlen(buf), "%i;%i;%i;%in", f.x, f.y, f.width, f.height);
  }
  if(output_file) imwrite((string)output_file, image); //write output image
  return buf;
}
