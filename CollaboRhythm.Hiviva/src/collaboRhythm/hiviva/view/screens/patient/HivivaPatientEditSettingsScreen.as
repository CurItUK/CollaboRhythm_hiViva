 package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.galleryscreens.Gallery;
	import collaboRhythm.hiviva.view.galleryscreens.GalleryData;
	import collaboRhythm.hiviva.view.galleryscreens.GalleryScreen;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledColumnsLayout;
	import feathers.skins.Scale9ImageStateValueSelector;
	import feathers.textures.Scale9Textures;

	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	// import flash.events.Event;
	 import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;

	 import mx.charts.styles.HaloDefaults;

	 import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class HivivaPatientEditSettingsScreen extends ValidationScreen
	{
		private var _instructions:Label;




		private var _submitButton:Button;
		private var _backButton:Button;


		public function HivivaPatientEditSettingsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

		 	this._instructions.width = this._innerWidth;


			this._submitButton.width = this._innerWidth * 0.25;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Settings";

			this._instructions = new Label();

			this._instructions.text = 	"Tap the button below to restore your user settings\n back to their Defaults.";
			this._content.addChild(this._instructions);



			this._submitButton = new Button();
			this._submitButton.label = "Save";
		   this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
		    this._content.addChild(this._submitButton);

	     	this._backButton = new Button();
	 		this._backButton.name = "back-button";
	 		this._backButton.label = "Back";
	     	//this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];



		}




		private function submitButtonClick(e:Event):void
		{

			localStoreController.addEventListener(LocalDataStoreEvent.PATIENT_SETTINGS_RESTORE_SAVE_COMPLETE , resetStoreServiceHandler);
			localStoreController.resetStoreService()
		}

		private function resetStoreServiceHandler(e:LocalDataStoreEvent):void{
			localStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_SETTINGS_RESTORE_SAVE_COMPLETE , resetStoreServiceHandler);







		}



		private function initImageData():void
		{

		}


		private function backBtnHandler(event:Event):void
		{

		}
	}
}
