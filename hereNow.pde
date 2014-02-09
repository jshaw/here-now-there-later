// Here Now There Later
// Installation 
// By Jordan Shaw

// Motion detection built off of Learning Processing example
// By Daniel Shiffman / http://www.learningprocessing.com
// Example 16-13:

import processing.video.*;
// Variable for capture device
Capture video;
// Previous Frame
PImage prevFrame;
PFont f;
// How different must a pixel be to be a "motion" pixel
float threshold = 50.0;
float pixel_changed = 0.0;
float allowed_percentage = 0.08;
float current_percentage = 0.0;
int motionDetected = 0;

// String to switch to
String[] location = {
  "HERE", 
  "THERE",
};

String[] time = {
  "NOW", 
  "LATER",
};

// Dynamic
//int f_width  = displayWidth;
//int f_height = displayHeight;

// larger
//int f_width  = 1280;
//int f_height = 960;

// medium
int f_width  = 640;
int f_height = 480;

// smaller
//int f_width  = 320;
//int f_height = 240;

float num_of_pixels = f_width * f_height; 

void setup() {
  size(f_width,f_height);
  
  f = createFont("Helvetica-Bold",30,true);
  
  video = new Capture(this, width, height, 30);
  // Create an empty image the same size as the video
  prevFrame = createImage(video.width,video.height,RGB);
  
  if (frame != null) {
    frame.setResizable(true);
  }
  
  textFont(f,100);
  // Specify font color
  fill(0);
  
  textAlign(CENTER, CENTER);
  
  video.start();
}

void draw() {   
  // Capture video
  if (video.available()) {
    // Save previous frame for motion detection!!
    prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height); // Before we read the new frame, we always save the previous frame for comparison!
    prevFrame.updatePixels();
    video.read();
  }
  
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      
      int loc = x + y*video.width;            // Step 1, what is the 1D pixel location
      
      color current = video.pixels[loc];      // Step 2, what is the current color
      color previous = prevFrame.pixels[loc]; // Step 3, what is the previous color
      
      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); float g1 = green(current); float b1 = blue(current);
      float r2 = red(previous); float g2 = green(previous); float b2 = blue(previous);
      float diff = dist(r1,g1,b1,r2,g2,b2);
      
      // Step 5, How different are the colors?
      // If the color at that pixel has changed, then there is motion at that pixel.
      if (diff > threshold) { 
        // If motion, display black
        pixels[loc] = color(0);
        
         motionDetected = 1;
         pixel_changed += 1.0;
        
      } else {
        // If not, display white
        pixels[loc] = color(255);
      }
    }
  }
  
  updatePixels();
  //  Update output
  updateText();
  
  // Resets motion tracked for next frame 
  motionDetected = 0;
  // Resets changed pixels for next frame 
  pixel_changed = 0.0;
}

void updateText(){
  
  // Make sure that we don't get the percentage of 0, throws error  
  if (pixel_changed > float(0)){
    current_percentage = getPercentage();
    
    // Displays "There"
    if (current_percentage > allowed_percentage){
      text(location[1], f_width/2, f_height/2); 
    } else {
      // Displays "Here"
      text(location[0], f_width/2, f_height/2);
    }
  } else {
    // If no pixels change, means no movement, display "Here" 
    text(location[0], f_width/2, f_height/2);
  }
}

float getPercentage(){
    return (pixel_changed / num_of_pixels) * 100;
}

