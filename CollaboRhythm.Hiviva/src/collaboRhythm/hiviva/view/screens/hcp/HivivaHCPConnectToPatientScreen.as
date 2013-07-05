package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.layout.VerticalLayout;

	import flash.events.DataEvent;

	import flash.text.TextFormat;
	import starling.display.DisplayObject;
	import starling.events.Event;


	public class HivivaHCPConnectToPatientScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _addConnectionButton:Button;
		private var _backButton:Button;
		private var _patientFilteredList:Array = [];

		private var _patientCellContainer:ScrollContainer;
		private var _patientCellRadioGroup:ToggleGroup;
		private var _deletePopupContainer:HivivaPopUp;
		private var _selectedPatientCellForDelete:PatientResultCell;

		private const PADDING:Number = 20;

		public function HivivaHCPConnectToPatientScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
			this._backButton.validate();

			this._addConnectionButton.validate();
			this._addConnectionButton.x = (this.actualWidth / 2) - (this._addConnectionButton.width / 2);
			this._addConnectionButton.y = this.actualHeight - this._addConnectionButton.height - (PADDING * this.dpiScale);

			getApprovedConnections();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Connected patients";
			addChild(this._header);

			this._addConnectionButton = new Button();
			this._addConnectionButton.label = "Add a connection";
			this._addConnectionButton.addEventListener(starling.events.Event.TRIGGERED, onAddConnection);
			addChild(this._addConnectionButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._patientCellContainer = new ScrollContainer();
		}

		private function backBtnHandler(e:starling.events.Event = null):void
		{
			clearDownHCPList();
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function onAddConnection(e:starling.events.Event):void
		{
			clearDownHCPList();
			this.owner.showScreen(HivivaScreens.HCP_ADD_PATIENT);
		}

		private function getApprovedConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE, getApprovedConnectionsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnections();
		}

		private function getApprovedConnectionsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE, getApprovedConnectionsCompleteHandler);

			var xml:XML = e.data.xmlResponse;

			if(xml.children().length() > 0)
			{
				clearDownHCPList();
				var loop:uint = xml.children().length();
				var approvedHCPList:XMLList  = xml.DCConnection;
				for(var i:uint = 0 ; i <loop ; i++)
				{
					var appGuid:String = approvedHCPList[i].ToUserGuid;
					var appId:String = approvedHCPList[i].ToAppId;

					var hcpList:XMLList = new XMLList
					(
							<hcp>
								<name>{appId}</name>
								<email>{appId}@domain.com</email>
								<appid>{appId}</appid>
								<guid>{appGuid}</guid>
								<picture>dummy.png</picture>
							</hcp>
					);
					this._patientFilteredList.push(hcpList);
				}
				initResults();
			}
			else
			{
				trace("No Approved Connections");
			}
		}

		private function initResults():void
		{
			var resultsLength:int = this._patientFilteredList.length;
			var currItem:XMLList;
			var hcpCell:HcpResultCell;

			for(var listCount:int = 0; listCount < resultsLength; listCount++)
			{
				currItem = XMLList(this._patientFilteredList[listCount]);

				hcpCell = new HcpResultCell();
				hcpCell.hcpData = currItem;
				hcpCell.isResult = true;
				hcpCell.scale = this.dpiScale;
				this._patientCellContainer.addChild(hcpCell);
				this._patientCellRadioGroup.addItem(hcpCell._hcpSelect);
			}

			drawResults();
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var yStartPosition:Number;
			var maxHeight:Number;
			var hcpCell:HcpResultCell;

			yStartPosition = this._header.y + this._header.height + scaledPadding;
			maxHeight = this.actualHeight - yStartPosition;
			maxHeight -= (this.actualHeight - this._addConnectionButton.y) + scaledPadding;

			this._patientCellContainer.width = this.actualWidth;
			this._patientCellContainer.y = yStartPosition;
			this._patientCellContainer.height = maxHeight;

			for (var i:int = 0; i < this._patientCellContainer.numChildren; i++)
			{
				hcpCell = this._patientCellContainer.getChildAt(i) as HcpResultCell;
				hcpCell.width = this.actualWidth;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._patientCellContainer.layout = layout;

			this._patientCellContainer.validate();
		}

		private function clearDownHCPList():void
		{
			this._patientFilteredList = [];
			if(!contains(this._patientCellContainer))
			{
				this._patientCellRadioGroup = new ToggleGroup();
				addChild(this._patientCellContainer);
			}
			else
			{
				this._patientCellRadioGroup.removeAllItems();
				this._patientCellContainer.removeChildren();
			}
		}
	}
}
