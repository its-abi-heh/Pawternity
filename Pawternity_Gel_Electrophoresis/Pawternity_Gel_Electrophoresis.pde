import g4p_controls.*;
import processing.sound.*;

// VARIABLES
ArrayList<Cat> cats;
ArrayList<Kitten> kittens;
ArrayList<Sample> samples;

boolean sampleTaken;

float dragX, dragY; 

int screen = 0;    // home (0)  samples (1)    enzymes (2)  gel setup (3)
int numRacks = 3;
int animationStartTime;
int animationStep = 1;

PImage plate, machine, holder1, holder2, holder3, logo;

String[] options;
String[] enzymeOptions = {"EcoRI", "BamHI", "HindIII"};
String result = "";

SoundFile trash;

Enzyme enzyme; 

Cat draggedCat = null;
Cat placedCat = null;
Cat selectedCat = null;
Cat infoCat = null;

Kitten caseKitten;

void setup() {
  size(1000, 650);
  background(100, 200, 255);

  plate = loadImage("plate.png");
  machine = loadImage("machine_1.png");
  logo = loadImage("logo.png");
  
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
}

void draw() {
  
  background(100, 200, 255);
  
  if (placedCat == null) {
    retakeButton.setVisible(false);
  }
  else {
   retakeButton.setVisible(true);
  }
  if (screen == 0) {
   drawHomeScreen(); 
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
    
    checkButton.setVisible(true);
    sample1Box.setText(samples.get(0).cat.name);
    sample2Box.setText(samples.get(1).cat.name);
    sample3Box.setText(samples.get(2).cat.name);
    drawGelPad();
    
    if (!result.equals("")) {
      textSize(16);
      textAlign(LEFT);
      text(result, 250, 600);
    }
  }
  else {
    checkButton.setVisible(false);
    sample1Box.setVisible(false);
    sample2Box.setVisible(false);
    sample3Box.setVisible(false); 
  }  
}
