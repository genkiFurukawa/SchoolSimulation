// reference
// http://skzy.hatenablog.com/entry/2014/06/25/023114
// http://neareal.net/index.php?ComputerGraphics%2FUnity%2FTips%2FBoids%20Model
// https://qiita.com/takashi/items/9d684a6e3742a15e8726
// https://www.1101.com/morikawa/2001-06-25.html
//
public class Cnst{
  public static final int fish_number = 25;
  //
  public static final float vision = 200;
  public static final float distance = 60;
  //
  public static final int x_width = 400;
  public static final int y_width = 400;
  //
  public static final int start_x = 25;
  public static final int end_x = 425;
  public static final int start_y = 25;
  public static final int end_y = 425;
}
//Boid model 3 rules
// 1.Separation
// 2.Alignment
// 3.Cohesion
class Fish{
  private float x;
  private float y;
  private float dx;
  private float dy;
  private ArrayList<Fish> neighbors;
  //
  public Fish(float _x, float _y, float _dx, float _dy){
    this.x = _x;
    this.y = _y;
    this.dx = _dx;
    this.dy = _dy;
    this.neighbors = new ArrayList<Fish>();
  }
  //
  public float get_x(){
    return this.x;
  }
  public float get_y(){
    return this.y;
  }
  public float get_dx(){
    return this.dx;
  }
  public float get_dy(){
    return this.dy;
  }
  //
  public void set_neighbors(Fish _fish){
    this.neighbors.add(_fish);
  }
  //
  public void initialize_neighbors(){
    this.neighbors = new ArrayList<Fish>();
  }
  //
  public void show(){
    ellipse(this.x, this.y, 15, 15);
    float rad = atan2(dy, dx);
    line(this.x, this.y, this.x + 7.5*cos(rad), this.y + 7.5*sin(rad));
  }
  // Cohesion
  private float[] get_cohesion_v(){
    float cx = 0;
    float cy = 0;
    for(int i = 0; i < this.neighbors.size(); i++){
      cx += this.neighbors.get(i).get_x();
      cy += this.neighbors.get(i).get_y();
    }
    if(this.neighbors.size() != 0){
      cx = cx / this.neighbors.size();
      cy = cy / this.neighbors.size();
    }
    float[] cohesion_v = new float[2];
    cohesion_v[0] = cx - this.x;
    cohesion_v[1] = cy - this.y;
    return cohesion_v;
  }
  // Alignment
  private float[] get_alignment_v(){
    float ax = 0;
    float ay = 0;
    for(int i = 0; i < this.neighbors.size(); i++){
      ax += this.neighbors.get(i).get_dx();
      ay += this.neighbors.get(i).get_dy();
    }
     if(this.neighbors.size() != 0){
      ax = ax / this.neighbors.size();
      ay = ay / this.neighbors.size();
    }
    float[] alignment_v = new float[2];
    alignment_v[0] = (ax - this.dx)/2;
    alignment_v[1] = (ay - this.dy)/2;
    return alignment_v;
  }
  // Separation
  private float[] get_separation_v(){
    float sx = 0;
    float sy = 0;
    float d;
    float flg_d = Cnst.distance;    
    for(int i = 0; i < this.neighbors.size(); i++){
      d = dist(this.x, this.y, neighbors.get(i).get_x(), neighbors.get(i).get_y());
      if(d < Cnst.distance && d < flg_d){
        sx = -(neighbors.get(i).get_x() - this.x);
        sy = -(neighbors.get(i).get_y() - this.y);
        flg_d = d;
      }
    }    
    float[] separation_v = new float[2];
    separation_v[0] = sx;
    separation_v[1] = sy;
    return separation_v;
  }
  //
  public void eval(){
    float[] cohesion_v = get_cohesion_v();
    float[] alignment_v = get_alignment_v();
    float[] separation_v = get_separation_v();
    //
    float next_dx = cohesion_v[0]/100 + alignment_v[0] + separation_v[0]/25;
    float next_dy = cohesion_v[1]/100 + alignment_v[1] + separation_v[1]/25;
    this.dx += next_dx;
    this.dy += next_dy;
    //
    if(sqrt(this.dx*this.dx+this.dy*this.dy) > 7.5){
      //println("#");
      this.dx = (this.dx / sqrt(this.dx*this.dx+this.dy*this.dy))*7.5;
      this.dy = (this.dy / sqrt(this.dx*this.dx+this.dy*this.dy))*7.5;
    }
    float next_x = this.x + this.dx;
    float next_y = this.y + this.dy;
    //
    if(next_x - 7.5 <= Cnst.start_x){
      next_x = Cnst.start_x + abs(next_x - Cnst.start_x) + 7.5;
      //next_dx = - next_dx; 
      this.dx = - this.dx;
    }
    if(next_x + 7.5 >= Cnst.end_x){
      next_x = Cnst.end_x - abs(next_x - Cnst.end_x) - 7.5;
      //next_dx = - next_dx;
      this.dx = - this.dx;
    }
    if(next_y - 7.5 <= Cnst.start_y){
      next_y = Cnst.start_y + abs(next_y - Cnst.start_y) + 7.5;
      //next_dy = - next_dy;
      this.dy = -this.dy;
    }
    if(next_y + 7.5 >= Cnst.end_x){
      next_y = Cnst.end_x - abs(next_y - Cnst.end_x) - 7.5;
      //next_dy = - next_dy;
      this.dy = -this.dy;
    }
    //
    this.x = next_x;
    this.y = next_y;
    //this.dx = next_dx;
    //this.dy = next_dy;
  }
}
//
class School{
  private ArrayList<Fish> fishes = new ArrayList<Fish>();
  //
  public School(int fish_number){
    for(int i = 0; i < fish_number; i++){
      float x = random(Cnst.start_x, Cnst.start_x + 200);
      float y = random(Cnst.start_y, Cnst.start_y + 200);
      fishes.add(new Fish(x, y, random(-6, 6), random(-6, 6)));
    }
    println(fishes.size());
  }
  //
  public ArrayList<Fish> get_fishes(){
    return this.fishes;
  }
  //
  public void eval(){
    for(int i = 0; i < fishes.size(); i++){
      fishes.get(i).eval();
    }  
  }
  //
  public void search_neighbors(){
    // all initialize
    for(int i = 0; i < Cnst.fish_number; i++){
      fishes.get(i).initialize_neighbors();
    }
    for(int i = 0; i < Cnst.fish_number; i++){
      for(int j = i+1; j < Cnst.fish_number; j++){
        float d = dist(fishes.get(i).get_x(), fishes.get(i).get_y(),
                       fishes.get(j).get_x(), fishes.get(j).get_y());
        if(d < Cnst.vision){
           fishes.get(i).set_neighbors(fishes.get(j));
           fishes.get(j).set_neighbors(fishes.get(i));
        }
      }
    }
  }
  //
  public void draw_fishes(){
    for(int i = 0; i < fishes.size(); i++){
      fishes.get(i).show();
    }   
  }
}
//
School school;
//
void setup(){
  frameRate(15);
  background(255);
  size(450, 450);
  school = new School(Cnst.fish_number);
}

void draw(){
  background(255);
  rect(Cnst.start_x, Cnst.start_y, Cnst.x_width, Cnst.y_width);
  school.draw_fishes();
  school.search_neighbors();
  school.eval();
}
