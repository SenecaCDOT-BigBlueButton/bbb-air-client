package org.bigbluebutton.view.navigation.pages.presentation
{
	import fl.transitions.easing.*;
	
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	
	import mx.controls.SWFLoader;
	
	import org.bigbluebutton.command.LoadSlideSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.presentation.Presentation;
	import org.bigbluebutton.model.presentation.Slide;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.components.Group;

	
	public class PresentationViewMediator extends Mediator
	{
		[Inject]
		public var view: IPresentationView;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var loadSlideSignal: LoadSlideSignal;
		
		private var _currentPresentation:Presentation;
		private var _currentSlideNum:int = -1;
		private var _currentSlide:Slide;
		
		private var _content:Group;
		private var _swfSlide:SWFLoader;
			
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));		
			userSession.presentationList.presentationChangeSignal.add(presentationChangeHandler);
			
			_swfSlide = view.getSlide();
			_content = view.getContent();
			if(Multitouch.supportsTouchEvents)
			{
				_content.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
				_content.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
				//example of add event listener to anotations
				//_anaContainer2.addEventListener(MouseEvent.MOUSE_MOVE, draggingSlide);
			}

			if(Multitouch.supportedGestures)
			{
				_swfSlide.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoomHandler);
			}

			setPresentation(userSession.presentationList.currentPresentation);
			
			_swfSlide.height = _content.height;
			_swfSlide.width = _content.width;
		}
		
		/* manually dispatch mouse event to move or zoom slide if event target is current anatation*/
		
