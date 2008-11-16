String[] reports;
PImage map;
int i;
int[] lastPoint;

// Setup Basemap
void setup()
{
  PFont fontA;
  
  size(1029,550);
  smooth();

  reports = loadStrings("reports.csv");

  map = loadImage("basemap.jpg");
  frameRate(30);
  tint(10,220,10);
  image(map,0,0);

  // Set the font and its size (in units of pixels)
  fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  textFont(fontA, 32);

  i=0;
  lastPoint = null;
}

int[] xlate(String lat, String lon) {
  int x,y;
  
  y = int(((53-float(lat))/30) * 550);
  x = int(((128+float(lon))/70) * 1029);
  int[] xy = {x,y};
  return xy;
}

void draw()
{
  int[] currentPoint;
  
  if (i<reports.length) {
    String[] row = split(reports[i], '|');
    currentPoint = xlate(row[0], row[1]);
    if (lastPoint!=null)
      new Stitch(lastPoint, currentPoint);
    lastPoint = currentPoint;

    fill(255);
    text(row[2], 550, 50);
    i++;
  }
}


class Stitch {
  Stitch(int[] start, int[] finish) {
    stroke(80,80);
    strokeWeight(1);
    line(start[0],start[1], finish[0], finish[1]);
  }
}
