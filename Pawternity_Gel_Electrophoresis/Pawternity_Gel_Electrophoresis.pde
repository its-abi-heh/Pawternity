import g4p_controls.*;
import processing.sound.*;

String enzyme;
String[] options;
//Object[][] samples = new String[0][0]; // need object so I can store a string, then an array

int screen = 0;
int numRacks = 3;

ArrayList<Cat> cats;
ArrayList<Kitten> kittens;
ArrayList<Sample> samples;

PImage plate, machine, machine1, machine2, holder1, holder2, holder3;

boolean sampleTaken;

float dragX, dragY; 

SoundFile trash;

Cat draggedCat = null;
Cat placedCat = null;
Kitten caseKitten;

void setup() {
  size(1000, 800);
  background(100, 200, 255);
  
  plate = loadImage("plate.png");
  machine1 = loadImage("machine_1.png");
  machine2 = loadImage("machine_2.png");
  
  cats = new ArrayList<Cat>();
  kittens = new ArrayList<Kitten>();
  samples = new ArrayList<Sample>();
  
  trash = new SoundFile(this, "data/trash.mp3");


  loadCats();
  loadKittens();
  loadRacks();
  
  surface.setLocation(350, 0); // use setLocation to ensure windows don't overlap
  
  createGUI();
  createDropdownLists();
}

void draw() {
  if (screen == 0) {
    background(100, 200, 255);
    //loadTestSamples();

    if (placedCat == null) {
      retakeButton.setVisible(false);
    }
    else {
     retakeButton.setVisible(true);
    }
    
    if (sampleTaken) {
      machine = machine1; 
    }
    else {
      machine = machine2; 
    }
    
    loadSampleScreen(); 
  }
  else {
    sampleButton.setVisible(false);
  }
}