/*		private function draggingSlide(event:MouseEvent):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			_swfSlide.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, true, false));
		}
		*/

		private function startDragging(event:MouseEvent):void
		{
			_swfSlide.addEventListener(MouseEvent.MOUSE_MOVE, handleDragging);
		}
		
		private function handleDragging(event:MouseEvent):void
		{
			event.preventDefault();
			var swfSlideWidth:Number = _swfSlide.width * _swfSlide.scaleX;
			var swfSlideHeight:Number = _swfSlide.height * _swfSlide.scaleY;
			var portraitOffsetX:Number = Math.abs(swfSlideWidth-_content.width);
			var portraitOffsetY:Number = Math.abs(swfSlideHeight-_content.height);
			var landscapeOffsetX:Number = Math.abs(_content.width-swfSlideHeight);
			var landscapeOffsetY:Number = Math.abs(_content.height-swfSlideWidth);
			var rotation:Number = _swfSlide.rotation;
			
			switch (rotation) {
				
				case -90:
					
					if(swfSlideWidth <= _content.height && swfSlideHeight <= _content.width)
					{
						_swfSlide.startDrag(false,new Rectangle(0, _content.height,landscapeOffsetX,-landscapeOffsetY));
					}
					else if(swfSlideWidth <= _content.height && swfSlideHeight > _content.width)
					{
						_swfSlide.startDrag(false,new Rectangle(-landscapeOffsetX,_content.height,landscapeOffsetX,-landscapeOffsetY));
					}
					else if(swfSlideHeight <= _content.width && swfSlideWidth > _content.height)
					{
						_swfSlide.startDrag(false,new Rectangle(0,_content.height,landscapeOffsetX,landscapeOffsetY));
					}
					else
					{
						_swfSlide.startDrag(false,new Rectangle(-landscapeOffsetX,swfSlideWidth,landscapeOffsetX,-landscapeOffsetY));
					}
					break;
				
				case 90:
					
					if(swfSlideWidth <= _content.height && swfSlideHeight <= _content.width)
					{
						_swfSlide.startDrag(false,new Rectangle(_content.width, 0,-landscapeOffsetX,landscapeOffsetY));
					}
					else if(swfSlideWidth <= _content.height && swfSlideHeight > _content.width)
					{
						_swfSlide.startDrag(false,new Rectangle(swfSlideHeight,0,-landscapeOffsetX,landscapeOffsetY));
					}
					else if(swfSlideHeight <= _content.width && swfSlideWidth > _content.height)
					{
						_swfSlide.startDrag(false,new Rectangle(_content.width,0,-landscapeOffsetX,-landscapeOffsetY));
					}
					else
					{
						_swfSlide.startDrag(false,new Rectangle(swfSlideHeight,-landscapeOffsetY,-landscapeOffsetX,landscapeOffsetY));
					}
					break;
				
				case 180:
					
					if(swfSlideWidth <= _content.width && swfSlideHeight <= _content.height)
					{
						_swfSlide.startDrag(false,new Rectangle(swfSlideWidth,swfSlideHeight,portraitOffsetX,portraitOffsetY));
					}
					else if(swfSlideWidth <= _content.width && swfSlideHeight > _content.height)
					{
						_swfSlide.startDrag(false,new Rectangle(_content.width,swfSlideHeight,-portraitOffsetX,-portraitOffsetY));
					}
					else if(swfSlideHeight <= _content.height && swfSlideWidth > _content.width)
					{
						_swfSlide.startDrag(false,new Rectangle(swfSlideWidth,_content.height,-portraitOffsetX,-portraitOffsetY));
					}
					else
					{
						_swfSlide.startDrag(false,new Rectangle(swfSlideWidth,swfSlideHeight,-portraitOffsetX,-portraitOffsetY));
					}
					break;
				
				default:
					
					if(swfSlideWidth <= _content.width && swfSlideHeight <= _content.height)
					{
						_swfSlide.startDrag(false,new Rectangle(0,0,portraitOffsetX,portraitOffsetY));
					}
					else if(swfSlideWidth <= _content.width && swfSlideHeight > _content.height)
					{
						_swfSlide.startDrag(false,new Rectangle(0,-portraitOffsetY,portraitOffsetX,portraitOffsetY));
					}
					else if(swfSlideHeight <= _content.height && swfSlideWidth > _content.width)
					{
						_swfSlide.startDrag(false,new Rectangle(-portraitOffsetX,0,portraitOffsetX,portraitOffsetY));
					}
					else
					{
						_swfSlide.startDrag(false,new Rectangle(-portraitOffsetX,-portraitOffsetY,portraitOffsetX,portraitOffsetY));
					}
			}
	
		}
		
		private function stopDragging(event:MouseEvent):void
		{
			_swfSlide.stopDrag();
			_swfSlide.removeEventListener(MouseEvent.MOUSE_MOVE, handleDragging);
		}
		
		private function displaySlide():void {
			if (_currentSlide != null) {
				_currentSlide.slideLoadedSignal.remove(slideLoadedHandler);
			}
			
			if (_currentPresentation != null && _currentSlideNum >= 0) {
				_currentSlide = _currentPresentation.getSlideAt(_currentSlideNum);
				if (_currentSlide != null) {
					if (_currentSlide.loaded && view != null) {
						view.setSlide(_currentSlide);
					} else {
						_currentSlide.slideLoadedSignal.add(slideLoadedHandler);
						loadSlideSignal.dispatch(_currentSlide);
					}
				}
			} else if (view != null) {
				view.setSlide(null);
			}

		}
			
		protected function gestureZoomHandler(event:TransformGestureEvent):void
		{		
			var prevScaleX:Number=_swfSlide.scaleX;
			var prevScaleY:Number=_swfSlide.scaleY;
			var scaleX:Number = (event.scaleX + event.scaleY)/2;
			var scaleY:Number = (event.scaleX + event.scaleY)/2;
			var afterScaleX:Number = prevScaleX * scaleX;
			var affineTransform:Matrix = view.getSlide().transform.matrix;
			var newSlideWidth:Number = _swfSlide.width * afterScaleX;
			var newSlideHeight:Number = _swfSlide.height * afterScaleX;
			
			var rotation:Number = _swfSlide.rotation;
			
			switch (rotation) {
				
				case -90:								
				case 90:
					if(scaleX > 1 && afterScaleX > 4)
					{
						scaleX=1;
						scaleY=1;
					}
					if(scaleX < 1 && newSlideWidth < _content.height)
					{
						scaleX=1;
						scaleY=1;
					}				
					break;
				
				case 180:			
				default:
									
					if(scaleX > 1 && afterScaleX > 4)
					{
						scaleX=1;
						scaleY=1;
					}
					if(scaleX < 1 && newSlideWidth < _content.width)
					{
						scaleX=1;
						scaleY=1;
					}
			}
						
			affineTransform.translate(-event.stageX,-event.stageY);
			affineTransform.scale(scaleX,scaleY);
			affineTransform.translate(event.stageX,event.stageY);
			view.getSlide().transform.matrix = affineTransform;
		}
		

		
		private function presentationChangeHandler():void {
			setPresentation(userSession.presentationList.currentPresentation);
		}
		
		private function slideChangeHandler():void {
			setCurrentSlideNum(_currentPresentation.currentSlideNum);
		}
		
		private function setPresentation(p:Presentation):void {
			if(_currentPresentation != null) {
				_currentPresentation.slideChangeSignal.remove(slideChangeHandler);
			}
			_currentPresentation = p;
			if (_currentPresentation != null) {
				view.setPresentationName(_currentPresentation.fileName);
				_currentPresentation.slideChangeSignal.add(slideChangeHandler);
				setCurrentSlideNum(p.currentSlideNum);
			} else {
				view.setPresentationName("");
			}
			
		}
		
		private function setCurrentSlideNum(n:int):void {
			_currentSlideNum = n;
			displaySlide();
		}
		
		private function slideLoadedHandler():void {

			displaySlide();
		}
		
		override public function destroy():void
		{
			userSession.presentationList.presentationChangeSignal.remove(presentationChangeHandler);
			
			if(_currentPresentation != null) {
				_currentPresentation.slideChangeSignal.remove(slideChangeHandler);
			}
			
			if(Multitouch.supportedGestures)
			{
				_swfSlide.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoomHandler);
			}
			
			if(Multitouch.supportsTouchEvents)
			{
				_content.removeEventListener(MouseEvent.MOUSE_DOWN, startDragging);
				_content.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			}

			super.destroy();
			
			view.dispose();
			view = null;
		}
	}
}