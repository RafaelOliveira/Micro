package micro;

class Micro
{
	/** The time passed since the last frame */
	public static var elapsed:Float = 0;

	public static var camera = new Camera();
	
	public static var gameWidth:Int;
	public static var gameHeight:Int;
	public static var halfGameWidth:Int;
	public static var halfGameHeight:Int;
	
	inline public static function int(x:Float):Int
	{
		return Std.int(x);	
	}
	
	inline public static function min(a:Float, b:Float):Float
	{
		return Math.min(a, b);
	}
	
	inline public static function max(a:Float, b:Float):Float
	{
		return Math.max(a, b);
	}
	
	inline public static function rnd(x:Float):Float
	{
		return Math.random() * x;
	}
	
	public static function rectCollision(x0:Float, y0:Float, w0:Int, h0:Int, x1:Float, y1:Float, w1:Int, h1:Int):Bool
	{
		var a: Bool;
		var b: Bool;
		
		if (x0 < x1) a = x1 < x0 + w0;
		else a = x0 < x1 + w1;
		
		if (y0 < y1) b = y1 < y0 + h0;
		else b = y0 < y1 + h1;
		
		return a && b;
	}
}