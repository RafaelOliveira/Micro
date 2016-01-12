package micro;

import kha.Color;
import kha.Image;

class Tileset
{
	var image:Image;	
	var sx:Int;
	var sy:Int;
	public var width:Int;
	public var height:Int;
	
	var totalSprCol:Int;
	public var tileWidth:Int;
	public var tileHeight:Int;	
	
	public function new(image:Image, sx:Int, sy:Int, width:Int, height:Int, tileWidth:Int, ?tileHeight:Int) 
	{
		this.image = image;
		this.sx = sx;
		this.sy = sy;
		this.width = width;
		this.height = height;
		
		this.tileWidth = tileWidth;
		
		if (tileHeight != null)
			this.tileHeight = tileHeight;
		else
			this.tileHeight = tileWidth;
				
		totalSprCol = Std.int(width / tileWidth);
	}	
	
	/** Draw a tile in only one position. Used mostly for maps. */
	inline public function drawOne(id:Int, x:Float, y:Float):Void
	{
		//Draw.g2.color = Color.White;
		Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileWidth), sy + (Std.int(id / totalSprCol) * tileHeight), tileWidth, tileHeight, 
								  x - Micro.camera.x, y - Micro.camera.y, tileWidth, tileHeight);
	}
	
	/** Draw a tile */
	public function draw(id:Int, x:Float, y:Float, w:Int = 1, h:Int = 1, flip_x:Bool = false, flip_y:Bool = false, ?color:Color = -1):Void
	{
		Draw.g2.color = color;
		
		if (w == 1 && h == 1)
			Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileWidth), sy + (Std.int(id / totalSprCol) * tileHeight), tileWidth, tileHeight, 
			x - Micro.camera.x + (flip_x ? tileWidth : 0), y - Micro.camera.y + (flip_y ? tileHeight : 0), flip_x ? -tileWidth : tileWidth, flip_y ? -tileHeight : tileHeight);
		else
		{
			for (i in 0...w)
			{
				for (j in 0...h)
					Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileWidth) + (i * tileWidth), sy + (Std.int(id / totalSprCol) * tileHeight) + (j * tileHeight),
					tileWidth, tileHeight, x + (i * tileWidth) - Micro.camera.x, y + (j * tileHeight) - Micro.camera.y, flip_x ? -tileWidth : tileWidth,
					flip_y ? -tileHeight : tileHeight);
			}
		}
	}
	
	/** Draw a region of the tileset scaled */
	public function sdraw(sx:Int, sy:Int, sw:Int, sh:Int, x:Float, y:Float, ?w:Float, ?h:Float, ?flip_x:Bool, ?flip_y:Bool, ?color:Color = -1):Void
	{
		Draw.g2.color = color;
			
		if (w == null)
			w = sw;
			
		if (h == null)
			h = sh;
			
		Draw.g2.drawScaledSubImage(image, sx, sy, sw, sh, x + (flip_x ? w : 0), y + (flip_y ? h : 0), flip_x ? -w : w, flip_y ? -h : h);
	}
}