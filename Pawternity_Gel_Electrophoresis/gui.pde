/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void takeSample(GButton source, GEvent event) { //_CODE_:sampleButton:691472:
  // if a cat has actually been placed, we can take a sample
  if (placedCat != null) { 
      String dnaData = placedCat.loadDnaProfile();
      
      // run through all samples
      for (int i = 0; i < samples.size(); i++) {
        Sample s = samples.get(i); 
        
        // first, we can't add duplicate samples of the same cat
        if (s.filled && s.cat != null && s.cat.name.equals(placedCat.name)) {          
          placedCat = null;
          break;
        }
        
        // if the sample is empty, we can add a new sample
        if (s.filled == false) {  
          // set the dna stored in the sample to the cat's dna
          s.dnaSequence = dnaData;
          s.cutSites = enzyme.findCutSites(s.dnaSequence);
          s.fragments = enzyme.digest(s.dnaSequence);
          s.generateBands(enzyme);

          // label the sample with the cat data
          s.cat = placedCat;
          
          // the sample is now filled
          s.filled = true;
          
          break;
        }
      }
      
      // reset the plaecd cat
      placedCat = null;
    }
} //_CODE_:sampleButton:691472:

public void caseSelected(GDropList source, GEvent event) { //_CODE_:caseDropdown:955074:
 int selectedIndex = caseDropdown.getSelectedIndex();
 
 // update the case kitten with the selected kitten
 caseKitten = kittens.get(selectedIndex);
} //_CODE_:caseDropdown:955074:

public void showCaseInfo(GButton source, GEvent event) { //_CODE_:caseButton:275004:
  // reset the info cat so the kitten is the object of interest
  infoCat = null;
  
  // update the text area
  updateInformationBox();
} //_CODE_:caseButton:275004:

public void enzymeSelected(GDropList source, GEvent event) { //_CODE_:enzymeDropdown:210050:
  String selectedEnzyme = enzymeDropdown.getSelectedText();
  
  // create a restriction enzyme
  if (selectedEnzyme.equals("EcoRI")) {
    enzyme = new Enzyme("EcoRI", "GAATTC");
  }
  else if (selectedEnzyme.equals("BamHI")) {
    enzyme = new Enzyme("BamHI", "GGATCC");
  }
  else {
    enzyme = new Enzyme("HindIII", "AAGCTT");    
  }

  // if a new enzyme is selected, the DNA data must be recalculated using that enzyme
  for (int i = 0; i < samples.size(); i++) {
    Sample s = samples.get(i);
    if (s.filled && s.dnaSequence != null) {
      s.cutSites = enzyme.findCutSites(s.dnaSequence);
      s.fragments = enzyme.digest(s.dnaSequence);
      s.generateBands(enzyme);
    }
  }
} //_CODE_:enzymeDropdown:210050:

public void removeSample(GButton source, GEvent event) { //_CODE_:retakeButton:320982:
  // just reset the placed cat
  placedCat = null;
} //_CODE_:retakeButton:320982:

public void sample1Selected(GCheckbox source, GEvent event) { //_CODE_:sample1Box:299050:
  // if none of the other cats have been selected
  if (source.isSelected() && (sample2Box.isSelected() || sample3Box.isSelected())) {
    // don't indicate that this cat has been selected if other samples have been selected

    source.setSelected(false);
    return;
  }

  // Otherwise, assign selected cats and results
  if (source.isSelected()) {
    selectedCat = samples.get(0).cat;
    result = "";
  } 
  else if (selectedCat == samples.get(0).cat) {
    selectedCat = null;
  }
} //_CODE_:sample1Box:299050:

public void sample3Selected(GCheckbox source, GEvent event) { //_CODE_:sample3Box:662928:
  // same as above
  if (source.isSelected() && (sample1Box.isSelected() || sample2Box.isSelected())) {
    source.setSelected(false);
    return;
  }

  if (source.isSelected()) {
    selectedCat = samples.get(2).cat;
    result = "";
  } 
  else if (selectedCat == samples.get(2).cat) {
    selectedCat = null;
  }
} //_CODE_:sample3Box:662928:

