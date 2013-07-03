package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaPopUp;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;
	import collaboRhythm.hiviva.view.components.MessageCell;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;
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


	public class HivivaHCPPatientMessageCompose extends ValidationScreen
	{


		private var _backButton:Button;
		private var _patients:Array;
		private var _main:Main;

		private var _hcpName:Label;
		private var _patientName:Label;
		private var _selectMessage:Label;

		private var scaledPadding:Number;
		private const PADDING:Number = 32;

		private var _cellContainer:ScrollContainer;
		private var _scaledPadding:Number;

		private var _sendButton:Button;

		private var _popupContainer:HivivaPopUp;
	//	private var _stageWebView:StageWebView
		private var _selectedPatient:XML;

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

		public function HivivaHCPPatientMessageCompose()
		{

		}

		override protected function draw():void
		{

			super.draw();

			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;

			this._hcpName.x = scaledPadding;
			this._hcpName.y = this._header.height + scaledPadding;
			this._hcpName.width = 300;

			this._patientName.x = scaledPadding;
			this._patientName.y = this._header.height + this._hcpName.height + PADDING;

			this._selectMessage.x = scaledPadding;
			this._selectMessage.y = this._patientName.y + 2*scaledPadding + PADDING;

			this._sendButton.y = this._content.height - this._sendButton.height;
			this._sendButton.x = (this.actualWidth)/2 - (this._sendButton.width)/2;


			if(_cellContainer == null)
			{
				drawMessages();
			}
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Compose message";

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);
			this.addChild(this._backButton);

			this._header.leftItems = new <DisplayObject>[this._backButton];

			scaledPadding = PADDING * this.dpiScale;

			this._hcpName = new Label();
			this._hcpName.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._hcpName.text = "From : Dr Richard Gould"// + _main.selectedHCPPatientProfile.name;
			this.addChild(this._hcpName);
			this._hcpName.validate();

			this._patientName = new Label();
			this._patientName.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._patientName.text = "To : " + selectedPatient.name;
			this.addChild(this._patientName);
			this._patientName.validate();

			this._selectMessage = new Label();
			this._selectMessage.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._selectMessage.text = "Select Message "// + _main.selectedHCPPatientProfile.name;
			this.addChild(this._selectMessage);
			this._selectMessage.validate();

			this._sendButton = new Button();//
			this._sendButton.addEventListener(starling.events.Event.TRIGGERED, sendButtonHandler);
			this._sendButton.label = "Send";
			this._content.addChild(this._sendButton);

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}

		private function drawMessages():void
		{
			this._cellContainer = new ScrollContainer();
			var message:MessageCell;
				for (var i:int = 0; i < MESSAGE_LABELS.length; i++)
				{
					message = new MessageCell();
					message.scale = this.dpiScale/2;
					message.messageName = MESSAGE_LABELS[i];
				//	message.messageIcon = MESSAGE_ICONS[i];
					message.width = this.actualWidth;
					//message.checkBox.addEventListener(Event.TRIGGERED, test);
					this._cellContainer.addChild(message);


				}

				this._cellContainer.width = this.actualWidth;
				this._cellContainer.y = this._header.height + 150;
				this._cellContainer.height = this.actualHeight - this._cellContainer.y - (this._scaledPadding * 2);
				this._cellContainer.layout = new VerticalLayout();
				this._cellContainer.validate();
				this.addChild(this._cellContainer);
		}


		private function sendButtonHandler(e:starling.events.Event):void
		{
					this._popupContainer = new HivivaPopUp();
					this._popupContainer.scale = this.dpiScale;
					this._popupContainer.width = this.actualWidth;
					this._popupContainer.height = this.actualHeight;
					this._popupContainer.addEventListener(starling.events.Event.CLOSE, closePopup);
//					this._popupContainer.message = _main.selectedHCPPatientProfile.name;
					this._popupContainer.confirmLabel = 'Message Sent';
					this._popupContainer.validate();

					PopUpManager.addPopUp(this._popupContainer, true, true);
					this._popupContainer.validate();


		}

		private function closePopup(e:Event):void
		{

			PopUpManager.removePopUp(this._popupContainer);

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

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PATIENT_PROFILE);
		//	this.owner.showScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN);
		//	this.dispatchEventWith("mainToSubNav" , false , {profileMenu:HivivaScreens.HCP_PATIENT_PROFILE , patientName:e.evtData.profile.name , appID:e.evtData.profile.appid});

		}



		public function get selectedPatient():XML
		{
			return this._selectedPatient;
		}

		public function set selectedPatient(patient:XML):void
		{
			this._selectedPatient = patient;
		}
	}
}
