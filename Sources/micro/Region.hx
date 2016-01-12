package micro;

import kha.Color;
import kha.Image;

class Region
{
	public var image:Image;	
	public var sx:Int;
	public var sy:Int;
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
	
	inline public function draw(x:Float, y:Float, ?color:Color = -1):Void
	{
		Draw.g2.color = color;		
		Draw.g2.drawScaledSubImage(image, sx, sy, width, height, x, y, width, height);
	}
}