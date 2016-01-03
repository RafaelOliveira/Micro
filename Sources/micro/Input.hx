package micro;

import kha.input.Keyboard;
import kha.Key;

class Input
{
	var keysHeld:Map<Int, Bool>;
	var keysPressed:Map<Int, Bool>;
	
	static var the:Input;
	
	public function new()
	{
		keysHeld = new Map<Int, Bool>();
		keysPressed = new Map<Int, Bool>();
		
		for (i in 0...6)
			keysHeld.set(i, false);
			
		var keyboard = Keyboard.get();
		keyboard.notify(keyDown, keyUp);
		
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
	
	public function update()
	{
		for (key in keysPressed.keys())
			keysPressed.remove(key);
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
}