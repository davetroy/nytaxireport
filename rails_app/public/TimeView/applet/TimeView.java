import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class TimeView extends PApplet {

String[] reports;
MapRing[] rings;
PImage map;
int i;
int avgx, avgy;

// Setup Basemap
public void setup()
{
  PFont fontA;
  
  size(1029,550);
  smooth();
  reports = loadStrings("reports.csv");
  rings = new MapRing[reports.length];

  map = loadImage("basemap.jpg");
  frameRate(50);
  tint(10,220,10);
  image(map,0,0);

  // Set the font and its size (in units of pixels)
  fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  textFont(fontA, 32);

  i=0;
}

public void draw()
{
  image(map,0,0);
  if (i<rings.length) {
    String[] coords = split(reports[i], '|');
    rings[i] = new MapRing(coords[0], coords[1], coords[3], coords[4]);
    rings[i].transmit();
    fill(255);
    text(coords[2], 550, 50);
    int start = i>50 ? i-50 : 0;
    for (int j=start; j<i; j++) {
     rings[j].transmit();
    }
    i++;
  } else {
    i = 0;
  }
  
  stroke(80,80);
  line(avgx,0,avgx,550);
  line(0,avgy,1029,avgy);
}

class MapRing
{
  Ring circle = new Ring();
  MapRing(String lat, String lon, String source, String wait_time) {
    float x,y;
    // 1029 x 550  771,254 = 39.024,-76.511
    y = ((53-PApplet.parseFloat(lat))/30) * 550;
    x = ((128+PApplet.parseFloat(lon))/70) * 1029;
    circle.start(x,y);

    avgx = (((avgx << 6) - avgx) + PApplet.parseInt(x)) >> 6;
    avgy = (((avgy << 6) - avgy) + PApplet.parseInt(y)) >> 6;
    avgx = avgx < 0 ? 0 : avgx;
    avgy = avgy < 0 ? 0 : avgy;
    
    if (source.equals("IPH"))
       circle.col = color(0,200,0);
    else if (source.equals("ADR"))
      circle.col = color(0,0,200);
    else if (source.equals("TWT"))
      circle.col = color(128,0,29);
    else if (source.equals("TEL"))
      circle.col = color(200,200,0);
    else if (source.equals("SMS"))
      circle.col = color(200,0,200);
    else
      circle.col = color(200,0,0);
      
     if (PApplet.parseFloat(wait_time)>0)
       circle.fillcol = color(255-PApplet.parseInt(wait_time),190);
     else
       circle.fillcol = color(255,255,255,0);

    circle.wait = wait_time;
      
  }
  public void transmit() {
    circle.grow();
    //circle.fade();
    circle.display();
//    if (circle.on == false) {
//      circle.on = true;
//    }
  }
}

class Ring {
  float x, y; // X-coordinate, y-coordinate
  float diameter; // Diameter of the ring
  int alpha;
  String wait;
  int col, fillcol;
  
  boolean on = false; // Turns the display on and off
  public void start(float xpos, float ypos) {
    x = xpos;
    y = ypos;
    on = true;
    diameter = 3;
    alpha = 255;
  }
  public void grow() {
    if (on == true) {
      diameter += 0.5f;
      if (diameter > 100) {
        alpha-=10;

        if (alpha <=0) {
          diameter = 0.0f;
          on = false;
        }
      }
    }
  }

  public void display() {
    if (on == true) {
      strokeWeight(4);
      stroke(col, alpha);
      fill(fillcol);
      ellipse(x, y, diameter, diameter);
      if (PApplet.parseFloat(wait)>0)
         text(wait, x-10, y);
    }
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "TimeView" });
  }
}
