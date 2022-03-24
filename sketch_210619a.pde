int backgroundColor = #D2D1D2;      //背景颜色
int snakeLength = 2;    //蛇初始长度
int gradeScore = 15;  //关卡升级需要分数
int gradeWin=20;  //关卡胜利需要分数

int snakeHeadX;         
int snakeHeadY;        //蛇头位置坐标
char snakeDirection = 'R';  //UP/DOWN/LEFT/RIGHT代表初始朝向
char snakeDirectionTemp;

int pause = 0;         //用于暂停
int grade=0;    //用于关卡升级

PImage img;
PImage logo;

PFont myFont;

int w=25;   //每一格大小
int maxSnakeLength = 400;    //蛇最大长度
int[] x = new int [maxSnakeLength];
int[] y = new int [maxSnakeLength];

boolean foodKey = true;
int foodX;
int foodY;    //果实开关与位置坐标

int bestScore = snakeLength;  //最高分为蛇长度

boolean gameOverKey = false;  //判断游戏是否结束
boolean gradeUp=false;//判断游戏等级是否提升

int savedTime; 
int totalTime;
int passedTime;

float time=0;

Particle[] particles;

void setup(){
    size(500,500);
    frameRate(60);
    noStroke();
    savedTime = millis(); 
    img = loadImage("back.png"); 
    logo = loadImage("LHZ.png");
    myFont=createFont("黑体",20);
    textFont(myFont);
    particles = new Particle[15];
    for(int i=0; i<particles.length;i++){
      particles[i] = new Particle();
    }
}

int speed = 5;  //移动步速

