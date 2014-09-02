package org.bigbluebutton.view.navigation.pages.presentation
{
	import fl.motion.MatrixTransformer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageOrientation;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.controls.SWFLoader;
	import mx.core.FlexGlobals;
	import mx.events.MoveEvent;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.model.presentation.Slide;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.primitives.Rect;
	

	
	public class PresentationView extends PresentationViewBase implements IPresentationView
	{
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
		}
				
		public function onClick(e:MouseEvent):void
		{
			//buttonTestSignal.dispatch();
		}
		
		public function setPresentationName(name:String):void {
			FlexGlobals.topLevelApplication.pageName.text = name;
		}
		
		public function setSlide(s:Slide):void {
			if (s != null) {	
				var context:LoaderContext = new LoaderContext();			
				context.allowCodeImport = true;
				slide.loaderContext = context;
				slide.source = s.SWFFile.source;
			} else {
				slide.source = null;
			}
		}
		
		public function getSlide():SWFLoader
		{
			return slide;
		}
		
		public function getContent():Group
		{
			return content;
		}
		
		public function getSlideContainer():Group
		{
			return slideContainer;
		}
		
		public function securityError(e:Event):void
		{
			trace("PresentationView.as Security error : " + e.toString());	
		}
		
		override public function rotationHandler(rotation:String):void {
			var mat:Matrix = slide.transform.matrix.clone();
			var rectCenter:Point = new Point(content.width/2,content.height/2);
			var currentLoactionDeg:Number = slide.rotation;
			var targetLocationDeg:Number;
			switch (rotation) {
				case StageOrientation.ROTATED_LEFT:

					/*		slide.transformX = slide.width/2;
					slide.transformY = slide.height/2;
					slide.rotation = -90;*/
					targetLocationDeg = -90 -  currentLoactionDeg;
					MatrixTransformer.rotateAroundExternalPoint(mat,rectCenter.x,rectCenter.y,targetLocationDeg);
					if(slide.width * slide.scaleX < content.height)
					{
						mat.translate(0,(content.height-slide.width)/2);
						slide.height *= content.height/slide.width;
						slide.width = content.height;
					}
					break;
				case StageOrientation.ROTATED_RIGHT:

				/*			slide.transformX = slide.width/2;
					slide.transformY = slide.height/2;
					slide.rotation = 90;*/
					targetLocationDeg = 90 -  currentLoactionDeg;
					MatrixTransformer.rotateAroundExternalPoint(mat,rectCenter.x,rectCenter.y,targetLocationDeg);
					if(slide.width * slide.scaleX < content.height)
					{
						mat.translate(0,-(content.height-slide.width)/2);
						slide.height *= content.height/slide.width;
						slide.width = content.height;
					}
					
					break;
				case StageOrientation.UPSIDE_DOWN:
/*					slide.rotation = 180;
					slide.transformX = slide.width/2;
					slide.transformY = slide.height/2;*/
					targetLocationDeg = 180 -  currentLoactionDeg;
					MatrixTransformer.rotateAroundExternalPoint(mat,rectCenter.x,rectCenter.y,targetLocationDeg);
					break;
				case StageOrientation.DEFAULT:
				case StageOrientation.UNKNOWN:
				default:
/*					slide.rotation = 0;
					slide.transformX = slide.width/2;
					slide.transformY = slide.height/2;*/
					targetLocationDeg = 0 -  currentLoactionDeg;
					MatrixTransformer.rotateAroundExternalPoint(mat,rectCenter.x,rectCenter.y,targetLocationDeg);
			}
			slide.transform.matrix = mat;
		}
		
		
		public function dispose():void
		{

		}
		
	}
}