public void sample2Selected(GCheckbox source, GEvent event) { //_CODE_:sample2Box:342753:
  // same as above
  if (source.isSelected() && (sample1Box.isSelected() || sample3Box.isSelected())) {
    source.setSelected(false);
    return;
  }

  if (source.isSelected()) {
    selectedCat = samples.get(1).cat;
    result = "";
  } 
  else if (selectedCat == samples.get(1).cat) {
    selectedCat = null;
  }
} //_CODE_:sample2Box:342753:

public void checkFather(GButton source, GEvent event) { //_CODE_:checkButton:409539:
  // get data about the case kitten
  String kittenDNA = caseKitten.loadDnaProfile();
  ArrayList<Integer> kittenBands = enzyme.getFragments(kittenDNA);
  
  float bestPercent = -1;    // best matching case percent
  float userPercent = 0;     // matching percent between user's selected cat and case kitten
    
  int topMatchCount = 0;
  
  Cat bestCat = null;

  // for every sample
  for (int i = 0; i < samples.size(); i++) {
    Sample s = samples.get(i);

    // get the sample bands from the enzyme fragments
    if (s.bandSizes == null || s.bandSizes.isEmpty()) {
      s.bandSizes = enzyme.getFragments(s.cat.loadDnaProfile());
    }

    // calculate the match percent between the selectedCat data and the kitten data
    float percent = calculateMatchPercent(kittenBands, s.bandSizes);
    
    // if the current sample's cat name matches a selectedCat name, save that match percentage to a separate variable (userPercent).
    if (s.cat.name.equals(selectedCat.name)) {
      userPercent = percent;
    }

    // Check if a higher match percent has been found
    if (percent > bestPercent) {
      // update highest percent and highest matching cat
      bestPercent = percent;
      bestCat = s.cat;
      topMatchCount = 1; // Reset tie counter
    } 
    // Check if this cat tied with the current highest match percentage
    else if (abs(percent - bestPercent) < 0.01f && bestPercent > 0) {
      topMatchCount++;
    }
  }
    println(nf(userPercent, 0, 1));
  // no cats have matching bands with the kitten
  if (bestPercent <= 0) {
    result = "None of the tested cats share any DNA bands with " + "\n" + caseKitten.name + " (0% matches). The true father isn't here!";
  }
  
  // if all cats share the same number of matched bands, it is a tie
  else if (topMatchCount == 3 && abs(userPercent - bestPercent) < 0.01f) {
    result = "All suspects share the exact same number of matching bands (" + nf(userPercent, 0, 1) + "%)." + "\n" + "The test is completely inconclusive!";
  }
  
  // if two cats have the same number of matched bands, it could be either one... a tie!
  else if (topMatchCount > 1 && abs(userPercent - bestPercent) < 0.01f) {
    result = "It's a tie! " + selectedCat.name + " matches at " + nf(userPercent, 0, 1) + "%." + "\n" + "Can you identify the other tied candidate?";
  } 
  
  // if one cat has a match percentage of 100, it is almost definetely (99.99% chance) the father!
  else if (topMatchCount == 1 && bestCat != null && bestCat.name.equals(selectedCat.name) && nf(userPercent, 0, 1).equals("100.0")) {
    result = "That is correct! " + bestCat.name + " is a " + nf(userPercent, 0, 1) + "%" + "\n" + "match and is almost definetly " + caseKitten.name + "'s father.";
  }
  
  // if one cat has a higher match percentage, it is MOST LIKELY the father
  else if (topMatchCount == 1 && bestCat != null && bestCat.name.equals(selectedCat.name)) {
    result = "That is correct! " + bestCat.name + " is a " + nf(userPercent, 0, 1) + "%" + "\n" + "match and is most likely " + caseKitten.name + "'s father.";
  }
  
  // if the user has selected a cat that doesn't have the highest match percentage
  else {
    result = "Based on the data, " + selectedCat.name + " is a " + nf(userPercent, 0, 1) + "% match" + "\n" + "and most likely isn't the father. Guess again!";
  }
} //_CODE_:checkButton:409539:

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:528241:
  appc.background(230);
} //_CODE_:window1:528241:

