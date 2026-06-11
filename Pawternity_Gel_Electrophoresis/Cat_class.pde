class Cat {
 String name;
 String[] traits;
 PImage img;
 
 Cat(String n, String fp, String[] t) {
   this.name = n;
   this.img = loadImage(fp);
   this.traits = t;
 }
}
