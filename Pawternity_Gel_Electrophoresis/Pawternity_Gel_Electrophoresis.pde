import g4p_controls.*;
import processing.sound.*;

float GEL_WIDTH = 800;
float GEL_HEIGHT = 600;
float GEL_TOP = 100;
boolean gelInitialized = false;
float gelX, gelY;
String[] options;
String[] enzymeOptions = {"EcoRI", "BamHI", "HindIII"};

int screen = 3;    // home (0)  samples (1)    enzymes (2)
int numRacks = 3;
int animationStartTime;
int animationStep;

ArrayList<Cat> cats;
ArrayList<Kitten> kittens;
ArrayList<Sample> samples;

PImage plate, machine, holder1, holder2, holder3;

boolean sampleTaken;

float dragX, dragY; 

SoundFile trash;

Enzyme enzyme; 

Cat draggedCat = null;
Cat placedCat = null;
Cat selectedCat = null;

Kitten caseKitten;

void setup() {
  size(1000, 800);
  background(100, 200, 255);

  plate = loadImage("plate.png");
  machine = loadImage("machine_1.png");
  
  cats = new ArrayList<Cat>();
  kittens = new ArrayList<Kitten>();
  samples = new ArrayList<Sample>();
  enzyme = new Enzyme("EcoRI", "GAATTC");
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
    sampleButton.setVisible(true);
    label1.setVisible(true);
    label2.setVisible(true);
    caseDropdown.setVisible(true);
    caseButton.setVisible(true);
    enzymeDropdown.setVisible(true);
    
    background(100, 200, 255);
    
    loadSampleScreen(); 
  }
  else {
    sampleButton.setVisible(false);
    label1.setVisible(false);
    label2.setVisible(false);
    caseDropdown.setVisible(false);
    caseButton.setVisible(false);
    enzymeDropdown.setVisible(false);

  }
  if (screen == 2) {
    
    drawEnzymeScreen();

  }
  if (screen == 3) {
    
    sample1Box.setVisible(true);
    sample2Box.setVisible(true);
    sample3Box.setVisible(true);
   
    gelInitialized = false;
    
    if (samples.size() > 0) {
      loadTestSamples();   // ONLY ONCE PER ENTRY (safe now if guarded)
    }
    
    sample1Box.setText(samples.get(0).cat.name);
    sample2Box.setText(samples.get(1).cat.name);
    sample3Box.setText(samples.get(2).cat.name);
    drawGelPad();
  }
  else {
    sample1Box.setVisible(false);
    sample2Box.setVisible(false);
    sample3Box.setVisible(false); 
  }
  
  //noLoop();
  
}