public void infoChanged(GTextArea source, GEvent event) { //_CODE_:infoBox:755543:
  println("infoBox - GTextArea >> GEvent." + event + " @ " + millis());
} //_CODE_:infoBox:755543:

public void goHome(GButton source, GEvent event) { //_CODE_:homeButton:825313:
  screen = 0;
} //_CODE_:homeButton:825313:

public void goSampleScreen(GButton source, GEvent event) { //_CODE_:collectButton:715923:
  screen = 1;
} //_CODE_:collectButton:715923:

public void goVisualize(GButton source, GEvent event) { //_CODE_:visualizeButton:568749:
  // changes screen to enzyme restriction visualization process screen
  boolean allSamplesFilled = true; // start by assuming all samples are filled
    
  // check if all the samples are filled
  for (int i = 0; i < samples.size(); i++) {
    Sample s = samples.get(i);    
    
    if (s.filled == false) {
      allSamplesFilled = false;
      
      break; 
    }
  }
  
  // as long as an enzyme has been selected and all samples have been taken we can proceed to the next screen
  if (allSamplesFilled == true && enzyme != null) {
    screen = 2;
    
    // the next screen requires animation
    animationStartTime = millis();
  }
} //_CODE_:visualizeButton:568749:

public void goEvaluate(GButton source, GEvent event) { //_CODE_:evaluateCaseButton:379020:
  // once again, check if all samples have been filled
  boolean allSamplesFilled = true;
    
  for (int i = 0; i < samples.size(); i++) {
    Sample s = samples.get(i);    
    
    if (s.filled == false) {
      allSamplesFilled = false;
      
      break; 
    }
  }
  
  // if evreything has been filled or selected, we can go to the next screen.
  if (allSamplesFilled == true && enzyme != null) {
    screen = 3;      
  }
} //_CODE_:evaluateCaseButton:379020:

