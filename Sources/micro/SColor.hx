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
			default: palette = [Color.Black, Color.fromValue(0xff1d2b53), Color.fromValue(0xff7e2553), Color.fromValue(0xff008751), 
								Color.fromValue(0xffab5236), Color.fromValue(0xff5f574f), Color.fromValue(0xffc2c3c7), Color.fromValue(0xfffff1e8),
								Color.fromValue(0xffff004d), Color.fromValue(0xffffa300), Color.fromValue(0xfffff024), Color.fromValue(0xff00e756),
								Color.fromValue(0xff29adff), Color.fromValue(0xff83769c), Color.fromValue(0xffff77a8), Color.fromValue(0xffffccaa)];
		}
	}
}