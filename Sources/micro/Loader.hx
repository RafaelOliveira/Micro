package micro;

import kha.Assets;
import kha.Blob;
import kha.Image;

class Loader
{	
	var atlases:Map<String, Atlas>;
	var regions:Map<String, Region>;
	var tilesets:Map<String, Tileset>;
	var maps:Map<String, SMap>;	
	
	static var the:Loader;
	
	public function new()
	{
		the = this;
	}
	
	public static function loadAtlas(name:String)
	{
		if (the.atlases == null)
			the.atlases = new Map<String, Atlas>();
			
		var atlas = the.atlases.get(name);
		
		if (atlas == null)
		{
			atlas = new Atlas(name);
			the.atlases.set(name, atlas);
		}
		
		return atlas;
	}
	
	public static function getReg(name:String, useCache:Bool = true):Region
	{
		var reg:Region = null;
		
		if (useCache)
		{
			if (the.regions == null)
				the.regions = new Map<String, Region>();
			
			reg = the.regions.get(name);
		}
		
		if (reg == null)
		{
			var image:Image = Reflect.field(Assets.images, name);
			
			if (image != null)
			{
				reg = new Region(image, 0, 0, image.width, image.height);
				
				if (useCache)
					the.regions.set(name, reg);
			}
			else
			{
				trace('Image $name for the region not found');
				return null;
			}
		}
		
		return reg;
	}
	
	public static function getTileset(name:String, tileWidth:Int, ?tileHeight:Int, useCache:Bool = true):Tileset
	{
		var tileset:Tileset = null;
		
		if (useCache)
		{
			if (the.tilesets == null)
				the.tilesets = new Map<String, Tileset>();
			
			tileset = the.tilesets.get(name);
		}
		
		if (tileset == null)
		{
			var reg = getReg(name);
			
			if (reg != null)
				tileset = Tileset.createFromReg(reg, tileWidth, tileHeight);
			else
			{
				var image:Image = Reflect.field(Assets.images, name);
				
				if (image != null)
					tileset = new Tileset(image, 0, 0, image.width, image.height, tileWidth, tileHeight);
				else
				{
					trace('Image $name for the tileset not found');
					return null;
				}
			}
			
			if (useCache)
				the.tilesets.set(name, tileset);
		}
		
		return tileset;
	}
	
	public static function getSMap(name:String, ?tileset:Tileset, useCache:Bool = true):SMap
	{
		var map:SMap = null;
		
		if (useCache)
		{
			if (the.maps == null)
				the.maps = new Map<String, SMap>();
			
			map = the.maps.get(name);
		}
				
		if (map == null)
		{
			map = the.parseSMap(name);
			
			if (map != null)
			{
				if (useCache)
					the.maps.set(name, map);
			}
			else
			{
				trace('SMap $name not found');
				return null;
			}
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
		
		if (rawMap != null)
		{
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
		else
			return null;
	}
}