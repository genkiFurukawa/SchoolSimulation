// reference
// http://skzy.hatenablog.com/entry/2014/06/25/023114
// http://neareal.net/index.php?ComputerGraphics%2FUnity%2FTips%2FBoids%20Model
// https://qiita.com/takashi/items/9d684a6e3742a15e8726
// https://www.1101.com/morikawa/2001-06-25.html
//
public class Cnst{
  public static final int fish_number = 10;
  //
  public static final float vision = 200;
  public static final float distance = 20;
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
// 1.Collision Avoidance
// 2.Velocity Matching
// 3.Flock Centering
class Fish{
  private float x;
  private float y;
  private float velocity;
  private float rad;
  private ArrayList<Fish> neighbors;
  //
  public Fish(float _x, float _y, float _velocity, float _rad){
    this.x = _x;
    this.y = _y;
    this.velocity = _velocity;
    this.rad = _rad;
    this.neighbors = new ArrayList<Fish>();
  }
  //
  public float get_x(){
    return this.x;
  }
  public float get_y(){
    return this.y;
  }
  public float get_velocity(){
    return this.velocity;
  }
  public float get_rad(){
    return this.rad;
  }
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
    line(this.x, this.y, this.x + 7.5*cos(this.rad), this.y + 7.5*sin(this.rad));
  }
  // calc flock Center
  private float get_center_rad(){
    float center;
    float sum_x = 0;
    float sum_y = 0;
    for(int i = 0; i < this.neighbors.size(); i++){
      sum_x += this.neighbors.get(i).get_x();
      sum_y += this.neighbors.get(i).get_y();
    }
    if(this.neighbors.size() == 0){
      return this.rad;
    }
    center = atan2((sum_y / this.neighbors.size()) - this.y,
                   (sum_x / this.neighbors.size()) - this.x);
    return center;
  }
  // calc neighbor rad
  private float get_neighbor_rad(){
    float ax = 0;
    float ay = 0;
    for(int i = 0; i < this.neighbors.size(); i++){
      ax += cos(this.neighbors.get(i).get_rad());
      ay += sin(this.neighbors.get(i).get_rad());
    }
    if(this.neighbors.size() == 0){
      return this.rad;
    }
    float da = atan2(ay, ax);
    return da;
  }
  //
  private float get_avoid_rad(){
    float da = this.rad;
    float d;
    float flg_d = Cnst.distance;
    for(int i = 0; i < this.neighbors.size(); i++){
      d = dist(this.x, this.y, neighbors.get(i).get_x(), neighbors.get(i).get_y());
      if(d < Cnst.distance && d < flg_d){
        da = atan2(neighbors.get(i).get_y() - this.y,
                   neighbors.get(i).get_x() - this.x) + PI;
        flg_d = d;
      }
    }    
    return da;
  }
  //
  private float get_avoid_velocity(){
    float v = this.velocity;
    float d;
    for(int i = 0; i < this.neighbors.size(); i++){
      d = dist(this.x, this.y, neighbors.get(i).get_x(), neighbors.get(i).get_y());
      if(d < Cnst.distance){
        v = v * random(0.5, 1);
        break;
      }
    }    
    return v;
  }
  //
  public void eval(){
    float center_rad = get_center_rad();
    float neighbor_rad = get_neighbor_rad();
    float avoid_rad = get_avoid_rad();
    float next_rad = atan2(sin(center_rad)+sin(neighbor_rad)+sin(avoid_rad),
                           cos(center_rad)+cos(neighbor_rad)+cos(avoid_rad));
    float v = get_avoid_velocity();                       
    float next_x = this.x + v * cos(next_rad) + random(-1, 1);
    float next_y = this.y + v * sin(next_rad) + random(-1, 1);
    // runover check
    if(next_x - 7.5 <= Cnst.start_x){
      next_x = Cnst.start_x + abs(next_x - Cnst.start_x) + 7.5;
      next_rad += random(PI/2, PI*1.5);
    }
    if(next_x + 7.5 >= Cnst.end_x){
      next_x = Cnst.end_x - abs(next_x - Cnst.end_x) - 7.5;
      next_rad += random(PI/2, PI*1.5);
    }
    if(next_y - 7.5 <= Cnst.start_y){
      next_y = Cnst.start_y + abs(next_y - Cnst.start_y) + 7.5;
      next_rad += random(PI/2, PI*1.5);
    }
    if(next_y + 7.5 >= Cnst.end_x){
      next_y = Cnst.end_x - abs(next_y - Cnst.end_x) - 7.5;
      next_rad += random(PI/2, PI*1.5);
    }
    //
    this.x = next_x;
    this.y = next_y;
    this.rad = next_rad;
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
      fishes.add(new Fish(x, y, 10, 0));
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
  frameRate(20);
  background(255);
  size(450, 450);
  school = new School(15);
}

void draw(){
  background(255);
  rect(Cnst.start_x, Cnst.start_y, Cnst.x_width, Cnst.y_width);
  school.draw_fishes();
  school.search_neighbors();
  school.eval();
}
