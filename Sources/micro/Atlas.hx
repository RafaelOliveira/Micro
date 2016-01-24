package micro;

import kha.Assets;
import kha.Blob;
import kha.Image;

class Atlas
{
	var regions:Map<String, Region>;
	var tilesets:Map<String, Tileset>;
	
	public function new(name:String) 
	{
		regions = new Map<String, Region>();
		
		var raw:Blob = Reflect.field(Assets.blobs, '${name}_json');
		var data = haxe.Json.parse(raw.toString());
		var imageFileName = data.meta.image;		
		
		var img:Image = Reflect.field(Assets.images, StringTools.replace(imageFileName, '.png', ''));
		
		var frames = cast(data.frames, Array<Dynamic>);
		
		for (item in frames)
		{
			var reg = new Region(img, item.frame.x, item.frame.y, item.frame.w, item.frame.h);
			regions.set(item.filename, reg);
		}
	}
	
	public function getReg(name:String):Region
	{		
		var reg = regions.get(name);
		
		if (reg == null)
		{
			trace('Region $name not found');
			return null;
		}
		
		return reg;
	}
	
	public function getTileset(name:String, tileWidth:Int, ?tileHeight:Int):Tileset
	{
		if (tilesets == null)
			tilesets = new Map<String, Tileset>();
		
		var tileset = tilesets.get(name);
		
		if (tileset == null)
		{
			var reg = getReg(name);
			
			if (reg != null)
			{
				tileset = Tileset.createFromReg(reg, tileWidth, tileHeight);
				tilesets.set(name, tileset);
			}
			else
			{
				trace('Region $name for the tileset not found');
				return null;
			}			
		}
		
		return tileset;
	}
}