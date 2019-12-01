/**
 * Implements a screen tile exporter with support for FOV,
 * clip planes and flexible file formats.
 * 
 * Re-engineered from an older version by Marius Watz:
 * http://workshop.evolutionzone.com/unlekkerlib/
 *
 * @author toxi <info at postspectacular dot com>
 */
class Tiler {
  protected PGraphics3D gfx;
  protected PImage buffer;
  protected Vec2D[] tileOffsets;
  protected double top;
  protected double bottom;
  protected double left;
  protected double right;
  protected Vec2D tileSize;

  protected int numTiles;
  protected int tileID;
  protected float subTileID;

  protected boolean isTiling;
  protected String fileName;
  protected String format;
  protected double cameraFOV;
  protected double cameraFar;
  protected double cameraNear;

  public Tiler(PGraphics3D g, int n) {
    gfx = g;
    numTiles = n;
  }

  public void chooseTile(int id) {
    Vec2D o = tileOffsets[id];
    gfx.frustum(o.x, o.x + tileSize.x, o.y, o.y + tileSize.y, 
    (float) cameraNear, (float) cameraFar);
  }

  public void initTiles(float fov, float near, float far) {
    tileOffsets = new Vec2D[numTiles * numTiles];
    double aspect = (double) gfx.width / gfx.height;
    cameraFOV = fov;
    cameraNear = near;
    cameraFar = far;
    top = Math.tan(cameraFOV * 0.5) * cameraNear;
    bottom = -top;
    left = aspect * bottom;
    right = aspect * top;
    int idx = 0;
    tileSize = new Vec2D((float) (2 * right / numTiles), (float) (2 * top / numTiles));
    double y = top - tileSize.y;
    while (idx < tileOffsets.length) {
      double x = left;
      for (int xi = 0; xi < numTiles; xi++) {
        tileOffsets[idx++] = new Vec2D((float) x, (float) y);
        x += tileSize.x;
      }
      y -= tileSize.y;
    }
  }

  public void post() {
    if (isTiling) {
      subTileID += 0.5;
      if (subTileID > 1) {
        int x = tileID % numTiles;
        int y = tileID / numTiles;
        gfx.loadPixels();
        buffer.set(x * gfx.width, y * gfx.height, gfx);
        if (tileID == tileOffsets.length - 1) 
        {
          buffer.save(fileName + "_" + buffer.width + "x"
            + buffer.height + "." + format);
          //	    buffer = null;
        }
        subTileID = 0;
        isTiling = (++tileID < tileOffsets.length);
      }
    }
  }

  public void pre() {
    if (isTiling) {
      chooseTile(tileID);
    }
  }

  public void save(String path, String baseName, String format) {
    (new File(path)).mkdirs();
    this.fileName = path + "/" + baseName;
    this.format = format;
    buffer = createImage(gfx.width * numTiles, gfx.height * numTiles, RGB);
    tileID = 0;
    subTileID = 0;
    isTiling = true;
  }

  public boolean isTiling() {
    return isTiling;
  }
} 

