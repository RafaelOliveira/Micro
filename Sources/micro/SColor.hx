package micro;

import kha.Color;

class SColor
{
	static var palette:Array<Color>;
	
	public static var transpColor = Color.fromValue(0x00000000);
	
	/**
	 * Get a color from the custom palette
	 */
	inline public static function pal(id:Int):Color
	{		
		return palette[id];		
	}
	
	/** 
	 * Load a custom palette
	 * 0: Pico-8 palette
	 */
	public static function loadPal(id:Int)
	{
		switch(id)
		{
			default: palette = [Color.Black, Color.fromValue(0xff161e42), Color.fromValue(0xff6b1442), Color.fromValue(0xff03783e), 
				  Color.fromValue(0xff9b3e26), Color.fromValue(0xff4d453e), Color.fromValue(0xffb5b6bb), Color.fromValue(0xffffeee2),
				  Color.fromValue(0xffff0039), Color.fromValue(0xffff9300), Color.fromValue(0xffffff00), Color.fromValue(0xff0bea3c),
				  Color.fromValue(0xff1c98ff), Color.fromValue(0xff70608b), Color.fromValue(0xffff5a97), Color.fromValue(0xffffc197)];
		}
	}
}