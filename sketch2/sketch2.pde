Point[] points;
HLine[] lines;
float center, unit;// 中心座標、単位長
Point cursor;
float px1,py1;
float px2,py2;
float px3,py3;
float px,py,qx,qy;
float nx,ny,nr; //三点を通る円の中心点と半径
float bb; //三点を通る円の中心点を求める公式の分母
float ax,ay;
float bx,by;
float p,q,m,n,t,c,d,r;

class Point {
  PVector pos;
  String name;
  Point(float _x, float _y) {
    pos = new PVector(_x, _y);
  }
  Point(Point p) {
    pos = new PVector(p.pos.x, p.pos.y);
  }
  void drawPoint(int size) {
    float d=pos.mag();
    if (d<1f)
      fill(0, 0, 255);
    else 
      fill(128, 128, 255);
    noStroke();
    ellipse(center+unit*pos.x, center+unit*pos.y, size, size);
  }
}

class HLine {
  float a,b,c,d;
}

void setup() {
  size(1000, 1000);
  center=width*0.5f;
  unit=width*0.45f;
  points = new Point[2];
  points[0]=new Point(0.5,0.5);
  points[1]=new Point(-0.5,-0.5);
}

void draw() {
  background(128);
  fill(255);
  noStroke();
  ellipse(center, center, unit*2f, unit*2f);// 原点中心、半径１の円
  
  ////////////dragging
  if (cursor != null){
    cursor.pos.x = (mouseX-center)/unit;
    cursor.pos.y = (mouseY-center)/unit;
  }
  
  ////////////draw points
  for (int i=0; i<points.length; i++){
    points[i].drawPoint(10);
  }
  
  //draw Vertical bisector
  stroke(0);
  noFill();
  strokeWeight(1);
  ax=points[0].pos.x;
  ay=points[0].pos.y;
  bx=points[1].pos.x;
  by=points[1].pos.y;
  
  //ellipse(center+unit*ax,center+unit*ay,2*unit*dist(ax,ay,bx,by),2*unit*dist(ax,ay,bx,by));
  //ellipse(center+unit*bx,center+unit*by,2*unit*dist(ax,ay,bx,by),2*unit*dist(ax,ay,bx,by));
  
  p=bx-ax;
  q=by-ay;
  m=bx+ax;
  n=by+ay;
  t=p/q;
  c=(p*m+q*n)/(2*q);
  d=c-ay;
  r=dist(ax,ay,bx,by);
  px=(ax+t*d+sqrt(2*t*d*ax+r*r-d*d-t*ax*t*ax+t*r*t*r))/(1+t*t);
  qx=(ax+t*d-sqrt(2*t*d*ax+r*r-d*d-t*ax*t*ax+t*r*t*r))/(1+t*t);
  py=c-t*px;
  qy=c-t*qx;
  
  //draw ellipse
  
  px1=px;
  py1=py;
  px2=px/(px*px+py*py);
  py2=py/(px*px+py*py);
  px3=qx;
  py3=qy;
  
  //ellipse(center+unit*px1,center+unit*py1,10,10);
  //ellipse(center+unit*px2,center+unit*py2,10,10);
  //ellipse(center+unit*px3,center+unit*py3,10,10);
  
  bb=2*(px1-px2)*(py1-py3)-2*(px1-px3)*(py1-py2);
  
  nx=(py1-py2)*(px3*px3-px1*px1+py3*py3-py1*py1)-(py1-py3)*(px2*px2-px1*px1+py2*py2-py1*py1);
  
  ny=(px1-px3)*(px2*px2-px1*px1+py2*py2-py1*py1)-(px1-px2)*(px3*px3-px1*px1+py3*py3-py1*py1);
  
  nx=nx/bb;
  ny=ny/bb;
  nr=dist(nx,ny,px,py);
  stroke(128);
  noFill();
  strokeWeight(10);
  ellipse(center+unit*nx,center+unit*ny,2*unit*nr,2*unit*nr);
  
}


void mousePressed(){
  cursor=null;
  for (int i=0; i<points.length; i++){
    if (mag(center+unit*points[i].pos.x-mouseX, center+unit*points[i].pos.y-mouseY)<10){
      cursor = points[i];
      break;
    }
  }
}

void mouseReleased(){
  cursor=null;
}
