package micro;

import kha.Color;
import kha.Image;

class Tileset extends Region
{	
	var totalSprCol:Int;
	
	public var tileWidth:Int;
	public var tileHeight:Int;	
	
	public function new(image:Image, sx:Int, sy:Int, width:Int, height:Int, tileWidth:Int, ?tileHeight:Int) 
	{
		super(image, sx, sy, width, height);		
		
		this.tileWidth = tileWidth;
		
		if (tileHeight != null)
			this.tileHeight = tileHeight;
		else
			this.tileHeight = tileWidth;
				
		totalSprCol = Std.int(width / tileWidth);
	}
	
	/**
	 * Create a tileset from a region
	 */
	public static function createFromReg(reg:Region, tileWidth:Int, ?tileHeight:Int):Tileset
	{
		return new Tileset(reg.image, reg.sx, reg.sy, reg.width, reg.height, tileWidth, tileHeight);
	}
	
	/** 
	 * Draw a tile in only one position. Used mostly for maps. 
	 */
	inline public function drawOne(id:Int, x:Float, y:Float):Void
	{
		//Draw.g2.color = Color.White;
		Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileWidth), sy + (Std.int(id / totalSprCol) * tileHeight), tileWidth, tileHeight, 
								  x - Micro.camera.x, y - Micro.camera.y, tileWidth, tileHeight);
	}
	
	/**
	 * Draw a tile 
	 */
	public function drawTile(id:Int, x:Float, y:Float, w:Int = 1, h:Int = 1, flipX:Bool = false, flipY:Bool = false, ?color:Color = 0xffffffff):Void
	{
		Draw.g2.color = color;
		
		if (w == 1 && h == 1)
			Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileWidth), sy + (Std.int(id / totalSprCol) * tileHeight), tileWidth, tileHeight, 
			x - Micro.camera.x + (flipX ? tileWidth : 0), y - Micro.camera.y + (flipY ? tileHeight : 0), flipX ? -tileWidth : tileWidth, flipY ? -tileHeight : tileHeight);
		else
		{
			for (i in 0...w)
			{
				for (j in 0...h)
					Draw.g2.drawScaledSubImage(image, sx + ((id % totalSprCol) * tileWidth) + (i * tileWidth), sy + (Std.int(id / totalSprCol) * tileHeight) + (j * tileHeight),
					tileWidth, tileHeight, x + (i * tileWidth) - Micro.camera.x, y + (j * tileHeight) - Micro.camera.y, flipX ? -tileWidth : tileWidth,
					flipY ? -tileHeight : tileHeight);
			}
		}
	}	
}