void draw()
{
  if(grade==0)
  {
    showStart();
    if(key == 'r' || key == 'R')
      grade=1;
  }
  
  if(grade==1)
  {
    totalTime = 800/speed;     //此速度下的最大运行时间
    passedTime = millis()- savedTime;    //程序当前总运行时间-上次所存储程序总运行时间
      //没有暂停且此蛇身运行时间大于此速度最大运行时间
    if ( snakeDirection!='P' && passedTime > totalTime ) {
        if(isGameOver() ){
            speed = 5;  //设回初始步速
            return;
        }
        background(backgroundColor);
        image(img,0,0,500,500);
        fill(0);
        textSize(24);
        text("当前分数："+ snakeLength,80,50);
        text("通关分数："+gradeScore,80,80);
        text("罗涵中",420,50);
        text("10182492",410,75);
        if(snakeLength==gradeScore){
          gradeUp=true;
          grade=2;
        }
        //判断蛇头方向
        switch(snakeDirection){
            case 'L':
                snakeHeadX -= w;
                break;
            case 'R':
                snakeHeadX += w;
                break;
            case 'D':
                snakeHeadY += w;
                break;
            case 'U':
                snakeHeadY -= w;
                break;
        }
        //生成新果实
        drawFood(width,height);
        //吃果实加速
        if( snakeHeadX == foodX && snakeHeadY == foodY){
            snakeLength++;
            //重设步速
            speed ++;
            foodKey = true;  //允许生成果实
        }
        //存储蛇身坐标位置
        for(int i=snakeLength-1; i>0; i--){
            x[i] = x[i-1];
            y[i] = y[i-1];
        }
        //存储新蛇头
        y[0] = snakeHeadY;
        x[0] = snakeHeadX;
        stroke(0);  //黑色描线
        strokeWeight(1);    //线宽为1
        //生成蛇头
        fill(#FFCE00);
        rect(x[0],y[0],w,w);
        //生成蛇身
        fill(#CE00FF);
        for(int i=1; i<snakeLength; i++){
            rect(x[i],y[i],w,w);
        }
        if(snakeDirection!='P' && isSnakeDie()){
            return;
        }
        savedTime = millis(); //存储程序当前总运行时间
    }
  }
  
  if(grade==2&&gradeUp)
  {
    pushMatrix();
    background(#CEF359);
    translate(width/2, height/2 - 50);
    fill(#F5577F);  //black
    textAlign(CENTER);  //居中对齐
    textSize(84);
    text("恭喜通关",0,0);
    textSize(50);
    text("按[R]键进入下一关",0,230);
    popMatrix();
    if(key == 'r' || key == 'R'){
      gradeUp=false;
      bestScore=0;
      speed=5;
      snakeInit();
    }
  }
  
  if(grade==2&&!gradeUp)
  {
    totalTime = 500/speed;     //此速度下的最大运行时间
    passedTime = millis()- savedTime;    //程序当前总运行时间-上次所存储程序总运行时间
      //没有暂停且此蛇身运行时间大于此速度最大运行时间
    if ( snakeDirection!='P' && passedTime > totalTime ) {
        if(isGameOver() ){
            speed = 5;  //设回初始步速
            return;
        }
        background(backgroundColor);
        float a = 0;
        while (a < width) {
          line(a, 200 + 50 * noise(a / 100, time), a, height);
          a = a + 1;
        }
        time = time + 0.02;
        for(int i=0;i<particles.length;i++){
          particles[i].update();
          particles[i].display();
        }
        fill(0);
        textSize(24);
        text("当前分数："+ snakeLength,80,50);
        text("通关分数："+ gradeWin,80,80);
        text("罗涵中",420,50);
        text("10182492",410,75);
        if(snakeLength==gradeWin){
          grade=3;
        }
        //判断蛇头方向
        switch(snakeDirection){
            case 'L':
                snakeHeadX -= w;
                break;
            case 'R':
                snakeHeadX += w;
                break;
            case 'D':
                snakeHeadY += w;
                break;
            case 'U':
                snakeHeadY -= w;
                break;
        }
        //生成新果实
        drawFood(width,height);
        //吃果实加速
        if( snakeHeadX == foodX && snakeHeadY == foodY){
            snakeLength++;
            //重设步速
            speed ++;
            foodKey = true;  //允许生成果实
        }
        //存储蛇身坐标位置
        for(int i=snakeLength-1; i>0; i--){
            x[i] = x[i-1];
            y[i] = y[i-1];
        }
        //存储新蛇头
        y[0] = snakeHeadY;
        x[0] = snakeHeadX;
        stroke(0);  //黑色描线
        strokeWeight(1);    //线宽为1
        //生成蛇头
        fill(#E4F696);
        rect(x[0],y[0],w,w);
        //生成蛇身
        fill(#A79A8F);
        for(int i=1; i<snakeLength; i++){
            rect(x[i],y[i],w,w);
        }
        if(snakeDirection!='P' && isSnakeDie()){
            return;
        }
        savedTime = millis(); //存储程序当前总运行时间
    }
  }
  
  if(grade==3)
  {
    pushMatrix();
    background(#F8E0A0);
    translate(width/2, height/2 - 50);
    fill(#5BC2C3);  
    textAlign(CENTER);  //居中对齐
    textSize(84);
    text("恭喜获胜",0,0);
    textSize(32);
    text("今日走过人生所有的弯路",0,120);
    text("从 此 人 生 尽 是 坦 途",0,160);
    popMatrix();
  }
}//end draw()

//键盘控制
void keyPressed()
{
    if(key == 'p' || key == 'P'){
        pause++;
        if(pause%2==1){
            snakeDirectionTemp = snakeDirection;    //存储暂停前方向
            snakeDirection = 'P';
        }else{
            snakeDirection = snakeDirectionTemp;    //恢复存储的方向
        }
    }
    if(snakeDirection != 'P' && key == CODED){
        switch(keyCode){
            case LEFT:
                snakeDirection = 'L';
                break;
            case RIGHT:
                snakeDirection = 'R';
                break;
            case DOWN:
                snakeDirection = 'D';
                break;
            case UP:
                snakeDirection = 'U';
                break;
        }
    }else if(snakeDirection != 'P'){
        switch(key){
            case 'A':
            case 'a':
                if(snakeDirection!='R')
                  snakeDirection = 'L';
                break;
            case 'D':
            case 'd':
                if(snakeDirection!='L')
                  snakeDirection = 'R';
                break;
            case 'S':
            case 's':
                if(snakeDirection!='U')
                  snakeDirection = 'D';
                break;
            case 'W':
            case 'w':
                if(snakeDirection!='D')
                  snakeDirection = 'U';
                break;
        }
    }
}   //end keyPressed()

//初始化蛇
void snakeInit()
{
    background(backgroundColor);
    snakeLength = 2;
    gameOverKey = false;
    snakeHeadX = 0;
    snakeHeadY = 0;
    snakeDirection = 'R';
}

//生成果实
void drawFood(int maxWidth, int maxHeight)
{
    fill(#00FFCE);
    if(foodKey){
        foodX = int( random(0, maxWidth)/w ) * w;
        foodY = int( random(0, maxHeight)/w) * w;
    }
    ellipseMode(CORNER);
    ellipse(foodX, foodY, w, w);
    foodKey = false;
}

//游戏结束
boolean isGameOver()
{
    if(gameOverKey && keyPressed && (key=='r'||key=='R') ){
        snakeInit();
    }
    return gameOverKey;
}

//蛇死亡
boolean isSnakeDie()
{
    //撞墙
    if(snakeHeadX<0 || snakeHeadX>=width || snakeHeadY<0 || snakeHeadY>=height){
        showGameOver();
        return true;
    }
    //碰撞蛇身
    if(snakeLength>2){
        for(int i=1; i<snakeLength; i++){
            if(snakeHeadX==x[i] && snakeHeadY == y[i]){
                showGameOver();
                return true;
            }
        }
    }
    return false;
}

//显示游戏结束界面
void showGameOver()
{
    pushMatrix();
    gameOverKey = true;
    bestScore = bestScore > snakeLength ? bestScore : snakeLength;
    background(#0A193B);  //black
    translate(width/2, height/2 - 50);
    fill(#F4782F);  //white
    textAlign(CENTER);  //居中对齐
    textSize(84);
    text("游戏结束", 0, -30);
    text(snakeLength + "/" + bestScore, 0, 100);
    fill(#991E3D);
    textSize(32);
    text("分数 / 最高分",0,150);
    text("按[R]键重新开始", 0, 200);
    popMatrix();
}

//显示开始界面
void showStart()
{
  pushMatrix();
  background(#93B3CC);
  image(logo,420,20,72,28);
  translate(width/2, height/2 - 50);
  fill(#1C0D04);  //black
  textAlign(CENTER);  //居中对齐
  textSize(84);
  text("贪吃蛇",0,0);
  textSize(50);
  text("按[R]键开始游戏",0,230);
  fill(255);
  textSize(24);
  text(" ↑     W          ",0,60);
  text("利用←↓→或ASD控制贪吃蛇方向",0,80);
  text("吃掉果实得分并取得胜利吧！",0,110);
  popMatrix();
}

//向量粒子动画类
class Particle{
  PVector position;
  PVector velocity;
  float radius;
  Particle(){
    float x = random(width);
    float y = random(height);
    position = new PVector(x,y);
    velocity = PVector.random2D();
    velocity.setMag(random(2));
    radius = random(1,7);
  }
  void update(){
    position.add(velocity);
    boundary();
  }
  void boundary(){
    if(position.x<0){
      position.x=width;
    }else if(position.x>width){
      position.x=0;
    }
    if(position.y<0){
      position.x=height;
    }else if(position.y>height){
      position.y=0;
    }
  }
  void display(){
    noStroke();
    fill(255);
    ellipseMode(RADIUS);
    ellipse(position.x,position.y,radius,radius);
  }
}
