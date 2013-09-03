package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.HivivaStartup;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.core.ToggleGroup;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaPatientConnectToHcpScreen extends Screen
	{

		private var _header:HivivaHeader;
		private var _addConnectionButton:Button;
		private var _backButton:Button;
		private var _hcpCellContainer:ScrollContainer;
		private var _hcpCellRadioGroup:ToggleGroup;
		private var _hcpFilteredList:Array = [];
		private var _hcpConnected:Boolean;

		private const PADDING:Number = 20;

		public function HivivaPatientConnectToHcpScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

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
			this._header.title = "Connected care providers";
			addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._addConnectionButton = new Button();
			this._addConnectionButton.label = "Add a connection";
			this._addConnectionButton.addEventListener(Event.TRIGGERED, onAddConnection);
			addChild(this._addConnectionButton);

			this._hcpCellContainer = new ScrollContainer();

		}

		private function backBtnHandler(e:Event = null):void
		{
			if(contains(this._hcpCellContainer))
			{
				this._hcpCellRadioGroup.removeAllItems();
				this._hcpCellContainer.removeChildren();
			}

			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function onAddConnection(e:Event):void
		{
//			clearDownHCPList();
			this.owner.showScreen(HivivaScreens.PATIENT_ADD_HCP);
		}

		private function getApprovedConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE, getApprovedHCPCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnections();
		}

		private function getApprovedHCPCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedHCPCompleteHandler);

			var xml:XML = e.data.xmlResponse;

			if(xml.children().length() > 0)
			{
				HivivaStartup.connectionsVO.users = [];
				var loop:uint = xml.children().length();
				var approvedHCPList:XMLList  = xml.DCConnection;
				for(var i:uint = 0 ; i <loop ; i++)
				{
					var establishedUser:Object = HivivaModifier.establishToFromId(approvedHCPList[i]);
					var appGuid:String = establishedUser.appGuid;
					var appId:String = establishedUser.appId;
					var userEstablishedConnection:Boolean = approvedHCPList[i].FromAppId == HivivaStartup.userVO.appId;

					var data:XML = new XML
					(
							<patient>
								<name>{appId}</name>
								<email>{appId}@domain.com</email>
								<appid>{appId}</appid>
								<guid>{appGuid}</guid>
								<picture>dummy.png</picture>
								<establishedConnection>{userEstablishedConnection}</establishedConnection>
							</patient>
					);
					HivivaStartup.connectionsVO.users.push(data);
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
			this._hcpFilteredList = HivivaStartup.connectionsVO.users;
			var resultsLength:int = this._hcpFilteredList.length;
			var currItem:XMLList;
			var hcpCell:HcpResultCell;

			for(var listCount:int = 0; listCount < resultsLength; listCount++)
			{
				currItem = XMLList(this._hcpFilteredList[listCount]);

				hcpCell = new HcpResultCell();
				hcpCell.hcpData = currItem;
				hcpCell.isResult = false;
				hcpCell.scale = this.dpiScale;
				this._hcpCellContainer.addChild(hcpCell);
				//this._hcpCellRadioGroup.addItem(hcpCell._hcpSelect);
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

			this._hcpCellContainer.width = this.actualWidth;
			this._hcpCellContainer.y = yStartPosition;
			this._hcpCellContainer.height = maxHeight;

			for (var i:int = 0; i < this._hcpCellContainer.numChildren; i++)
			{
				hcpCell = this._hcpCellContainer.getChildAt(i) as HcpResultCell;
				hcpCell.width = this.actualWidth;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._hcpCellContainer.layout = layout;

			this._hcpCellContainer.validate();
		}
		/*private function  clearDownHCPList():void
		{
			this._hcpFilteredList = [];
			if(!contains(this._hcpCellContainer))
			{
				this._hcpCellRadioGroup = new ToggleGroup();
				addChild(this._hcpCellContainer);
			}
			else
			{
				this._hcpCellRadioGroup.removeAllItems();
				this._hcpCellContainer.removeChildren();
			}
		}*/
	}
}




















