package micro;

import kha.input.Keyboard;
import kha.input.Surface;
import kha.Key;

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

class Input
{
	var keysHeld:Map<Int, Bool>;
	var keysPressed:Map<Int, Bool>;
	
	var touchsHeld:Map<Int, Touch>;
	var touchsPressed:Map<Int, Touch>;
	
	static var the:Input;
	
	public function new()
	{
		keysHeld = new Map<Int, Bool>();
		keysPressed = new Map<Int, Bool>();
		
		touchsHeld = new Map<Int, Touch>();
		touchsPressed = new Map<Int, Touch>();
		
		for (i in 0...6)
			keysHeld.set(i, false);
			
		var k = Keyboard.get();
		k.notify(keyDown, keyUp);
		
		var t = Surface.get();
		t.notify(touchStart, touchEnd, touchMove);
		
		the = this;
	}
	
	function keyDown(key:Key, char:String)
	{
		switch(key)
		{
			case Key.LEFT:
				keysHeld.set(0, true);
				keysPressed.set(0, true);
			
			case Key.RIGHT:
				keysHeld.set(1, true);
				keysPressed.set(1, true);
			
			case Key.UP:
				keysHeld.set(2, true);
				keysPressed.set(2, true);
			
			case Key.DOWN:
				keysHeld.set(3, true);
				keysPressed.set(3, true);
			
			default:
				if (char == 'z' || char == 'Z')
				{
					keysHeld.set(4, true);
					keysPressed.set(4, true);
				}
				else if (char == 'x' || char == 'X')
				{
					keysHeld.set(5, true);
					keysPressed.set(5, true);
				}
		}
	}
	
	function keyUp(key:Key, char:String)
	{
		switch(key)
		{
			case Key.LEFT:
				keysHeld.set(0, false);
			
			case Key.RIGHT:
				keysHeld.set(1, false);
			
			case Key.UP:
				keysHeld.set(2, false);
			
			case Key.DOWN:
				keysHeld.set(3, false);
			
			default:
				if (char == 'z' || char == 'Z')
					keysHeld.set(4, false);
				else if (char == 'x' || char == 'X')
					keysHeld.set(5, false);
		}
	}
	
	function touchStart(index:Int, x:Int, y:Int):Void
	{
		var th = touchsHeld.get(index);
		var tp = touchsPressed.get(index);
		
		if (th == null)
			th = new Touch(x, y, true);
		else
		{
			th.x = x;
			th.y = y;
			th.on = true;
		}
		
		if (tp == null)
			tp = new Touch(x, y, true);
		else
		{
			tp.x = x;
			tp.y = y;
			tp.on = true;
		}
		
		touchsHeld.set(index, th);
		touchsPressed.set(index, tp);
	}
	
	function touchEnd(index:Int, x:Int, y:Int):Void
	{
		var th = touchsHeld.get(index);
		
		th.x = x;
		th.y = y;
		th.on = false;
		
		touchsHeld.set(index, th);
	}
	
	function touchMove(index:Int, x:Int, y:Int):Void
	{
		var th = touchsHeld.get(index);
		
		th.x = x;
		th.y = y;
		th.on = false;
		
		touchsHeld.set(index, th);
	}
	
	public function update()
	{
		for (key in keysPressed.keys())
			keysPressed.remove(key);
			
		for (key in touchsPressed.keys())
			touchsPressed.remove(key);
	}
	
	/** 
	 * Check if a button is being held 
	 */
	public static function btn(id:Int):Bool
	{
		return the.keysHeld.get(id);
	}
	
	/**
	 * Check if a button was pressed 
	 */
	public static function btnp(id:Int):Bool
	{		
		return the.keysPressed.exists(id);		
	}
	
	/** 
	 * Check if a touch is being held 
	 */
	public static function touch(id:Int):Touch
	{		
		var th = the.touchsHeld.get(id);
		
		if (th == null)
		{
			th = new Touch(0, 0, false);
			the.touchsHeld.set(id, th);
		}
		
		return th;
	}
	
	/**
	 * Check if a touch was pressed 
	 */
	public static function touchp(id:Int):Touch
	{		
		var tp = the.touchsPressed.get(id);
		
		if (tp == null)
			tp = new Touch(0, 0, false);
		
		return tp;
	}
	
	/**
	 * Check if a touch of any id was pressed 
	 */
	/*public static function touchpAny():Bool
	{		
		return the.touchsPressed.keys().hasNext();
	}*/
}