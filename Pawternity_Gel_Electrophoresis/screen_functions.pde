// These functions are used to draw different screens; the other tab has "helper functions" used in these functions.

// draw home screen
void drawHomeScreen() {
  imageMode(CENTER);
  
  // draw the pawternity logo in the centre of the screen
  image(logo, 500, 325);
}

// draw the screen where the user can collect samples
void loadSampleScreen() {
  // background panels
  fill(220); 
  noStroke();
  rect(10, 50, 555, 280);
  rect(555 + 25, 50, 400, 280);

  // title
  textAlign(LEFT); 
  fill(0);
  textSize(24);
  
  // draw title
  text("Select and Drag a Cat to Sample", 10, 30);

  // draw cat grid by drawing each cat icon individually
  for (int i = 0; i < cats.size(); i++) {
    // calculate spacing using the row and column
    int row = i / 6;
    int col = i % 6;
    int x = 25 + col * 90; 
    int y = 65 + row * 155;
    
    // get the current cat and draw its picture at the calculated grid position
    Cat c = cats.get(i);
    if (c.img != null) {
      imageMode(CORNER);
      image(c.img, x, y, 75, 75);
    }

    // write the cat's name under it's picture
    fill(0);
    textSize(14);
    textAlign(CENTER);
    text(c.name, x + 37, y + 95);
  }
  
  // draw each sample
  for (int i = 0; i < samples.size(); i++) {
    samples.get(i).drawRack();  
  }
  
  // draw machine and Plate
  image(machine, 250, 330, 225, 225);
  image(plate, 25, 350, 200, 200);

  // draw a cat if placed onto the plate
  if (placedCat != null) {
    image(placedCat.img, 65, 390, 120, 120); 
  }

  // draw a dragged cat
  if (draggedCat != null) {
    image(draggedCat.img, dragX - 37, dragY - 37, 75, 75);
  }
}

// function to draw the enzyme restriction visualization screen
void drawEnzymeScreen() {
  float startX = 50;
  float startY = 100;

  String stepDescription = "";

  // this screen uses animation, with each "stage" occuring every 5 seconds (5000 milliseconds)
  animationStep = (millis() - animationStartTime) / 5000 + 1;
  
  // once the time progresses past the 4th animation step, show the animation for step 4
  if (animationStep > 4) {
    animationStep = 4;
  }
  
  fill(255);
  textAlign(CENTER);
  textSize(26);

  // based on the animation step, the description title will be different.
  if (animationStep == 1) {
    stepDescription = "Step 1: DNA Sample Loaded";
  }
  else if (animationStep == 2) {
    stepDescription = "Step 2: Enzyme " + enzyme.name + " binds " + enzyme.recognitionSite;
  }
  else if (animationStep == 3) {
    stepDescription = "Step 3: DNA Cut";
  }
  else {
    stepDescription = "Step 4: Fragments Formed and Ready for Gel";
  }

  // draw the title in the centre of the screen (horisontally)
  text(stepDescription, width/2, 40);

  // visualize each sample
  for (int i = 0; i < samples.size(); i++) {
    Sample s = samples.get(i);
    
    //calculate the vertical row position in order to stack the bands on top of each other
    float y = startY + i * 140;

    fill(0);
    textAlign(LEFT);
    textSize(16);

    // label each sample
    text(s.cat.name, startX, y - 20);

    // for the first step, draw the full DNA sequence
    s.drawDNA(startX, y);

    // for the second step, draw the DNA sequence with the enzyme restriction cuts
    if (animationStep >= 3) {
      s.drawCutSites(startX, y + 30);
    }
    
    // for the last step, label the DNA fragments
    if (animationStep >= 4) {
      s.drawFragmentLabels(startX, y + 65);
    }
  }
}

// draw the gel on the evaluation screen
void drawGelPad() {
  background(210);
  fill(235);
  stroke(90);
  
  //background of the gel
  rect(220, 65, 560, 400);

  // set up a temporary array to store the horizontal ladder midpoints for the three samples
  float[] sampleLaneX = new float[3];

  // populate the array by calculating the exact spacing for each column
  for (int i = 0; i < 3; i++) {
    sampleLaneX[i] = 290 + 140 * (i + 1);
  }

  // lane dividers/boundaries
  stroke(140);
  for (int i = 1; i < 4; i++) {
    float x = 220 + 140 * i;
    
    line(x, 65, x, 465);
  }
  
  fill(0);
  textAlign(CENTER);
  textSize(14);

  // label case kitten name above column
  text(caseKitten.name, 290, 50);

  // label each sample using the cat name
  for (int i = 0; i < samples.size() && i < 3; i++) {
    if (samples.get(i).cat != null) {
      text(samples.get(i).cat.name, sampleLaneX[i], 50);
    }
  }

  // vertical scale of the bp ladder; I will be using a 100 bp ladder.
  int[] bp = {100, 75, 50, 25, 0};

  textAlign(RIGHT);
  textSize(10);

  // for each bp index
  for (int b : bp) {

    // 100 at top, 0 at bottom, calculating the vertical step spacing between indices
    float y = map(b, 100, 0, 100, 430);

    // draw the index label
    fill(0);
    text(b, 212, y);

    // draw horizontal gridlines
    stroke(170);
    line(220, y, 220 + 560, y);
  }
  
  // drawkitten DNA bands on the first ladder lane
  drawKittenBands(290);

  // draw the sample bands on their rspective lanes
  for (int i = 0; i < samples.size() && i < 3; i++) {
    drawSampleBands(samples.get(i), sampleLaneX[i]);
  }
  
  // background for selection checkboxes
  fill(100, 200, 255);
  rect(0, 500, 1000, 800);
  fill(0);
  textSize(20);
  
  // draw text
  text("Who is " + caseKitten.name + "'s father?", 250, 550);
}
