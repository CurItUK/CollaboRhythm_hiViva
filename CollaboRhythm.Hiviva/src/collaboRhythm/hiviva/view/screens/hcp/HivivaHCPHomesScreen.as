package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaPopUp;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.PatientResultCell;
	import collaboRhythm.hiviva.view.screens.PatientResultCellHome;

	import feathers.controls.Button;

	import feathers.controls.Label;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.layout.VerticalLayout;

	import flash.events.Event;

	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.events.Event;

	public class HivivaHCPHomesScreen extends Screen
	{


		private var _userSignupPopupContent:HivivaPopUp;
		private var _patientCellContainer:ScrollContainer;
		private var _connectToPatientBtn:Button;
		private var _patientsData:XML;
		private var _patients:Array;
		private var _filterdPatients:Array;
		private var _patientLabel:Label;

		private const PADDING:Number = 20;

		public function HivivaHCPHomesScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			var scaledPadding:Number = PADDING * this.dpiScale;

			this._patientLabel.validate();
			this._patientLabel.x = PADDING;
			this._patientLabel.y = 120;
			this._patientLabel.width = this.actualWidth;

			_connectToPatientBtn.validate();
			_connectToPatientBtn.x = this.actualWidth / 2 - _connectToPatientBtn.width / 2;
			_connectToPatientBtn.y = this.actualHeight - _connectToPatientBtn.height - scaledPadding - Constants.FOOTER_BTNGROUP_HEIGHT;

			checkHCPSignupStatus();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._patientLabel = new Label();
			this._patientLabel.text = "<font face='ExoBold'>Patients</font>";
			this..addChild(this._patientLabel);

			_connectToPatientBtn = new Button();
			_connectToPatientBtn.label = "Connect to patient";
			_connectToPatientBtn.addEventListener(starling.events.Event.TRIGGERED, connectToPatientBtnHandler);
			this.addChild(_connectToPatientBtn);

			this._patientCellContainer = new ScrollContainer();

		}

		private function checkHCPSignupStatus():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getHcpProfile();
		}

		private function getHcpProfileHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);

			if(e.data.hcpProfile != null)
			{
				getHcpConnections();
			}
			else
			{
				initPatientSignupProcess();
			}
		}

		private function getHcpConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController..addEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler)
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getHCPConnections();
		}

		private function getHcpListCompleteHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler)
			if (e.data.connections != null)
			{
				this._patients = e.data.connections;
				initPatientXMLData();
			}
			else
			{
				initAlertText();
			}
		}

		private function initPatientXMLData():void
		{
			var patientToLoadURL:String = "/resources/dummy_patientlist.xml";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, patientXMLFileLoadHandler);
			loader.load(new URLRequest(patientToLoadURL));
		}

		private function patientXMLFileLoadHandler(e:flash.events.Event):void
		{
			_patientsData = XML(e.target.data);
			drawPatientProfiles();
		}

		private function drawPatientProfiles():void
		{
			//TODO add better xml search for patients by appid.
			var patientsXMLList:XMLList = patientsData.patient;
			_filterdPatients = [];

			var patientsLength:uint = patientsXMLList.length();
			var innerLoop:uint = patients.length;
			for (var i:uint = 0; i < patientsLength; i++)
			{
				for (var j:uint = 0; j < innerLoop; j++)
				{
					if (patientsXMLList[i].appid == patients[j].appid)
					{
						_filterdPatients.push(patientsXMLList[i]);
					}
				}
			}

			var connectionsLength:uint = _filterdPatients.length;

			for (var listCount:int = 0; listCount < connectionsLength; listCount++)
			{
				var patientCell:PatientResultCellHome = new PatientResultCellHome();
				patientCell.patientData = _filterdPatients[listCount];
				patientCell.isResult = false;

				patientCell.scale = this.dpiScale;
				patientCell.addEventListener(FeathersScreenEvent.PATIENT_PROFILE_SELECTED, profileSelectedHandler);
				this._patientCellContainer.addChild(patientCell);
			}

			addChild(this._patientCellContainer);
			drawResults();

		}

		private function profileSelectedHandler(e:FeathersScreenEvent):void
		{
			trace("Profile Selected " + e.evtData.profile);
			this.dispatchEventWith("mainToSubNav" , false , {profileMenu:HivivaScreens.HCP_PATIENT_PROFILE , patientName:e.evtData.profile.name , appID:e.evtData.profile.appid});
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var yStartPosition:Number;
			var maxHeight:Number;
			var patientCell:PatientResultCellHome;

			yStartPosition = this._patientLabel.y + scaledPadding + this._patientLabel.height;
			maxHeight = this.actualHeight - yStartPosition -  this._patientLabel.height - _connectToPatientBtn.height - Constants.FOOTER_BTNGROUP_HEIGHT - 2 * (PADDING * this.dpiScale);

			this._patientCellContainer.width = this.actualWidth;
			this._patientCellContainer.y = yStartPosition;
			this._patientCellContainer.height = maxHeight;

			for (var i:int = 0; i < this._patientCellContainer.numChildren; i++)
			{
				patientCell = this._patientCellContainer.getChildAt(i) as PatientResultCellHome;
				patientCell.width = this.actualWidth;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._patientCellContainer.layout = layout;
			this._patientCellContainer.validate();
		}

		private function initAlertText():void
		{

			var alertLabel:Label = new Label();
			alertLabel.text = "Connect to a patient to get started.";

			this.addChild(alertLabel);
			alertLabel.validate();

			alertLabel.width = 390;
			alertLabel.x = this.actualWidth / 2 - alertLabel.width / 2;
			alertLabel.y = alertLabel.height * 4;
		}

		private function connectToPatientBtnHandler(e:starling.events.Event):void
		{
			this.dispatchEventWith("mainToSubNav" , false , {profileMenu:HivivaScreens.HCP_CONNECT_PATIENT});
		}

		private function initPatientSignupProcess():void
		{
			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV, true));

			this.owner.addScreen(HivivaScreens.HCP_EDIT_PROFILE, new ScreenNavigatorItem(HivivaHCPEditProfile));

			this._userSignupPopupContent = new HivivaPopUp();
			this._userSignupPopupContent.scale = this.dpiScale;
			this._userSignupPopupContent.confirmLabel = "Sign up";
			this._userSignupPopupContent.addEventListener(starling.events.Event.COMPLETE, userSignupScreen);
			this._userSignupPopupContent.addEventListener(starling.events.Event.CLOSE, userSignupScreen);
			this._userSignupPopupContent.width = this.actualWidth * 0.75;
			this._userSignupPopupContent.validate();
			this._userSignupPopupContent.message = "You will need to create an account in order to connect to a patient";

			PopUpManager.addPopUp(this._userSignupPopupContent,true,true);
			this._userSignupPopupContent.validate();
			PopUpManager.centerPopUp(this._userSignupPopupContent);

			this._userSignupPopupContent.drawCloseButton();
		}

		private function userSignupScreen(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_EDIT_PROFILE);
			this._userSignupPopupContent.removeEventListener(starling.events.Event.COMPLETE, userSignupScreen);
			this._userSignupPopupContent.removeEventListener(starling.events.Event.CLOSE, userSignupScreen);
			PopUpManager.removePopUp(this._userSignupPopupContent);
			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV, true));
		}

		public function set patientsData(value:XML):void
		{
			this._patientsData = value;
		}

		public function get patientsData():XML
		{
			return this._patientsData;
		}

		public function set patients(value:Array):void
		{
			this._patients = value;
		}

		public function get patients():Array
		{
			return this._patients;
		}

	}
}
