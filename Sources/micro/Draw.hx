package micro;

import kha.Assets;
import kha.Color;
import kha.Image;

using kha.graphics2.GraphicsExtension;

class Draw
{
	public static var backbuffer:Image;	
	
	/** Kha's pixel context */
	public static var g1:kha.graphics1.Graphics;
	
	/** Kha's 2d context */
	public static var g2:kha.graphics2.Graphics;
	
	var font:Image;
	
	static var the:Draw;
	
	public function new(width:Int, height:Int)
	{
		backbuffer = Image.createRenderTarget(width, height);
		
		g1 = backbuffer.g1;
		g2 = backbuffer.g2;		
		
		the = this;
	}
	
	inline public static function loadBmFont(name:String):Void
	{
		the.font = Reflect.field(Assets.images, name);
	}
	
	/** Clear the screen */
	public static function cls(?color:Color):Void
	{
		if (color != null)
			g2.clear(color);
		else
			g2.clear(Color.Black);
	}
	
	public static function bmString(str:String, x:Float, y:Float, ?color:Color = -1):Void
	{
		var code:Int;
		var cursor = x;
		
		g2.color = color;
			
		str = str.toUpperCase();
		
		for (i in 0...str.length)
		{
			if (str.charAt(i) != ' ')
			{
				code = str.charCodeAt(i);
				if (code < 96)
					code -= 33;
				else if (code > 122)
					code -= 60;				
				
				g2.drawScaledSubImage(the.font, code * 4, 0, 4, 5, cursor - Micro.camera.x, y - Micro.camera.y, 4, 5);
			}
			
			cursor += 4;
		}
	}
	
	/** Call this before draw pixels */
	public static function begp():Void
	{
		g2.end();
		g1.begin();
	}
	
	/** Call this after draw pixels */
	public static function endp():Void
	{
		g1.end();
		g2.begin(true, SColor.transpColor);
	}
	
	/** Get the color of a pixel at x, y */
	public static function pget(x:Int, y:Int):Color
	{
		return backbuffer.at(Std.int(x - Micro.camera.x), Std.int(y - Micro.camera.y));
	}
	
	/** Set the color of a pixel at x, y */
	public static function pset(x:Int, y:Int, color:Color):Void
	{
		g1.setPixel(Std.int(x - Micro.camera.x), Std.int(y - Micro.camera.y), color);
	}
	
	/** Draw line */
	public static function line(x0:Float, y0:Float, x1:Float, y1:Float, color:Color):Void
	{
		g2.color = color;
		g2.drawLine(x0 - Micro.camera.x, y0 - Micro.camera.y, x1 - Micro.camera.x, y1 - Micro.camera.y);			
	}
	
	/** Draw a rectange */
	public static function rect(x:Float, y:Float, w:Int, h:Int, color:Color):Void
	{
		g2.color = color;
		g2.drawRect(x - Micro.camera.x, y - Micro.camera.y, w, h);
	}
	
	/** Draw a filled rectange */
	public static function rectfill(x:Float, y:Float, w:Int, h:Int, color:Color):Void
	{
		g2.color = color;
		g2.fillRect(x - Micro.camera.x, y - Micro.camera.y, w, h);
	}	
	
	/** Draw a circle at x,y with radius r */
	public static function circ(x:Float, y:Float, r:Float, color:Color):Void
	{
		g2.color = color;
		g2.drawCircle(x - Micro.camera.x, y - Micro.camera.y, r);
	}
	
	/** Draw a filled circle at x,y with radius r */
	public static function circfill(x:Float, y:Float, r:Float, color:Color):Void
	{
		g2.color = color;
		g2.fillCircle(x - Micro.camera.x, y - Micro.camera.y, r);
	}
}