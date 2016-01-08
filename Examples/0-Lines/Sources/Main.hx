package;

import kha.System;
import micro.Engine;

class Main 
{
	public static function main() 
	{		
		System.init('Lines', 512, 512, function() 		
		{
			var game = new Game();
			var engine = new Engine(game.init, game.update, game.draw, 128, 128, 30);
		});
	}	
}