import deadpixel.keystone.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Keystone ks;
CornerPinSurface surface;
PShape drone;
PShape space;
PShape plane;

PFont font;
String[] headlines={
  "President Expands Missle Strikes in Territory", 
  "Foriegn Powers Meet Over Missle Strike Sanctions", 
  "President Rethinks Antimissle Plan", 
  "President Launches Missles into Territory", 
};
String message="";
int k=0;
int hline=0;
int rows=8;
int cols=8;
int w;
int select=0;
int weapon=1;
int [] squares = new int[cols*rows]; //0=uncaptured 1=captured
PGraphics os;
int channel = 0;
int count=11;
int cap=0;
int mil=0;
void reset() {
  java.util.Arrays.fill(squares, 0);
  squares[63]=1;
  val1=-10;
  val2=-10;
  val3=-550;
  j=0;
  h=h1;
  message="";
  k=0;
  hline=0;
  select=0;
  weapon=1;
  cap=0;
}
void endStart() {
  //handshake for start or end of game.
  //p im booting. putting up loading screen
  //u ok. bc ur booting, i start ani. at end of ani, i start
  //p ok. im starting too.
  //end game screen
  //p gg. i put up ending screen. back to start: i'm booting
  //u gg. starting ending animation. at end of ani. i reply to booting
}
void setup() {
  //fullScreen(P3D);
  size(1080, 1080, P3D);
  frameRate(80);

  background(0);

  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(height, height, 20);
  os = createGraphics(height, height, P3D);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12001);
  /* send messages to this ip address and port*/
  myRemoteLocation = new NetAddress("127.0.0.1", 12002);
  drone=loadShape("drone.svg");
  plane=loadShape("plane.svg");
  space=loadShape("space.svg");
  w=height/8/2;
  for (int i=0; i<squares.length; i++) {
    squares[i]=0;
  }
  squares[63]=1;
  font = createFont("AHAMONO-Regular", 24);
}

void draw() {
  frame.setTitle(mouseX+":"+mouseY);

  if (millis()-mil>1000) {
    count++;
    mil=millis();
  }
  PVector surfaceMouse = surface.getTransformedMouse();
  os.beginDraw();
  os.background(0);

  os.pushMatrix();
  os.translate(20, 20);
  interfaceGrid();
  if (cap==64) {
    reset();
  }
  news();
  graphs();
  // motionBlur();
  os.popMatrix();

  scanLine();
  os.endDraw();
  background(0);
  surface.render(os);

  cap=0;
}
int j = 0;
int h1=20;
int h=h1;
void scanLine() {
  j++;
  if (j+h>height) {
    h--;
  } 
  if (h<2) {
    j=0;
    h=h1;
  }
  for (int x=0; x<height; x++) {
    os.set(x, j, os.get(x+3, j));
    os.set(x, j+2, os.get(x+3, j+2));
    os.set(x, j+3, os.get(x+3, j+3));
    os.set(x, j+4, os.get(x+3, j+4));
    os.set(x, j+5, os.get(x+3, j+3));
    os.set(x, j+6, os.get(x+3, j+2));
    os.set(x, j+7, os.get(x+3, j+3));
    os.set(x, j+8, os.get(x+3, j+4));
    os.set(x, j+9, os.get(x+3, j+3));
    os.set(x, j+10, os.get(x+3, j+2));
    os.set(x, j+11, os.get(x+3, j));
    os.set(x, j+12, os.get(x+3, j+2));
    os.set(x, j+13, os.get(x+3, j+3));
    os.set(x, j+14, os.get(x+3, j+4));
    os.set(x, j+15, os.get(x+3, j+3));
    os.set(x, j+16, os.get(x+3, j+2));
    os.set(x, j+17, os.get(x+3, j+3));
    os.set(x, j+18, os.get(x+3, j+4));
    os.set(x, j+19, os.get(x+3, j+3));
  }
}

void news() {
  char c= char(int(random(65, 90)));
  os.textFont(font, 24);
  os.fill(255);
  if (k!=message.length()) {
    if (k<message.length()) {
      k++;
    }
    os.text(message.substring(0, k)+c, 0, 600, 500, 300);
  } else {
    os.text(message, 0, 600, 500, 300);
  }
}
int val1=-10;
int val2=-10;
int val3=-550;
float n = 0.0;
float theta=0.1;
void graphs() {
  int zoomX=height-500;
  n = n + .01;
  float x = noise(n) * 150;
  float y =  noise(n+50) * 150;
  os.noFill();
  os.rect(zoomX, 220, 150-1, 150-1);
  os.rect(zoomX, 220, x, y);
  os.rect(x-8+zoomX, y-8+220, 16, 16);
  os.rect(x+zoomX, y+220, 150-x-1, 150-y-1);

  os.noFill();
  os.ellipse(w*8+120, 100, 180, 180);
  os.noStroke();
  os.fill(255);
  os.arc(w*8+120, 100, 180, 180, 0, (cap/64.0)*2*PI, PIE);

  os.stroke(255);
  os.fill(255);
  os.rect(height-100, 560, 28, val2);
  os.rect(height-135, 560, 28, val1);

  if (val3>=-550+500) {
    if (val3>0) {
      os.fill(0);
    }
    theta+=0.1;
    os.stroke(255, 0, 0, cos(theta)*50+150);
  } 
  os.rect(height-65, 560, 28, val3);
  //os.rect(height-305, 560, 60, val3*3);
  os.fill(0);
  os.stroke(0);
  //COULD OPTIMIZE. SPACE VERTICALLY ONE TRANSLATE, ONE ROTATION
  os.pushMatrix();
  os.fill(255);
  os.translate(height-65+23, 655);
  os.rotate(-.5*PI);
  os.text("BUDGET", 0, 0);
  os.popMatrix();
  os.pushMatrix();
  os.fill(255);
  os.translate(height-100+23, 655);
  os.rotate(-.5*PI);
  os.text("PROFIT", 0, 0);
  os.popMatrix();
  os.pushMatrix();
  os.fill(255);
  os.translate(height-135+23, 655);
  os.rotate(-.5*PI);
  os.text("DEATHS", 0, 0);
  os.popMatrix();
  os.text("CAPTURED\nTERRITORY", 745, 120);
}

