package  
{
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.system.Capabilities;
	import org.gestouch.core.Gestouch;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.input.NativeInputAdapter;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author andrewdobson.co.uk
	 */
	public class Gallery extends Sprite
	{
		[Embed(source = "../assets/background.jpg")]
		private var bg:Class;
		
		private var q:LoaderMax;
		private var container:Sprite;
		private var index:Number = 0;
		private var screenHeight:Number;
		private var screenWidth:Number;
		private var mainstage:Stage;
		private var content:Array = new Array("content/nexus/1.jpg","content/nexus/2.jpg","content/nexus/3.jpg","content/nexus/4.jpg","content/nexus/5.jpg","content/nexus/6.jpg","content/nexus/7.jpg","content/nexus/8.jpg","content/nexus/9.jpg","content/nexus/10.jpg");
		public function Gallery() 
		{
			
			screenHeight = Capabilities.screenResolutionY;
			screenWidth = Capabilities.screenResolutionX;
			mainstage = Starling.current.nativeStage;
			
			var bgImage:Image = new Image(Texture.fromBitmap(new bg()));
			bgImage.width = screenWidth;
			bgImage.height = screenHeight;
			addChild(bgImage);
			
			container = new Sprite();
			container.x = screenWidth;
			addChild(container);
			
			q = new LoaderMax( { name:"queue", onProgress:progressHandler, onError:errorHandler, onComplete:completeHandler } );
			for (var i:Number = 0; i < content.length; i++)
			{
				trace(i);
				q.append(new ImageLoader(content[i],{name:"photo" + i } ));
			}
			q.load();
		}
		
		private function progressHandler(e:LoaderEvent):void 
		{
			trace("progressing");
		}
		
		private function completeHandler(e:LoaderEvent):void 
		{
			trace("the queue is complete");
			trace(q.content.length);
			trace(q.content);
			
			for (var i:Number = 0; i < content.length; i++)
			{
				
				var bmp:Bitmap = q.content[i].rawContent;
				var image:Image = new Image(Texture.fromBitmap(bmp));
				image.x = i * screenWidth;
				container.addChild(image);
			}
			TweenLite.to(container, 0.5, { x:0 } );
			initTouch();
		}
		
		private function initTouch():void 
		{
			Gestouch.inputAdapter ||= new NativeInputAdapter(mainstage);
			Gestouch.addDisplayListAdapter(DisplayObject, new StarlingDisplayListAdapter());
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(Starling.current), -1);
			
			var swipe:SwipeGesture = new SwipeGesture(container);
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, swipeHandler);
		}
		
		private function swipeHandler(e:GestureEvent):void 
		{
			const gesture:SwipeGesture = e.target as SwipeGesture;
			
			if (gesture.offsetX < 0 && index < content.length - 1)
			{
				index++;
				TweenLite.to(container, 0.5, {x:-(screenWidth*index), ease:Expo.easeOut } );
			} else if (gesture.offsetX > 0 && index>0)
			{
				index--;
				TweenLite.to(container, 0.5, {x:-(screenWidth*index), ease:Expo.easeOut } );
			}
		}
		
		private function errorHandler(e:LoaderEvent):void 
		{
			trace("this is fucked");
		}
		
	}

}