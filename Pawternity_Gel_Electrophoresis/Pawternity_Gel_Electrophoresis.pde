import g4p_controls.*;
import processing.sound.*;

String[] options;
String[] enzymeOptions = {"EcoRI", "BamHI", "HindIII"};

int screen = 2;    // home (0)  samples (1)    enzymes (2)
int numRacks = 3;
int animationStartTime;
int animationStep;

ArrayList<Cat> cats;
ArrayList<Kitten> kittens;
ArrayList<Sample> samples;

PImage plate, machine, machine1, machine2, holder1, holder2, holder3;

boolean sampleTaken;

float dragX, dragY; 

SoundFile trash;

Enzyme enzyme; 

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
    
  createGUI();
  createDropdownLists();
  
  surface.setLocation(350, 0); // use setLocation to ensure windows don't overlap  
  sampleButton.setVisible(false);
  sampleButton.setVisible(false);
  label1.setVisible(false);
  label2.setVisible(false);
  caseDropdown.setVisible(false);
  caseButton.setVisible(false);
  enzymeDropdown.setVisible(false);
  
  animationStartTime = millis();
  animationStep = 1;

}

void draw() {
  
  background(100, 200, 255);
  
  if (placedCat == null) {
    retakeButton.setVisible(false);
  }
  else {
   retakeButton.setVisible(true);
  }
  
  if (screen == 1) {
    
    background(100, 200, 255);
    
    if (sampleTaken) {
      machine = machine1; 
    }
    else {
      machine = machine2; 
    }
    
    loadSampleScreen(); 
  }
  else if (screen == 2) {

    loadTestSamples();
    drawEnzymeVisualization();

  }
  
  //noLoop();
  
}
