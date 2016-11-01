package micro;

class Touch 
{
	public var x:Float;
	public var y:Float;
	public var on:Bool;
	
	public function new(x:Float, y:Float, on:Bool)
	{
		this.x = x;
		this.y = y;
		this.on = on;
	}
}