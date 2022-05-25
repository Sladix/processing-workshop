import toxi.geom.*;
import toxi.math.*;
import processing.svg.*;
import java.util.*;

ArrayList<MLine> lines;
boolean done = false;
int numLines = 0, maxLines = 0;
long randSeed;
float angle = 4;
float spawnDist = 5;
float moveSpeed = 1;
float minDistToSpawn = 10;
float randomDist = 50;
boolean debugPoints;
boolean randmode;
float maxTurns;
float LEns = 0.001;
float randomProb = 0.5;
void setup() {
  size(768, 1086, P2D);
  //fullScreen(P2D);
  lines = new ArrayList<MLine>();
  stroke(0);
}
void draw() {
  background(255);
  group("global");
  randSeed = (long)sliderInt("randSeed", 2);
  randomDist = sliderInt("randomDist", 50);
  randmode = toggle("randMode", false);
  if (button("init")) {
    init();
  }
  if (button("exportSVG")) {
    beginRecord(SVG, "out/exports/svg/"+Utils.timestamp()+".svg");
    drawThing();
    endRecord();
  } else {

    group("noiseProps");
    maxTurns = slider("maxTurns", 1);
    LEns = slider("noiseScale", 0.001);
    group("lines");
    angle = slider("angleStart", 4);
    numLines = sliderInt("linesSpanwed", 2);
    maxLines = sliderInt("maxLines", 200);
    spawnDist = sliderInt("spawnDist", 5);
    moveSpeed = slider("moveSpeed", 1);
    minDistToSpawn = sliderInt("minDistToSpawn", 10);
    randomProb = slider("randomProb", 0, 1, 0.5);
    debugPoints = toggle("debugPoints");
    drawThing();
    if (!done) {
      for (int i = 0; i < moveSpeed; i++) {
        grow();
      }
    }
  }
  gui();
  rec();
}

boolean outaBounds(Line2D l) {
  return l.a.x < 0 || l.a.x > width || l.b.x < 0 || l.b.x > width || l.a.y < 0 || l.a.y > height || l.b.y < 0 || l.b.y > height;
}

void grow() {
  boolean moved = false;
  ArrayList<MLine> lta = new ArrayList<MLine>();
  for (MLine ml : lines) {
    if (ml.done) {
      continue;
    }

    /*Grow*/
    Line2D l = new Line2D(ml.line.a, ml.line.b);
    Vec2D dir = ml.line.getDirection().normalize();

    l.set(ml.line.a, ml.line.b.add(dir));

    boolean didCollideFront = didCollide(ml, l);
    boolean didCollideBack = false;
    if (didCollideFront) {
      l.set(ml.line.a, ml.line.b);
      l.set(l.a.add(dir.scale(-1)), l.b);
      didCollideBack = didCollide(ml, l);
    }

    boolean didCollide = didCollideFront && didCollideBack;

    if (!didCollide) {
      ml.line.set(l.a, l.b);
      moved = true;
    } else {
      ml.done = true;
      if (ml.line.getLength() > minDistToSpawn) {

        MLine ta = spawnLine(ml.line, 1);
        if (ta != null && random(1) > randomProb) {
          lta.add(ta);
        }

        MLine ta2 = spawnLine(ml.line, -1);
        if (ta2 != null && random(1) > randomProb) {
          lta.add(ta2);
        }

        if (ta != null || ta2 != null) {
          moved = true;
          break;
        }
      }
    }
  }
  lines.addAll(0, lta);
  if (!moved) {
    done = true;
    println("done : "+lines.size()+" lines");
  }
}

MLine spawnLine(Line2D orig, int dir) {
  if (lines.size() > maxLines) {
    return null;
  }
  Vec2D mp = orig.getMidPoint();
  float fa = randmode ? noise(mp.x*LEns, mp.y* LEns) * PI * maxTurns * dir : PI/angle * dir;
  Vec2D a = mp.add(orig.getNormal().normalize().scale(dir*spawnDist));
  Vec2D b = a.copy().add(orig.getDirection().normalize().scale(dir).rotate(fa));
  Line2D nl = new Line2D(a, b);

  boolean didCollide = didCollide(nl);
  if (!didCollide) {
    return new MLine(nl);
  } else {
    return null;
  }
}

boolean didCollide(Line2D l) {
  boolean dc = false;
  for (MLine conc : lines) {
    Line2D.LineIntersection li = conc.line.intersectLine(l);
    if (li.getType() == Line2D.LineIntersection.Type.INTERSECTING || outaBounds(l)) {
      dc = true;
    }
    if (li.getType() == Line2D.LineIntersection.Type.PARALLEL && conc.line.distanceToPoint(l.a) < minDistToSpawn) {
      dc = true;
    }
  }
  return dc;
}

boolean didCollide(MLine m, Line2D l) {
  boolean dc = false;
  for (MLine conc : lines) {
    if (conc.equals(m)) {
      continue;
    }
    Line2D.LineIntersection li = conc.line.intersectLine(l);
    if (li.getType() == Line2D.LineIntersection.Type.INTERSECTING || outaBounds(l)) {
      dc = true;
    }
  }
  return dc;
}

void init() {
  done = false;
  randomSeed(randSeed);
  noiseSeed(randSeed);
  lines = new ArrayList<MLine>();
  for (int i = 0; i < numLines; i++) {
    Vec2D a = new Vec2D(width/2 + randomGaussian()*randomDist, height/2+randomGaussian()*randomDist);
    Vec2D dir = new Vec2D(1, 0).rotate(floor(random(angle+1)) * PI/angle);
    Vec2D b = a.copy().add(dir.scale(10));
    Line2D nl = new Line2D(a, b);

    boolean didCollide = didCollide(nl);
    if (!didCollide) {
      lines.add(new MLine(nl));
    }
  }
}

void drawThing() {
  for (MLine ml : lines) {
    Line2D l = ml.line;
    if (debugPoints) {
      ellipse(l.a.x, l.a.y, 10, 10);
      ellipse(l.b.x, l.b.y, 10, 10);
    }
    line(l.a.x, l.a.y, l.b.x, l.b.y);
  }
}

class MLine {
  Line2D line;
  boolean done = false;

  MLine(Line2D l) {
    this.line = l;
  }
}

static class Utils
{
  static String timestamp()
  {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
  }
}
