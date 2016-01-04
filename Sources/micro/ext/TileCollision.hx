package micro.ext;

import kha.math.Vector2;
import kha.math.Vector2i;

class TileCollision
{
	var colGrid:Array<Array<Int>>;	
	var tileWidth:Int;
	var tileHeight:Int;
	var empty:Int;
	
	public var lastTxCollided:Int = -1;
	public var lastTyCollided:Int = -1;
	public var lastIdCollided:Int = -1;
	
	var lt = new Vector2();
	var rt = new Vector2();
	var lb = new Vector2();
	var rb = new Vector2();
	
	var t1 = new Vector2i();
	var t2 = new Vector2i();
	var t3 = new Vector2i();
	var t4 = new Vector2i();
	
	public function new(colGrid:Array<Array<Int>>, tileWidth:Int, tileHeight:Int, empty:Int) 
	{
		this.colGrid = colGrid;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.empty = empty;
	}
	
	public function checkCollisionX(x:Float, y:Float, width:Int, height:Int, dirX:Int):Float
	{
		lt.x = x;
		lt.y = y + 1;
		
		rt.x = x + width;
		rt.y = y + 1;
		
		lb.x = x;
		lb.y = y + height - 1;
		
		rb.x = x + width;
		rb.y = y + height - 1;
		
		// left
		if (dirX == -1)
		{
			t1.x = Std.int(lt.x / tileWidth);
			t1.y = Std.int(lt.y / tileHeight);
			t2.x = Std.int(lb.x / tileWidth);
			t2.y = Std.int(lb.y / tileHeight);
			t3.x = Std.int(rt.x / tileWidth);
			t3.y = Std.int(rt.y / tileHeight);
			t4.x = Std.int(rb.x / tileWidth);
			t4.y = Std.int(rb.y / tileHeight);	
		}
		// right
		else if (dirX == 1)
		{
			t1.x = Std.int(rt.x / tileWidth);
			t1.y = Std.int(rt.y / tileHeight);
			t2.x = Std.int(rb.x / tileWidth);
			t2.y = Std.int(rb.y / tileHeight);
			t3.x = Std.int(lt.x / tileWidth);
			t3.y = Std.int(lt.y / tileHeight);
			t4.x = Std.int(lb.x / tileWidth);
			t4.y = Std.int(lb.y / tileHeight);	
		}		
		
		if ((colGrid[t1.y][t1.x] != empty && colGrid[t3.y][t3.x] == empty) || (colGrid[t2.y][t2.x] != empty && colGrid[t4.y][t4.x] == empty))
		{
			if (colGrid[t1.y][t1.x] != empty)
			{
				lastTxCollided = t1.x;
				lastTyCollided = t1.y;
				lastIdCollided = colGrid[t1.y][t1.x];
			}
			else
			{
				lastTxCollided = t2.x;
				lastTyCollided = t2.y;
				lastIdCollided = colGrid[t2.y][t2.x];
			}
			
			if (dirX == -1)
				x = (t1.x * tileWidth) + tileWidth;
			else if (dirX == 1)
				x = (t1.x * tileWidth) - width;
				
			return x;
		}
		else
			return -1;
	}
	
	public function checkCollisionY(x:Float, y:Float, width:Int, height:Int, dirY:Int):Float
	{
		lt.x = x + 1;
		lt.y = y;
		
		rt.x = x + width - 1;
		rt.y = y;
		
		lb.x = x + 1;
		lb.y = y + height;
		
		rb.x = x + width - 1;
		rb.y = y + height;
		
		// top
		if (dirY == -1)
		{
			t1.x = Std.int(lt.x / tileWidth);
			t1.y = Std.int(lt.y / tileHeight);
			t2.x = Std.int(rt.x / tileWidth);
			t2.y = Std.int(rt.y / tileHeight);
			t3.x = Std.int(lb.x / tileWidth);
			t3.y = Std.int(lb.y / tileHeight);
			t4.x = Std.int(rb.x / tileWidth);
			t4.y = Std.int(rb.y / tileHeight);			
		}
		// bottom
		else if (dirY == 1)
		{
			t1.x = Std.int(lb.x / tileWidth);
			t1.y = Std.int(lb.y / tileHeight);
			t2.x = Std.int(rb.x / tileWidth);
			t2.y = Std.int(rb.y / tileHeight);
			t3.x = Std.int(lt.x / tileWidth);
			t3.y = Std.int(lt.y / tileHeight);
			t4.x = Std.int(rt.x / tileWidth);
			t4.y = Std.int(rt.y / tileHeight);			
		}		
			
		if ((colGrid[t1.y][t1.x] != empty && colGrid[t3.y][t3.x] == empty) || (colGrid[t2.y][t2.x] != empty && colGrid[t4.y][t4.x] == empty))
		{	
			if (colGrid[t1.y][t1.x] != empty)
			{
				lastTxCollided = t1.x;
				lastTyCollided = t1.y;
				lastIdCollided = colGrid[t1.y][t1.x];
			}
			else
			{
				lastTxCollided = t2.x;
				lastTyCollided = t2.y;
				lastIdCollided = colGrid[t2.y][t2.x];
			}
			
			if (dirY == -1)
				y = (t1.y * tileHeight) + tileHeight;
			else if (dirY == 1)
				y = (t1.y * tileHeight) - height;
				
			return y;
		}
		else
			return -1;				
	}
}