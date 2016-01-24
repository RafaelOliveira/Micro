package micro;

import kha.Color;
import kha.FastFloat;
import kha.Image;

class Region
{
	var sx:Int;
	var sy:Int;
	public var image:Image;	
	public var width:Int;
	public var height:Int;	
	
	public function new(image:Image, sx:Int, sy:Int, width:Int, height:Int)
	{
		this.image = image;
		this.sx = sx;
		this.sy = sy;
		this.width = width;
		this.height = height;		
	}	
	
	/** 
	 * Draw the image 
	 */
	inline public function draw(x:Float, y:Float, flipX:Bool = false, flipY:Bool = false, ?color:Color = 0xffffffff):Void
	{
		Draw.g2.color = color;		
		Draw.g2.drawScaledSubImage(image, sx, sy, width, height, x - Micro.camera.x + (flipX ? width : 0),
								   y - Micro.camera.y + (flipY ? height : 0), flipX ? -width : width, flipY ? -height : height);
	}
	
	/**
	 * Draw a region of the image scaled 
	 */
	public function sdraw(sx:Int, sy:Int, sw:Int, sh:Int, x:Float, y:Float, ?w:Float, ?h:Float, ?flipX:Bool, ?flipY:Bool, ?color:Color = 0xffffffff):Void
	{
		Draw.g2.color = color;
			
		if (w == null)
			w = sw;
			
		if (h == null)
			h = sh;
			
		Draw.g2.drawScaledSubImage(image, sx, sy, sw, sh, x + (flipX ? w : 0), y + (flipY ? h : 0), flipX ? -w : w, flipY ? -h : h);
	}
	
	/**
	 * Start the rotation
	 */
	inline public function startRot(angle:FastFloat, centerx:FastFloat, centery:FastFloat):Void
	{
		Draw.g2.pushRotation(angle, centerx, centery);
	}
	
	/**
	 * End the rotation
	 */
	inline public function endRot():Void
	{
		Draw.g2.popTransformation();
	}
}