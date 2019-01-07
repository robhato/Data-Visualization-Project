//Goal: Make 3 different visuals for data
//Data is about Overwatch heroes Pick Rate, Win Rate, and On Fire Rate

//colours in order for hero, 28 in total. Labelled 0-27 for ease.
//0.Reinhardt,1.Ana,2.Moira,3.D.VA,4.Zarya,5.Mercy,6.Genji,7.Brigitte,8.McCree,9.Zenyatta,10.Hanzo,11.Lucio,12.Winston,13.Widowmaker,14.Doomfist,15.Phara,16.Junkrat,17.Roadhog,18.Tracer,19.Reaper,20.Soilder:76,21.Orisa,22.Wreckingball,23.Sombra,24.Mei,25.Symmetra,26.Bastion,27.Torbjorn 
color[] Heroes = {#929DA3, #718AB3, #803C51, #ED93C7, #E77EB6, #EBE8BB, #97EF43, #BE736E, #AE595C, #EDE582, #B9B48A, #85C952, #A2A6BF, #9E6AA8, #815049, #3E7DCA, #ECBD53, #B68C52,#D79342,#7D3E51,#697794,#468C43,#DE8E34,#7359BA,#6FACED,#8EBCCC,#7C8F7B,#C0726E};
color[] Palette = Heroes;
 
String[] heroName;
float[] pickRate;
float[] winRate;
float[] onFire;
String[] abvName;
PFont fontName;

PImage bg;

char keychar = '1';

//sets up key switching
void keyPressed() {
  keychar = key;
}

void setup() {
  //stage size
  bg = loadImage("overwatch.jpg");
  background(bg);
  size(800,500);
  fontName = loadFont("TimesNewRomanPS-BoldMT-48.vlw");
  smooth();
  
  //Reads Text file
  String[] heroInfo = loadStrings("Data.txt");
  
  //How long is data set
  heroName = new String[heroInfo.length];
  pickRate = new float[heroInfo.length];
  winRate = new float[heroInfo.length];
  onFire = new float[heroInfo.length];
  abvName = new String[heroInfo.length];
  
  //parsing data
  for(int i = 0; i<heroInfo.length; i++) {
    String[] selector = split(heroInfo[i], ",");
    
    //setting arrays to actual value
    heroName[i] = (selector[0]);
    pickRate[i] = float(selector[1]);
    winRate[i] = float(selector[2]);
    onFire[i] = float(selector[3]);
    abvName[i] = (selector[4]);
    
  }
}


void draw() {
  switch(keychar){
    case '1':
      barGraph(pickRate);
      break;
    case '2':
      lineGraph(winRate);
      break;
    case '3':
      scatterPlot(onFire);
      break;
  }
}

//Bargraph for Hero Pick Rate
void barGraph(float[] pr){
  background(bg);
  rectMode(CORNER);
  int w = 20; // width of bar
  float x = width*0.1; // Horizontal starting point of the bars 
  float y = height*0.9; // Vertical starting point of the bars
  int space = 25; // Space between bars
  int lb = 80;
  int bb = 50;
  for (int i = 0; i < pr.length; i++) {
    // Mapping height to fit graph
    float h = map(pr[i], 0, max(pr)+10, 0, height);
    // sets the color of each bar to their color code
    float colour = map(i, 0, pr.length, 0, 255);
    fill(Palette[i]);
    noStroke();
    rect(x, y-h, w, h);
    x = x + space;
  
   
  // Gives info of hero if the mouse is hovered over them 
  if((mouseX > (x-(w/2)) && (mouseX < (x+(w/2)) && (mouseY > (y-h/2)-(h/2)) && (mouseY < ((y-h/2)+w/2))))){
    textFont(fontName);
    textAlign(CENTER);
    textSize(15);
    fill(255);
    text(heroName[i] + ": " + pickRate[i] + "%",x,480);
  } 
  
  // Puts hero name abreviation under the bars
  fill(255);
  textAlign(CENTER);
  textFont(fontName);
  textSize(12);
  text(abvName[i],x-15,y+12);
  
  // Y axis of graph
  fill(255);
  for(int j = 0; j < 17; j++) {
    int vert = height - bb - j*24;
    stroke(255);
    line(lb-10,vert,lb-15,vert);
    textFont(fontName);
    textAlign(RIGHT, CENTER);
    textSize(12);
    text(j, lb-30, vert);
  }
  
  }
  
  //title of bar graph
  fill(255);
  textAlign(CENTER);
  textFont(fontName);
  textSize(30);
  text("Overwatch Hero Pick Rate", width/2, 40);
  
  //Hero Names
  fill(255);
  textAlign(CENTER);
  textFont(fontName);
  textSize(15);
  text("Hero Name", width/2, 490);
  
  //Pick Rate Percentage
  fill(255);
  textAlign(CENTER);
  textFont(fontName);
  textSize(15);
  pushMatrix();
  translate(x,y);
  rotate(HALF_PI);
  text("Pick Rate Percentage", -220,760);
  popMatrix();
  
}

void lineGraph(float[] wr) {
  background(bg);
  // Stage set up for line graph
  int leftSide = 100;
  int topSide = 100;
  int rightSide = width - 50;
  int bottomSide = height - 100;
  rectMode(CORNERS);
  noStroke();
  fill(40);
  rect(leftSide, topSide, rightSide, bottomSide);
  
  // set up abbreviations for names and vertical lines
  fill(255);
  textFont(fontName);
  textAlign(CENTER);
  for(int i=0; i<wr.length;i++) {
    float hNameP = map(i, 0, wr.length, leftSide+22, rightSide);
    stroke(Palette[i]);
    textSize(10);
    text(abvName[i],hNameP,bottomSide+15);
    line(hNameP, bottomSide, hNameP, topSide);
  }
  
  // Hero Name title
  fill(255);
  textAlign(CENTER);
  textFont(fontName);
  textSize(15);
  text("Hero Name", width/2, 450);
  
  // Plot points of win rate
  stroke(255);
  float xCent=0;
  float yCent=0;
  beginShape();
  for(int i=0; i < wr.length; i++) {
    xCent = map(i,0,wr.length,leftSide+22, rightSide);
    yCent = map(winRate[i],min(winRate),max(winRate),bottomSide, topSide);
    vertex(xCent,yCent);
    fill(Palette[i]);
    ellipse(xCent,yCent,4,4);
    if(dist(xCent,yCent,mouseX,mouseY) < 10) {
      fill(255);
      textAlign(CENTER);
      textFont(fontName);
      textSize(20);
      text(heroName[i] + ": " + winRate[i] + "%",xCent,yCent-10);
    }
  }
  noFill();
  endShape();
  
  //Y-axis of graph
  fill(255);
  textFont(fontName);
  textAlign(RIGHT,CENTER);
  textSize(12);
  for(float i = 47; i < 57; i++) {
    float wRateP = map(i, 47, 56, bottomSide, topSide);
    line(leftSide, wRateP, leftSide-5, wRateP);
    text(i, leftSide-10, wRateP);
  }
  
  //Y-axis Name
  //Pick Rate Percentage
  fill(255);
  textAlign(CENTER);
  textFont(fontName);
  textSize(15);
  pushMatrix();
  rotate(HALF_PI);
  text("Win Rate Percentage", height/2,-40);
  popMatrix();
  
  //title of bar graph
    fill(255);
    textAlign(CENTER);
    textFont(fontName);
    textSize(30);
    text("Overwatch Hero Win Rate Percentage", width/2, 40);
}

//Scatter plot for on fire rate
void scatterPlot(float[] of) {
  background(bg);
  // Stage set up for line graph
  int leftSide = 100;
  int topSide = 100;
  int rightSide = width - 50;
  int bottomSide = height - 100;
  rectMode(CORNERS);
  noStroke();
  fill(40);
  rect(leftSide, topSide, rightSide, bottomSide);
  
  // set up abbreviations for names and vertical lines
  fill(255);
  textFont(fontName);
  textAlign(CENTER);
  for(int i=0; i<of.length;i++) {
    float hNameP = map(i, 0, of.length, leftSide+22, rightSide);
    stroke(Palette[i]);
    textSize(10);
    text(abvName[i],hNameP,bottomSide+15);
  }
  
  // Hero Name title
  fill(255);
  textAlign(CENTER);
  textFont(fontName);
  textSize(15);
  text("Hero Name", width/2, 450);
  
  // Plot points of on fire percentage
  float xCent=0;
  float yCent=0;
  beginShape();
  for(int i=0; i < of.length; i++) {
    xCent = map(i,0,of.length,leftSide+22, rightSide);
    yCent = map(onFire[i],min(onFire),max(onFire),bottomSide, topSide);
    fill(Palette[i]);
    ellipse(xCent,yCent,4,4);
    if(dist(xCent,yCent,mouseX,mouseY) < 10) {
      fill(255);
      textAlign(CENTER);
      textFont(fontName);
      textSize(20);
      text(heroName[i] + ": " + onFire[i] + "%",xCent,yCent-10);
    }
  }
  noFill();
  endShape();
  
  //Y-axis of graph
  fill(255);
  textFont(fontName);
  textAlign(RIGHT,CENTER);
  textSize(12);
  for(float i = 1; i < 17; i++) {
    float wRateP = map(i, 1, 16, bottomSide, topSide);
    line(leftSide, wRateP, leftSide-5, wRateP);
    text(i, leftSide-10, wRateP);
  }
  
  //Y-axis Name
  //Pick Rate Percentage
  fill(255);
  textAlign(CENTER);
  textFont(fontName);
  textSize(15);
  pushMatrix();
  rotate(HALF_PI);
  text("On Fire Percentage", height/2,-40);
  popMatrix();
  
  //title of bar graph
    fill(255);
    textAlign(CENTER);
    textFont(fontName);
    textSize(30);
    text("Overwatch Hero On Fire Percentage", width/2, 40);
}
