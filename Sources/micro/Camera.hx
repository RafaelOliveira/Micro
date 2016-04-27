package micro;

class Camera
{
	public var x:Float;
	public var y:Float;
	
	public function new() 
	{
		x = 0;
		y = 0;
	}
	
	inline public function reset()
	{
		x = 0;
		y = 0;
	}
}