public void sensitivityChanged(GCustomSlider source, GEvent event) { //_CODE_:sensitivitySlider:459638:
  // update the sensitivity with the slider value
  sensitivity = sensitivitySlider.getValueI();
} //_CODE_:sensitivitySlider:459638:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  sampleButton = new GButton(this, 374, 485, 80, 30);
  sampleButton.setText("SCAN");
  sampleButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  sampleButton.addEventHandler(this, "takeSample");
  label1 = new GLabel(this, 610, 80, 80, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Select Case");
  label1.setOpaque(false);
  caseDropdown = new GDropList(this, 610, 110, 340, 100, 4, 10);
  caseDropdown.setItems(loadStrings("list_955074"), 0);
  caseDropdown.addEventHandler(this, "caseSelected");
  caseButton = new GButton(this, 610, 140, 100, 30);
  caseButton.setText("See Case Info");
  caseButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  caseButton.addEventHandler(this, "showCaseInfo");
  label2 = new GLabel(this, 610, 190, 150, 20);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("Select Restriction Enzyme");
  label2.setOpaque(false);
  enzymeDropdown = new GDropList(this, 610, 220, 340, 80, 3, 10);
  enzymeDropdown.setItems(loadStrings("list_210050"), 0);
  enzymeDropdown.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  enzymeDropdown.addEventHandler(this, "enzymeSelected");
  retakeButton = new GButton(this, 343, 550, 112, 39);
  retakeButton.setText("Retake Sample");
  retakeButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  retakeButton.addEventHandler(this, "removeSample");
  sample1Box = new GCheckbox(this, 360, 540, 150, 20);
  sample1Box.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  sample1Box.setText("checkbox text");
  sample1Box.setOpaque(false);
  sample1Box.addEventHandler(this, "sample1Selected");
  sample3Box = new GCheckbox(this, 360, 575, 150, 20);
  sample3Box.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  sample3Box.setText("checkbox text");
  sample3Box.setOpaque(false);
  sample3Box.addEventHandler(this, "sample3Selected");
  sample2Box = new GCheckbox(this, 540, 540, 150, 20);
  sample2Box.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  sample2Box.setText("checkbox text");
  sample2Box.setOpaque(false);
  sample2Box.addEventHandler(this, "sample2Selected");
  checkButton = new GButton(this, 723, 539, 105, 30);
  checkButton.setText("Run Analysis");
  checkButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  checkButton.addEventHandler(this, "checkFather");
  window1 = GWindow.getWindow(this, "Window title", 0, 0, 350, 650, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.KEEP_OPEN);
  window1.addDrawHandler(this, "win_draw1");
  infoBox = new GTextArea(window1, 18, 360, 306, 144, G4P.SCROLLBARS_NONE);
  infoBox.setOpaque(true);
  infoBox.addEventHandler(this, "infoChanged");
  label3 = new GLabel(window1, 18, 330, 120, 20);
  label3.setText("Information Box");
  label3.setOpaque(false);
  homeButton = new GButton(window1, 24, 24, 300, 50);
  homeButton.setText("Go Home");
  homeButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  homeButton.addEventHandler(this, "goHome");
  collectButton = new GButton(window1, 24, 104, 300, 50);
  collectButton.setText("Collect Samples");
  collectButton.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  collectButton.addEventHandler(this, "goSampleScreen");
  visualizeButton = new GButton(window1, 24, 184, 300, 50);
  visualizeButton.setText("Prep Samples");
  visualizeButton.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  visualizeButton.addEventHandler(this, "goVisualize");
  evaluateCaseButton = new GButton(window1, 24, 264, 300, 48);
  evaluateCaseButton.setText("Evaluate Results");
  evaluateCaseButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  evaluateCaseButton.addEventHandler(this, "goEvaluate");
  label4 = new GLabel(window1, 150, 66, 40, 40);
  label4.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label4.setText("↓ ");
  label4.setOpaque(false);
  label5 = new GLabel(window1, 128, 152, 80, 20);
  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label5.setText("↓ ");
  label5.setOpaque(false);
  label6 = new GLabel(window1, 128, 240, 80, 20);
  label6.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label6.setText("↓ ");
  label6.setOpaque(false);
  label7 = new GLabel(window1, 18, 522, 108, 20);
  label7.setText("Adjust Sensitivity");
  label7.setOpaque(false);
  sensitivitySlider = new GCustomSlider(window1, 18, 552, 300, 68, "grey_blue");
  sensitivitySlider.setShowValue(true);
  sensitivitySlider.setShowLimits(true);
  sensitivitySlider.setLimits(0, 0, 5);
  sensitivitySlider.setNbrTicks(5);
  sensitivitySlider.setStickToTicks(true);
  sensitivitySlider.setShowTicks(true);
  sensitivitySlider.setNumberFormat(G4P.INTEGER, 0);
  sensitivitySlider.setOpaque(false);
  sensitivitySlider.addEventHandler(this, "sensitivityChanged");
  window1.loop();
}

// Variable declarations 
// autogenerated do not edit
GButton sampleButton; 
GLabel label1; 
GDropList caseDropdown; 
GButton caseButton; 
GLabel label2; 
GDropList enzymeDropdown; 
GButton retakeButton; 
GCheckbox sample1Box; 
GCheckbox sample3Box; 
GCheckbox sample2Box; 
GButton checkButton; 
GWindow window1;
GTextArea infoBox; 
GLabel label3; 
GButton homeButton; 
GButton collectButton; 
GButton visualizeButton; 
GButton evaluateCaseButton; 
GLabel label4; 
GLabel label5; 
GLabel label6; 
GLabel label7; 
GCustomSlider sensitivitySlider; 
