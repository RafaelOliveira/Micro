package micro;

import kha.Assets;
import kha.graphics2.ImageScaleQuality;
import kha.Framebuffer;
import kha.Scaler;
import kha.Scheduler;
import kha.System;
import micro.Micro;

class Engine
{		
	var gameRender:Void->Void;
	
	private var oldTime:Float = 0;
	private var currentTime:Float = 0;
		
	public function new(gameInit:Void->Void, gameUpdate:Void->Void, gameRender:Void->Void, width:Int = 128, height:Int = 128, fps:Int = 60) 
	{		
		Assets.loadEverything(function()
		{	
			var loader = new Loader();
			var input = new Input();
			var draw = new Draw(width, height);
			
			Micro.gameWidth = width;
			Micro.gameHeight = height;
			Micro.halfGameWidth = Std.int(width / 2);
			Micro.halfGameHeight = Std.int(height / 2);
			
			gameInit();
			
			if (gameUpdate != null)
			{				
				Scheduler.addTimeTask(function() {
					update();
					gameUpdate();
					input.update();
				}, 0, 1 / fps);				
			}
			
			if (gameRender != null)
			{
				this.gameRender = gameRender;
				System.notifyOnRender(render);
			}
		});
	}
	
	inline function update()
	{
		oldTime = currentTime;
	    currentTime = Scheduler.time();
		
		Micro.elapsed = currentTime - oldTime;
	}

	public function render(framebuffer:Framebuffer):Void 
	{		
		if (Draw.bFilter)
			framebuffer.g2.imageScaleQuality = ImageScaleQuality.High;		
		
		Draw.g2.begin(false);
		gameRender();
		Draw.g2.end();
		
		framebuffer.g2.begin();		
		Scaler.scale(Draw.backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();		
	}	
}