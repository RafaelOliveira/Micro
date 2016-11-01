package micro;

import kha.Color;
import kha.FastFloat;
import kha.Image;

class Region
{
	var sx:Int;
	var sy:Int;		
	public var width:Int;
	public var height:Int;	
	
	public function new(sx:Int, sy:Int, width:Int, height:Int)
	{		
		this.sx = sx;
		this.sy = sy;
		this.width = width;
		this.height = height;		
	}	
	
	/** 
	 * Draw the image 
	 */
	inline public function draw(x:Float, y:Float, flipX:Bool = false, flipY:Bool = false, color:Color = 0xffffffff):Void
	{
		Micro.the.g2.color = color;
		Micro.the.g2.drawScaledSubImage(Micro.the.sprites, sx, sy, width, height, x - Micro.camera.x + (flipX ? width : 0),
								   y - Micro.camera.y + (flipY ? height : 0), flipX ? -width : width, flipY ? -height : height);
	}
	
	/**
	 * Draw a region of the image scaled 
	 */
	public function sdraw(sx:Int, sy:Int, sw:Int, sh:Int, x:Float, y:Float, w:Null<Float> = null, h:Null<Float> = null, flipX:Bool = false, flipY:Bool = false, color:Color = 0xffffffff):Void
	{
		Micro.the.g2.color = color;
			
		if (w == null)
			w = sw;
			
		if (h == null)
			h = sh;
			
		Micro.the.g2.drawScaledSubImage(Micro.the.sprites, sx, sy, sw, sh, x + (flipX ? w : 0) - Micro.camera.x, y + (flipY ? h : 0) - Micro.camera.y, flipX ? -w : w, flipY ? -h : h);
	}	
}