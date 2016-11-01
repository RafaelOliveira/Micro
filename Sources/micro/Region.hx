package micro;

import kha.Color;

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
}