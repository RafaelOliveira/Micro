package micro;

import kha.System;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.Scaler;
import kha.Image;
import kha.Color;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import kha.input.Surface;
import kha.Key;
import kha.Blob;
import kha.FastFloat;
import kha.math.Vector2;

using kha.graphics2.GraphicsExtension;

@:structInit
class InitOptions
{
	public var title:String;
	@:optional public var width:Null<Int>;
	@:optional public var height:Null<Int>;
	@:optional public var backbufferWidth:Null<Int>;
	@:optional public var backbufferHeight:Null<Int>;
	@:optional public var tileWidth:Null<Int>;
	@:optional public var tileHeight:Null<Int>;
	@:optional public var fps:Null<Float>;

	@:optional public var init:Void->Void;
	@:optional public var update:Void->Void;
	@:optional public var draw:Void->Void;
}

@:allow(micro.Region)
class Micro
{	
	public static var camera:Rect;
	
	public static var gameWidth:Int;
	public static var gameHeight:Int;

	public static var halfGameWidth:Int;
	public static var halfGameHeight:Int;

	static var the:Micro;

	var tileWidth:Int;
	var tileHeight:Int;

	var totalSprCol:Int;

	var mapLayers:Array<Array<Array<Int>>>;
	
	public var gameUpdate:Void->Void;
	public var gameDraw:Void->Void;

	var backbuffer:Image;
	var sprites:Image;

	var bmFont:Image;
	var bmFontWidth:Int;
	var bmFontHeight:Int;

	var g2:Graphics;

	var keysHeld:Map<Int, Bool>;
	var keysPressed:Map<Int, Bool>;
	
	var touchsHeld:Map<Int, Touch>;
	var touchsPressed:Map<Int, Touch>;

	var shakeTime:Float = 0;
	var shakeMagnitude:Int = 0;
	var shakeX:Int = 0;
	var shakeY:Int = 0;

	var fixedDt:Float;	

	public function new(?options:InitOptions, callback:Void->Void):Void
	{
		the = this;	

		if (options == null)
			options = { title: 'Project' };

		if (options.width == null)
			options.width = 512;

		if (options.height == null)
			options.height = 512;

		System.init({ title: options.title, width: options.width, height: options.height }, function() {
			Assets.loadEverything(function() init(options, callback));
		});
	}

	function init(options:InitOptions, callback:Void->Void):Void
	{
		gameWidth = options.backbufferWidth != null ? options.backbufferWidth : 128;
		gameHeight = options.backbufferHeight != null ? options.backbufferHeight : 128;
		halfGameWidth = Std.int(options.backbufferWidth / 2);
		halfGameHeight = Std.int(options.backbufferHeight / 2);

		tileWidth = options.tileWidth != null ? options.tileWidth : 8;
		tileHeight = options.tileHeight != null ? options.tileHeight : 8;

		backbuffer = Image.createRenderTarget(gameWidth, gameHeight);
		g2 = backbuffer.g2;

		camera = new Rect(0, 0, gameWidth, gameHeight);

		keysHeld = new Map<Int, Bool>();
		keysPressed = new Map<Int, Bool>();
		
		touchsHeld = new Map<Int, Touch>();
		touchsPressed = new Map<Int, Touch>();

		for (i in 0...6)
			keysHeld.set(i, false);
			
		var keyboard = Keyboard.get();
		keyboard.notify(keyDown, keyUp);
		
		#if !flash
		var surface = Surface.get();
		surface.notify(touchStart, touchEnd, touchMove);
		#end

		if (options.fps == null)
			options.fps = 60;

		fixedDt = 1 / options.fps;				

		callback();				
	}

	public static function start(gameUpdate:Void->Void, gameDraw:Void->Void):Void
	{
		if (gameUpdate != null)
		{
			the.gameUpdate = gameUpdate;
			Scheduler.addTimeTask(the.update, 0, the.fixedDt);
		}

		if (gameDraw != null)
		{
			the.gameDraw = gameDraw;
			System.notifyOnRender(the.draw);
		}
	}

