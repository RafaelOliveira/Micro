package micro;

class SMap
{
	var layers:Array<Array<Array<Int>>>;
	public var tileset:Tileset;
	
	public var width:Int;
	public var height:Int;
		
	public function new(layers:Array<Array<Array<Int>>>) 
	{
		this.layers = layers;		
		
		width = layers[0][0].length;
		height = layers[0].length;
	}
	
	/** 
	 * Get a tile id 
	*/
	inline public function get(x:Int, y:Int, layer:Int):Int
	{
		return layers[layer][y][x];
	}
	
	/**
	 * Set a tile id
	*/
	inline public function set(x:Int, y:Int, layer:Int, value:Int):Void
	{
		layers[layer][y][x] = value;
	}
	
	inline public function getLayer(id:Int):Array<Array<Int>>
	{
		return layers[id];
	}
	
	/**
	 * Draws a portion of the map	 
	 */
	public function draw(x:Float, y:Float, cx:Int, cy:Int, cw:Int, ch:Int, layer:Int)
	{
		var tx = 0;
		var ty = 0;
		
		for (j in cy...(cy + ch))
		{
			for (i in cx...(cx + cw))
			{
				if (layers[layer][j][i] > -1)
					tileset.drawOne(layers[layer][j][i], x + (tx * tileset.tileWidth), y + (ty * tileset.tileHeight));
				tx++;
			}
			
			tx = 0;
			ty++;
		}
	}
	
	/**
	 * Draws a portion of the map with just one tile	 
	 */
	public function drawWithTile(x:Float, y:Float, cx:Int, cy:Int, cw:Int, ch:Int, layer:Int, tile:Int)
	{
		var tx = 0;
		var ty = 0;
		
		for (j in cy...(cy + ch))
		{
			for (i in cx...(cx + cw))
			{
				if (layers[layer][j][i] > -1)
					tileset.drawOne(tile, x + (tx * tileset.tileWidth), y + (ty * tileset.tileHeight));
				tx++;
			}
			
			tx = 0;
			ty++;
		}
	}
}