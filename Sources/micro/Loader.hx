package micro;

import kha.Assets;
import kha.Blob;
import kha.Image;

class Loader
{	
	var regions:Map<String, Region>;
	var tilesets:Map<String, Tileset>;
	var maps:Map<String, SMap>;
	
	static var the:Loader;
	
	public function new() 
	{	
		regions = new Map<String, Region>();
		tilesets = new Map<String, Tileset>();
		maps = new Map<String, SMap>();
		
		the = this;
	}
	
	public static function loadAtlas()
	{			
		var raw:Blob = Reflect.field(Assets.blobs, 'resources_json');
		var data = haxe.Json.parse(raw.toString());
		
		var img:Image = Reflect.field(Assets.images, 'atlas');
		
		var frames = cast(data.frames, Array<Dynamic>);
		
		for (item in frames)
		{
			var reg = new Region(img, item.frame.x, item.frame.y, item.frame.w, item.frame.h);
			the.regions.set(item.filename, reg);
		}
	}
	
	public static function getReg(name:String):Region
	{
		var reg = the.regions.get(name);
		
		if (reg == null)
		{
			var image:Image = Reflect.field(Assets.images, name);
			reg = new Region(image, 0, 0, image.width, image.height);
			the.regions.set(name, reg);
		}
		
		return reg;
	}
	
	public static function getTileset(name:String, tileSize:Int):Tileset
	{
		var tileset = the.tilesets.get(name);
		
		if (tileset == null)
		{
			var reg = getReg(name);
			
			if (reg != null)
				tileset = new Tileset(reg.image, reg.sx, reg.sy, reg.width, reg.height, tileSize);
			else
			{
				var image:Image = Reflect.field(Assets.images, name);
				tileset = new Tileset(image, 0, 0, image.width, image.height, tileSize);
			}
			
			the.tilesets.set(name, tileset);
		}
		
		return tileset;
	}
	
	public static function getSMap(name:String, ?tileset:Tileset):SMap
	{
		var map = the.maps.get(name);
				
		if (map == null)
		{
			map = the.parseSMap(name);
			the.maps.set(name, map);		
		}
		
		if (tileset != null)
			map.tileset = tileset;
		
		return map;
	}
	
	function parseSMap(name:String):SMap
	{	
		var width:Int = 0;
		var height:Int = 0;
		
		var layers = new Array<Array<Array<Int>>>();
		var layer:Array<Array<Int>>;		
		
		var rawMap:Blob = Reflect.field(Assets.blobs, name);
		
		var lines = rawMap.toString().split('\n');
		
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
						
						layers.push(layer);						
				}				
			}
		}
		
		return new SMap(layers);		
	}
}