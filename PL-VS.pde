import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;
AudioPlayer player;
AudioMetaData meta;
FFT fft;


void setup() {
  size(960, 600);
  minim = new Minim(this); //δημιουργία minim
  player = minim.loadFile("Elektronomia & JJD - NCS Release.mp3"); //load το τραγούδι
  meta = player.getMetaData(); //μεταδεδομένα
  fft = new FFT(player.bufferSize(), player.sampleRate());
  player.loop(); //when opened play this
}

void draw() {
  
  PImage img; //εικόνα για background
img = loadImage("n.jpg");
background(img);
  stroke(255);
  
  //visualizers 
  for(int i = 0; i < player.bufferSize() - 1; i++)
  {
    float left1 = 100 + player.left.get(i) * 100;
    float left2 = 100 + player.left.get(i+1) * 100;
    float right1 = 200 + player.right.get(i) * 200;
    float right2 = 200 + player.right.get(i+1) * 200;
    line(i, left1, i+1, left2);
    line(i, right1, i+1, right2);
  }
//visualizer
  fft.forward(player.mix);
  noStroke();
  fill(random(255), random(255), random(255), random(255));
  for(int i = 0; i < 1000; i++)
  {
    float b = fft.getBand(i);
    float x = random(-b, b) + width/2;
    float y = i*2;
    ellipse(x, y, b, b);
    rect(i*2, height - b, 5, b);
  }

  
  for(int i = 0; i < player.bufferSize() - 1; i++)
  {
    line(i, 50  + player.left.get(i)*50,  i+1, 50  + player.left.get(i+1)*50);
    line(i, 150 + player.right.get(i)*50, i+1, 150 + player.right.get(i+1)*50);
  }
  
  //μπάρα τραγουδιού
  float posx = map(player.position(), 0, player.length(), 0, width);
  stroke(255,0,0);
  line(posx, 0, posx, 10);
    stroke(255);
  fill(255, 150, 250, 255);
  textSize(15);
  //μεταδεδομένα
  text(" " + meta.fileName(), 650, 30);
  text(player.position()/1000 + " / " +player.length()/1000,870,550);
  textSize(12);
  //Το κείμενο για τις εντολές που θα εμφανίζεται στην οθόνη
  text("Press ESC to exit",10,50); //έξοδος
  text("Press r to rewind", 10, 20); //επανάληψη
  text("forward f   backward b", 10,60); //μπροστά πίσω
  if (player.isPlaying()){
  textSize(12);
  text("Press p or mouse to stop",10 , 30); //παύση
  textSize(20);
  text("Playing",870,570);} //κάτω μπάρα
  else{
  textSize(12);
  text("Press p or mouse to play",10 , 30); //εκκίνηση ξανά
  textSize(20);  
  text("Paused",870,570);}   //Κάτω μπάρα
  if (player.isMuted()){
      textSize(12);
      text("Press u to unmute",10,40);
      textSize(20);
      text("Muted",870,590);  } //Κάτω μπάρα
  else {
      textSize(12);  
      text("Press m to mute",10,40); //Σίγαση
      textSize(20);
      text("Unmuted",870,590);   //Κάτω μπάρα
}
}
  

  
  
void keyPressed() //Οι εντολές που θα γίνονται με το πάτημα κουμπιών (play,rewind,pause...)
{
 if (key == 'r' || key == 'R'){
  player.rewind();
  }
  if (key == 'p' || key == 'P'){
   if (player.isPlaying()){
      player.pause();}
   else{
      player.play();
   }
  }
  if (key=='m' || key=='M'){
    player.mute();
  }
  if (key=='u' || key=='U'){
    if  (player.isMuted()){
      player.unmute();}}
   if ( key == 'f' )
  
  {  
    // skip forward 1 second (1000 milliseconds)
    player.skip(1000);
  }
 
 {if (key == 'b')
    // skip backward 1 second (1000 milliseconds)
    player.skip(-1000);
  }
  if (key==ESC){
    player.close(); //σταματάει το τραγούδι και κλείνει το πρόγραμμα
    minim.stop();
    super.stop();
  }
}



void stop() {
  player.close(); //σταματάει το τραγούδι και κλείνει το πρόγραμμα
  minim.stop();
  super.stop();
}