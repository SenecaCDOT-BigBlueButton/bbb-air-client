package org.bigbluebutton.view.navigation.pages.presentation
{
	import mx.charts.renderers.LineRenderer;
	import mx.controls.SWFLoader;
	
	import org.bigbluebutton.core.view.IView;
	import org.bigbluebutton.model.presentation.Slide;
	import org.osflash.signals.ISignal;
	
	import spark.components.Group;
	import spark.primitives.Rect;

	public interface IPresentationView extends IView
	{
		function setSlide(s:Slide):void;
		function setPresentationName(name:String):void;
		function getSlide():SWFLoader;
		function getContent():Group;
		function getSlideContainer():Group;
	}
}