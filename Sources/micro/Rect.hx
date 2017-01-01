package micro;

class Rect 
{
	/**
	 * Custom variable that can be used by the developer
	 */
	public var id:Int;
	/**
	 * Custom variable that can be used by the developer
	 */
	public var name:String;

	public var x: Float;
	public var y: Float;
	public var width: Int;
	public var height: Int;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0):Void 
    {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	
	public function setPos(x:Int, y:Int):Void 
    {
		this.x = x;
		this.y = y;
	}

	public function moveX(dx:Int):Void 
    {
		x += dx;
	}

	public function moveY(dy:Int):Void 
    {
		y += dy;
	}

	public function collision(rect:Rect):Bool 
    {
		var a: Bool;
		var b: Bool;

		if (x < rect.x) 
			a = rect.x < x + width;
		else 
			a = x < rect.x + rect.width;

		if (y < rect.y) 
			b = rect.y < y + height;
		else 
			b = y < rect.y + rect.height;

		return a && b;
	}
    
    public function pointInside(px:Float, py:Float):Bool
    {
        if (px > x && px < (x + width) && py > y && py < (y + height))
            return true;
        else
            return false;
    }

	public function rectInside(rect:Rect):Bool
	{
		if (rect.width <= width && rect.height <= height
			&& ((rect.x == x && rect.y == y) || (rect.x > x && (rect.x + rect.width) < (x + width) && (rect.y + rect.height) < (y + height))
		))
			return true;
		else
			return false;
	}
}