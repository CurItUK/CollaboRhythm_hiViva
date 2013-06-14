package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;
	import collaboRhythm.hiviva.view.components.MessageCell;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import flash.events.MouseEvent

	import feathers.controls.Screen;

	import flash.events.MouseEvent;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPMessageCompose extends ValidationScreen
	{
		private var _applicationController:HivivaApplicationController;

		private var _backButton:Button;
		private var _patients:Array;
		private var _main:Main;

		private var _hcpName:Label;
		private var _patientName:Label;
		private var _selectMessage:Label;

		private var scaledPadding:Number;
		private const PADDING:Number = 32;
		private var _patientPickerList:PickerList;

		private var _cellContainer:ScrollContainer;
		private var _scaledPadding:Number;

		private const MESSAGE_LABELS:Array =
		[
			"Great job, keep it up!",
			"Let's schedule an office visit"
		];

		private const MESSAGE_ICONS:Array =
		[
			"STAR1",
			"STAR2"
		]

		public function HivivaHCPMessageCompose()
		{

		}

		override protected function draw():void
		{

			super.draw();
			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._hcpName.x = scaledPadding;
			this._hcpName.y = this._header.height + scaledPadding;
			this._hcpName.width = 300;

			this._patientName.x = scaledPadding;
			this._patientName.y = this._header.height + this._hcpName.height + this._patientPickerList.height/2;

			this._patientPickerList.x = this._patientName.x + this._patientName.width + scaledPadding;
			this._patientPickerList.y = this._patientName.y - 130;

			this._selectMessage.x = scaledPadding;
			this._selectMessage.y = this._patientName.y + 2*scaledPadding;

			this._header.initTrueTitle();




			getHcpConnections();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Compose message";
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			scaledPadding = PADDING * this.dpiScale;

			this._hcpName = new Label();
			this._hcpName.text = "<font face='ExoBold'>From : Dr Richard Gould</font>  "// + _main.selectedHCPPatientProfile.name;
			this.addChild(this._hcpName);
			this._hcpName.validate();

			this._patientName = new Label();
			this._patientName.text = "<font face='ExoBold'>To : </font>  "// + _main.selectedHCPPatientProfile.name;
			this.addChild(this._patientName);
			this._patientName.validate();

			this._patientPickerList = new PickerList();
			this._patientPickerList.listProperties.@itemRendererProperties.labelField = "text";
			this._patientPickerList.labelField = "text";
			this._patientPickerList.addEventListener(starling.events.Event.CHANGE, patientSelectedHandler);
			this._content.addChild(this._patientPickerList);

			this._selectMessage = new Label();
			this._selectMessage.text = "<font face='ExoBold'>Select Message </font>  "// + _main.selectedHCPPatientProfile.name;
			this.addChild(this._selectMessage);
			this._selectMessage.validate();



			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}

		private function drawMessages():void
		{
			this._cellContainer = new ScrollContainer();
			var message:MessageCell;
				for (var i:int = 0; i < MESSAGE_LABELS.length; i++)
				{
					message = new MessageCell();
					message.scale = this.dpiScale;
					message.messageName = MESSAGE_LABELS[i];
					message.messageIcon = MESSAGE_ICONS[i];
					message.width = this.actualWidth;

					this._cellContainer.addChild(message);

					message.checkBox.addEventListener(Event.TRIGGERED, test);
				}

				this.addChild(this._cellContainer);
				this._cellContainer.width = this.actualWidth;
				this._cellContainer.y = this._header.height;
				this._cellContainer.height = this.actualHeight - this._cellContainer.y - (this._scaledPadding * 2);
				this._cellContainer.layout = new VerticalLayout();
				this._cellContainer.validate();
		}

		private function test(e:Event):void
		{
			trace("ITEM CLICKED")
		}

		private function getHcpConnections():void
		{
			applicationController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE , getHcpListCompleteHandler)
			applicationController.hivivaLocalStoreController.getHCPConnections();
		}

		private function getHcpListCompleteHandler(e:LocalDataStoreEvent):void
		{
			applicationController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE , getHcpListCompleteHandler)

			if(e.data.connections != null)
			{
				trace("connectionsLength " + e.data.connections.length);
				var connectionsLength:uint = e.data.connections.length;


			var patientsList:Array = new Array();

				for (var listCount:int = 0; listCount < connectionsLength; listCount++)
				{

					patientsList.push(e.data.connections[listCount].name);

				}
				var patients:ListCollection = new ListCollection( patientsList );

				this._patientPickerList.dataProvider = patients;
				this._patientPickerList.prompt = "Select patient";
				this._patientPickerList.selectedIndex = -1;


				if(_cellContainer == null)
				{
					drawMessages();
				}

			}
		}
		private function initPatientSelectList():void
		{


		}

		private function patientSelectedHandler(e:Event):void
		{
			//TODO change patient PDF report details
		}


		private function initAlertText():void
		{

			var alertLabel:Label = new Label();
			alertLabel.text = "Connect to a patient to get started.";

			this.addChild(alertLabel);
			alertLabel.validate();
			alertLabel.x = this.actualWidth / 2 - alertLabel.width / 2;
			alertLabel.y = alertLabel.height * 4;
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN)
		}

		public override function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
		}

		public override function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public override function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}
	}
}