void motionBlur() {
  os.noStroke();
  os.fill(0, 30); // semi-transparent white
  os.rect(0, 0, height, height);
}

void interfaceGrid() {
  os.strokeWeight(4);
  os.stroke(255);
  for (int x=0; x< cols; x++) {
    for (int y=0; y< rows; y++) {
      if (squares[(y*cols)+x]==1) {
        os.fill(225);
        cap++;
      } else {
        os.fill(0, 0);
      }
      os.rect(x*w, y*w, w, w);
    }
  }

  os.fill(225, 0, 0, 100);
  os.rect((select%cols)*w, (select/cols)*w, w, w);
  os.fill(255);
  os.rect(0, 750, 150, 150);
  os.shape(drone,0, 750, 150, 150);
  os.rect(200, 750, 150, 150);
  os.rect(400, 750, 143, 143);
  switch(weapon) {
  case 1:
    break;
  case 2:
    if (select%cols!=0) {
      os.rect(((select%cols)-1)*w, ((select/cols))*w, w, w); //-x
    }
    if (select%cols!=cols-1) { 
      os.rect(((select%cols)+1)*w, ((select/cols))*w, w, w); //+x
    }
    break;
  case 3: //plus
    if (select/cols!=0) {
      os.rect((select%cols)*w, ((select/cols)-1)*w, w, w); //-y
    }
    if (select%cols!=0) {
      os.rect(((select%cols)-1)*w, ((select/cols))*w, w, w); //-x
    }
    if (select%cols!=cols-1) { 
      os.rect(((select%cols)+1)*w, ((select/cols))*w, w, w); //+x
    }
    if (select/cols!=rows-1) {
      os.rect((select%cols)*w, ((select/cols)+1)*w, w, w); //+y
    }
    break;
  }
}
void keyReleased() {
  if (key=='p') {
    reset();
  }
}
void keyPressed() {
  if (keyCode == ENTER) {
    OscMessage myMessage = new OscMessage("/strike");
    switch(weapon) {
    case 1:
      if (count>3) {
        squares[select]=1;
        myMessage.add( select);
        count=0;
        val3+=5;
        val1-=1;
        val2-=2;
        k=0;
        message=headlines[hline%headlines.length];
        hline++;
      }
      break;
    case 2:
      if (count>7) {
        k=0;
        message=headlines[hline%headlines.length];
        hline++;
        squares[select]=1;
        myMessage.add( select);
        if (select%cols!=0) {
          squares[select-1]=1;
          myMessage.add( select-1); // Send a controllerChange
        } else {
        }
        if (select%cols!=cols-1) { 
          squares[select+1]=1;
          myMessage.add( select+1); // Send a controllerChange
        } else {
        }
        count=0;
        val3+=50;
        val1-=3;
        val2-=10;
      }
      break;
    case 3:
      if (count>10) {
        k=0;
        message=headlines[hline%headlines.length];
        hline++;
        squares[select]=1;
        myMessage.add( select);
        if (select/cols!=0) {
          squares[select-8]=1;
          myMessage.add( select-8); // Send a controllerChange
        }
        if (select%cols!=0) {
          squares[select-1]=1;
          myMessage.add( select-1); // Send a controllerChange
        }
        if (select%cols!=cols-1) { 
          squares[select+1]=1;
          myMessage.add( select+1); // Send a controllerChange
        }
        if (select/cols!=rows-1) {
          squares[select+8]=1;
          myMessage.add( select+8); // Send a controllerChange
        }
        count=0;
        val3+=200;
        val1-=4;
        val2-=40;
      }
      break;
    }
    oscP5.send(myMessage, myRemoteLocation);
  }
  if (key=='1') {
    weapon=1;
  }
  if (key=='2') {
    weapon=2;
  }
  if (key=='3') {
    weapon=3;
  }
  if (key=='s') {
    if (select/cols!=rows-1) {
      select+=cols;
    }
  }
  if (key=='w') {
    if (select/cols!=0) {
      select-=cols;
    }
  }
  if (key=='a') {
    if (select%cols!=0) {
      select--;
    }
  }
  if (key=='d') {
    if (select%cols!=cols-1) {
      select++;
    }
  }
  if (key=='x') {
    ks.toggleCalibration();
  }
  if (key=='z') {
    count=11;
  }
}
void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  if (theOscMessage.checkAddrPattern("/capture")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("i")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      squares[theOscMessage.get(0).intValue()]=0;  // get the first osc argument
      return;
    } else {
      return;
    }
  }
  println("### received an osc message. with address pattern "+
    theOscMessage.addrPattern()+" typetag "+ theOscMessage.typetag());
}