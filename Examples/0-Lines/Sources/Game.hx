package;

import kha.Color;
import kha.math.Vector2i;
import micro.Draw;
import micro.Draw.*;
import micro.SColor.*;
import micro.Micro.*;

typedef Point = {
	x:Int,
	y:Int,
	dirX:Int,
	dirY:Int,
}

class Game
{
	inline static var max_points:Int = 4;
	
	var t = 0;
	var points:Array<Point>;
	
	public function new() 
	{	
		
	}
	
	public function init()
	{		
		loadPal(0);
		
		points = new Array<Point>();
		for (i in 0...(max_points))
			points.push({ x: int(rnd(127)), y: int(rnd(127)), dirX: getRandomDir(), dirY: getRandomDir() });
	}
	
	function getRandomDir()
	{
		var dir = int(rnd(2));
		
		if (dir == 0)
			return -1;
		else
			return 1;
	}
	
	public function update() 
	{	
		t += 1;
		
		if (t % 4 == 3)
		{
			for (p in points)
			{
				if (p.dirX == -1)
					p.x -= 2;
				else
					p.x += 2;
					
				if (p.dirY == -1)
					p.y -= 2;
				else
					p.y += 2;
					
				if (p.x < 0)
				{
					p.x = 0;
					p.dirX = 1;
				}
				else if (p.x > 127)
				{
					p.x = 127;
					p.dirX = -1;
				}
				
				if (p.y < 0)
				{
					p.y = 0;
					p.dirY = 1;
				}
				else if (p.y > 127)
				{
					p.y = 127;
					p.dirY = -1;
				}
			}			
		}
	}

	public function draw()
	{
		cls();
		
		var j = 0;
		
		for (i in 0...(max_points))
		{
			if (i < (max_points - 1))
				j = i + 1;
			else
				j = 0;
			
			if (i % 2 == 0)
				line(points[i].x, points[i].y, points[j].x, points[j].y, pal(7));
			else
				line(points[i].x, points[i].y, points[j].x, points[j].y, pal(8));
		}
	}
}