	function update():Void
	{		
		gameUpdate();
		inputUpdate();
		updateScreenShake();
	}

	function inputUpdate():Void
	{
		for (key in keysPressed.keys())
			keysPressed.remove(key);
			
		for (key in touchsPressed.keys())
			touchsPressed.remove(key);
	}

	function updateScreenShake():Void
	{
		if (shakeTime > 0)
		{
			var sx:Int = Std.random(shakeMagnitude * 2 + 1) - shakeMagnitude;
			var sy:Int = Std.random(shakeMagnitude * 2 + 1) - shakeMagnitude;

			camera.x += sx - shakeX;
			camera.y += sy - shakeY;

			shakeX = sx;
			shakeY = sy;

			shakeTime -= fixedDt;
			if (shakeTime < 0) 
				shakeTime = 0;
		}
		else if (shakeX != 0 || shakeY != 0)
		{
			camera.x -= shakeX;
			camera.y -= shakeY;
			shakeX = shakeY = 0;
		}
	}

	function draw(framebuffer:Framebuffer):Void
	{
		g2.begin(false);
		gameDraw();
		g2.end();

		framebuffer.g2.begin();		
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
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

	/*********** public api ***********/

	/**
	 * Set the image used as the spritesheet
	 */
	inline public static function setSprite(image:Image):Void
	{
		the.sprites = image;
		the.totalSprCol = Std.int(image.width / the.tileWidth);
	}

	/**
	 * Set the image used by the bitmapfont system
	 * The system uses a fixed size
	 * width: The width of the letters
	 * height: The height of the letters
	 */
	inline public static function setBmFont(font:Image, width:Int, height:Int):Void
	{
		the.bmFont = font;
		the.bmFontWidth = width;
		the.bmFontHeight = height;
	}

	public static function setMapFromPyxelEdit(mapFile:Blob):Void
	{	
		var width:Int = 0;
		var height:Int = 0;
		
		the.mapLayers = new Array<Array<Array<Int>>>();
		var layer:Array<Array<Int>>;		
		
		var lines = mapFile.toString().split('\n');
		
		for (i in 0...lines.length)
		{
			var line = StringTools.trim(lines[i]);
			
			if (line.length > 0)
			{
				var tokens = line.split(' ');
				
				switch(tokens[0])
				{
					case 'tileswide':					
						width = Std.parseInt(tokens[1]);
					case 'tileshigh':
						height = Std.parseInt(tokens[1]);
						
					case 'tilewidth':
					case 'tileheight':
						
					case 'layer':
						layer = new Array<Array<Int>>();
						
						for (y in (i + 1)...((i + 1) + height))
						{
							layer.push(new Array<Int>());
							
							var data = lines[y].split(',');
							
							for (x in 0...width)
								layer[layer.length - 1].push(Std.parseInt(data[x]));
						}
						
						the.mapLayers.push(layer);
				}
			}
		}					
	}

	public static function setMapFrom2DArray(array:Array<Array<Int>>, layer:Int = 0):Void
	{
		if (the.mapLayers == null)
			the.mapLayers = new Array<Array<Array<Int>>>();

		the.mapLayers[layer] = new Array<Array<Int>>();

		for (y in 0...array.length)
		{
			the.mapLayers[layer].push(new Array<Int>());
			
			for (x in 0...the.mapLayers[layer][y].length)			
				the.mapLayers[layer][y].push(array[y][x]);		
		}
	}

	public static function setMapFromString(str:String, columnSep:String = ',', rowSep:String = '\n', layer:Int = 0):Void
	{
		if (the.mapLayers == null)
			the.mapLayers = new Array<Array<Array<Int>>>();

		var row:Array<String> = str.split(rowSep);
		var	rows:Int = row.length;
		var	col:Array<String>;
		var cols:Int;
		var x:Int;
		var y:Int;

		the.mapLayers[layer] = new Array<Array<Int>>();

		for (y in 0...rows)
		{
			the.mapLayers[layer].push(new Array<Int>());
			
			if (row[y] == '') 
				continue;
			
			col = row[y].split(columnSep);
			cols = col.length;
			
			for (x in 0...cols)
			{
				if (col[x] != '')		
					the.mapLayers[layer][y].push(Std.parseInt(col[x]));
			}
		}
	}

	/**
	 * Set the screen's clipping region in pixels
	 */
	inline public static function clip(x:Int, y:Int, width:Int, height:Int):Void
	{
		the.g2.scissor(x, y, width, height);
	}

	/*
	 * Disable the screen clipping region
	 */
	inline public static function disableClip():Void
	{
		the.g2.disableScissor();
	}

	/**
	 * Set the color of a pixel at x, y
	 */
	inline public static function pset(x:Float, y:Float, color:Color):Void
	{
		the.g2.color = color;
		the.g2.drawLine(x, y, x + 1, y + 1);
	}
	
	/*
	 * Call this before start drawing inside the spritesheet with sset
	 */	
	inline public static function spStart():Void
	{
		the.sprites.g2.begin();	
	}

	/*
	 * Call this after drawing inside the spritesheet with sset
	 */
	inline public static function spEnd():Void
	{
		the.sprites.g2.end();
	}

	/**
	 * Set the color of a spritesheet pixel at x, y
	 */
	inline public static function sset(x:Int, y:Int, color:Color):Void
	{
		the.sprites.g2.color = color;
		the.sprites.g2.drawLine(x, y, x + 1, y + 1);
	}

	/**
	 * Print a string
	 */
	public static function bmPrint(str:String, x:Float, y:Float, color:Color = 0xffffffff):Void
	{
		var code:Int;
		var cursor = x;
		
		the.g2.color = color;
			
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
				
				the.g2.drawScaledSubImage(the.bmFont, code * the.bmFontWidth, 0, the.bmFontWidth, the.bmFontHeight, cursor - camera.x, y - camera.y, the.bmFontWidth, the.bmFontHeight);
			}
			
			cursor += the.bmFontWidth;
		}
	}	

	/** 
	 * Clear the screen 
	 */
	inline public static function cls(color:Color = 0xff000000):Void
	{		
		the.g2.clear(color);		
	}

	/** 
	 * Draw a circle at x,y with radius r 
	 */
	public static function circ(x:Float, y:Float, r:Float, color:Color):Void
	{
		the.g2.color = color;
		the.g2.drawCircle(x - camera.x, y - camera.y, r);
	}
	
	/**
	 * Draw a filled circle at x,y with radius r 
	 */
	public static function circfill(x:Float, y:Float, r:Float, color:Color):Void
	{
		the.g2.color = color;
		the.g2.fillCircle(x - camera.x, y - camera.y, r);
	}

	/** 
	 * Draw line 
	 */
	public static function line(x0:Float, y0:Float, x1:Float, y1:Float, color:Color):Void
	{
		the.g2.color = color;
		the.g2.drawLine(x0 - camera.x, y0 - camera.y, x1 - camera.x, y1 - camera.y);			
	}

	/**
	 * Draw a rectange 
	 */
	public static function rect(x:Float, y:Float, w:Int, h:Int, color:Color):Void
	{
		the.g2.color = color;
		the.g2.drawRect(x - camera.x, y - camera.y, w, h);
	}
	
	/** 
	 * Draw a filled rectange 
	 */
	public static function rectfill(x:Float, y:Float, w:Int, h:Int, color:Color):Void
	{
		the.g2.color = color;
		the.g2.fillRect(x - camera.x, y - camera.y, w, h);
	}
	
	public static function spr(n:Int, x:Float, y:Float, w:Int = 1, h:Int = 1, flipX:Bool = false, flipY:Bool = false, ?color:Color = 0xffffffff):Void
	{
		the.g2.color = color;
		
		if (w == 1 && h == 1)
			the.g2.drawScaledSubImage(the.sprites, (n % the.totalSprCol) * the.tileWidth, Std.int(n / the.totalSprCol) * the.tileHeight, the.tileWidth, the.tileHeight, 
			x - camera.x + (flipX ? the.tileWidth : 0), y - camera.y + (flipY ? the.tileHeight : 0), flipX ? -the.tileWidth : the.tileWidth, flipY ? -the.tileHeight : the.tileHeight);
		else
		{
			for (i in 0...w)
			{
				for (j in 0...h)
					the.g2.drawScaledSubImage(the.sprites, ((n % the.totalSprCol) * the.tileWidth) + (i * the.tileWidth), (Std.int(n / the.totalSprCol) * the.tileHeight) + (j * the.tileHeight),
					the.tileWidth, the.tileHeight, x + (i * the.tileWidth) - camera.x, y + (j * the.tileHeight) - camera.y, flipX ? -the.tileWidth : the.tileWidth,
					flipY ? -the.tileHeight : the.tileHeight);
			}
		}
	}

	public static function sspr(sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float, dw:Null<Float> = null, dh:Null<Float> = null, flipX:Bool = false, flipY:Bool = false, ?color:Color = 0xffffffff):Void
	{
		if (dw == null)
			dw = sw;

		if (dh == null)
			dh = sh;

		the.g2.color = color;

		the.g2.drawScaledSubImage(the.sprites, sx, sy, sw, sh, dx - camera.x, dy - camera.y, flipX ? -dw : dw, flipY ? -dh : dh);
	}

	/** 
	 * Check if a button is being held 
	 */
	inline public static function btn(id:Int):Bool
	{
		return the.keysHeld.get(id);
	}

	/**
	 * Check if a button was pressed 
	 */
	inline public static function btnp(id:Int):Bool
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
	 * Get a tile id
	 */
	inline public static function mget(x:Int, y:Int, layer:Int = 0):Int
	{
		return the.mapLayers[layer][y][x];
	}

	/**
	 * Set a tile id
	 */
	inline public static function mset(x:Int, y:Int, value:Int, layer:Int = 0):Void
	{
		the.mapLayers[layer][y][x] = value;
	}

	/**
	 * Draw a portion of the map
	 */
	public static function drawMap(x:Float, y:Float, sx:Int, sy:Int, sw:Int, sh:Int, layer:Int = 0, color:Color = 0xffffffff):Void
	{
		var tx = 0;
		var ty = 0;
		
		the.g2.color = color;
		
		for (j in sy...(sy + sh))
		{
			for (i in sx...(sx + sw))
			{
				if (the.mapLayers[layer][j][i] > -1)
				{
					var id = the.mapLayers[layer][j][i];
					
					the.g2.drawScaledSubImage(the.sprites, (id % the.totalSprCol) * the.tileWidth, Std.int(id / the.totalSprCol) * the.tileHeight, the.tileWidth, the.tileHeight, 
						x + (tx * the.tileWidth) - camera.x, y + (ty * the.tileHeight) - camera.y, the.tileWidth, the.tileHeight);
				}
					
				tx++;
			}
			
			tx = 0;
			ty++;
		}
	}

	/**
	 * Draw a portion of the map with just one tile	 
	 */
	public static function drawMapWithTile(n:Int, x:Float, y:Float, sx:Int, sy:Int, sw:Int, sh:Int, layer:Int = 0, color:Color = 0xffffffff):Void
	{
		var tx = 0;
		var ty = 0;
		
		the.g2.color = color;
		
		for (j in sy...(sy + sh))
		{
			for (i in sx...(sx + sw))
			{
				if (the.mapLayers[layer][j][i] > -1)					
					the.g2.drawScaledSubImage(the.sprites, (n % the.totalSprCol) * the.tileWidth, Std.int(n / the.totalSprCol) * the.tileHeight, the.tileWidth, the.tileHeight, 
						x + (tx * the.tileWidth) - camera.x, y + (ty * the.tileHeight) - camera.y, the.tileWidth, the.tileHeight);	
				tx++;
			}
			
			tx = 0;
			ty++;
		}
	}

	/**
	 * Set the opacity of the drawing functions
	 */
	inline public static function opacity(value:Float):Void
	{
		the.g2.pushOpacity(value);
	}

	/**
	 * Disable the opacity
	 */
	inline public static function disableOpacity():Void
	{
		the.g2.popOpacity();
	}

	/**
	 * Start the rotation
	 */
	inline public static function startRot(angle:FastFloat, centerx:FastFloat, centery:FastFloat):Void
	{
		the.g2.pushRotation(angle, centerx, centery);
	}
	
	/**
	 * End the rotation
	 */
	inline public static function endRot():Void
	{
		the.g2.popTransformation();
	}
	
	/**
	 * The value of PI
	 */
	public static var PI(get, null):Float;
	inline static function get_PI():Float 
	{
		return Math.PI;
	}
	
	/**
	 * Converts a float to int
	 */
	inline public static function int(x:Float):Int
	{
		return Std.int(x);	
	}
	
	/**
	 * Returns the minimum
	 */
	inline public static function min(a:Float, b:Float):Float
	{
		return Math.min(a, b);
	}
	
	/**
	 * Returns the maximum
	 */
	inline public static function max(a:Float, b:Float):Float
	{
		return Math.max(a, b);
	}
		
	/**
	 * Returns a random float value, between 0 and x
	 */
	inline public static function rnd(x:Float):Float
	{
		return Math.random() * x;
	}
	
	/**
	 * Returns a random integer value, between 0 and x
	 */
	inline public static function rndi(x:Float):Int
	{
		return Std.int(Math.random() * x);
	}
	
	/**
	 * Returns the sine of x
	 */
	inline public static function sin(x:Float):Float
	{
		return Math.sin(x);
	}
	
	/**
	 * Returns the cosine of x
	 */
	inline public static function cos(x:Float):Float
	{
		return Math.cos(x);
	}

	/**
	 * Returns the closest integer below x
	 */
	inline public static function flr(x:Float):Float
	{
		return Math.floor(x);
	}

	/**
	 * Change a variable in the direction of zero, using a amount
	 */
	public static function toZero(variable:Float, amount:Float):Float
	{
		if (variable < 0)
		{
			variable += amount;
			if (variable > 0)
				variable = 0;
		}
		else
		{
			variable -= amount;
			if (variable < 0)
				variable = 0;
		}

		return variable;
	}
	
	/**
	 * Distance between two points
	 */
	inline public static function distance(x1:Float, y1:Float, x2:Float = 0, y2:Float = 0):Float
	{
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
	}
	
	/**
	 * Check if two rectangles collides using separated variables
	 */
	public static function collision(x0:Float, y0:Float, w0:Int, h0:Int, x1:Float, y1:Float, w1:Int, h1:Int):Bool
	{
		var a: Bool;
		var b: Bool;
		
		if (x0 < x1) a = x1 < x0 + w0;
		else a = x0 < x1 + w1;
		
		if (y0 < y1) b = y1 < y0 + h0;
		else b = y0 < y1 + h1;
		
		return a && b;
	}

	/**
	 * Shake the screen
	 */
	public static function shake(magnitude:Int, duration:Float):Void
	{
		if (the.shakeTime < duration) 
			the.shakeTime = duration;

		the.shakeMagnitude = magnitude;
	}

	/**
	 * Stop the shake
	 */
	public static function shakeStop():Void
	{
		the.shakeTime = 0;
	}
	 
	public static function moveBy(x:Float, y:Float, width:Int, height:Int, delta:Vector2, rects:Array<Rect>):Bool
	{
		// used to check the collision with a rectangle 
		var collided:Bool = false;

		// used to check if a collision happened with all the rectangles
		var gbCollision:Bool = false;

		for (rect in rects)
		{
			do 
			{
				collided = false;

				if (collision(x + delta.x, y, width, height, rect.x, rect.y, rect.width, rect.height))
				{
					delta.x = toZero(delta.x, 1);
					collided = true;
					gbCollision = true;
				}

				if (collision(x, y + delta.y, width, height, rect.x, rect.y, rect.width, rect.height))
				{
					delta.y = toZero(delta.y, 1);
					collided = true;
					gbCollision = true;
				}
			}
			while (collided);
		}		

		return gbCollision;
	}	
}