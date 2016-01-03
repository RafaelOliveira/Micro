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
	public var tileSize:Int;
	
	public function new(image:Image, sx:Int, sy:Int, width:Int, height:Int, tileSize:Int) 
	{
		this.image = image;
		this.sx = sx;
		this.sy = sy;
		this.width = width;
		this.height = height;
		
		this.tileSize = tileSize;
		totalSprCol = Std.int(width / tileSize);
	}	
	
	/** Draw a tile in only one position. Used mostly for maps. */
	inline public function drawOne(id:Int, x:Float, y:Float):Void
	{
		Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileSize), sy + (Std.int(id / totalSprCol) * tileSize), tileSize, tileSize, 
								  x - Micro.camera.x, y - Micro.camera.y, tileSize, tileSize);
	}
	
	/** Draw a tile */
	public function draw(id:Int, x:Float, y:Float, w:Int = 1, h:Int = 1, flip_x:Bool = false, flip_y:Bool = false, ?color:Color):Void
	{
		if (color != null)
			Draw.g2.color = color;
		else
			Draw.g2.color = Draw.color;
		
		if (w == 1 && h == 1)
			Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileSize), sy + (Std.int(id / totalSprCol) * tileSize), tileSize, tileSize, 
								  x - Micro.camera.x, y - Micro.camera.y, flip_x ? -tileSize : tileSize, flip_y ? -tileSize : tileSize);
		else
		{
			for (i in 0...w)
			{
				for (j in 0...h)
					Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileSize), sy + (Std.int(id / totalSprCol) * tileSize), tileSize, tileSize, 
										  x + (i * tileSize) - Micro.camera.x, y + (j * tileSize) - Micro.camera.y, flip_x ? -tileSize : tileSize,
										  flip_y ? -tileSize : tileSize);
			}
		}
	}
	
	public function mdraw(sx:Int, sy:Int, sw:Int, sh:Int, x:Float, y:Float, ?w:Float, ?h:Float, ?flip_x:Bool, ?flip_y:Bool, ?color:Color):Void
	{
		if (color != null)
			Draw.g2.color = color;
		else
			Draw.g2.color = Draw.color;
			
		if (w == null)
			w = sw * tileSize;
			
		if (h == null)
			h = sh * tileSize;
			
		for (i in sx...(sx + sw))
		{
			for (j in sy...(sy + sh))
				Draw.g2.drawScaledSubImage(image, this.sx + (sx * tileSize), this.sy + (sy * tileSize), sw * tileSize, sh * tileSize, x, y,
										   flip_x ? -w : w, flip_y ? -h : h);
		}
	}
}