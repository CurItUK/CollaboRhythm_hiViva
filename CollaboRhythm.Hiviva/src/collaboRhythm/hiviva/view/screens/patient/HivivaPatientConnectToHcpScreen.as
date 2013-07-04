package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.HivivaStartup;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import feathers.controls.TextInput;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.core.FeathersControl;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.text.TextFormat;

	import mx.core.ByteArrayAsset;

	import collaboRhythm.hiviva.view.HivivaHeader;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	import starling.events.Event;

	public class HivivaPatientConnectToHcpScreen extends Screen
	{

		private var _header:HivivaHeader;
		private var _hcpDataXml:XML;

		private var _searchInput:TextInput;
		private var _searchButton:Button;
		private var _resultInfo:Label;
		private var _backButton:Button;
		private var _hcpCellContainer:ScrollContainer;
		private var _hcpCellRadioGroup:ToggleGroup;
		private var _requestConnectionButton:Button;
		private var _hcpFilteredList:Array = [];
		private var _hcpConnected:Boolean;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;
		private var _requestPopup:VerticalCenteredPopUpContentManager;
		private var _requestPopupContainer:HivivaPopUp;

		private const PADDING:Number = 20;
		private var _appIDLabel:Label;

		public function HivivaPatientConnectToHcpScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
			this._backButton.validate();

			getApprovedConnections();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Connect to a care provider";
			addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

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

		private function getApprovedConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedConnectionsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnections();
		}

		private function getApprovedConnectionsHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedConnectionsHandler);
			trace("getApprovedConnections " + e.data.xmlResponse);
			var xml:XML = e.data.xmlResponse;

			if(xml.children().length() > 0)
			{

				initApprovedConnections();

			}
			drawHcpSearch();
		}

		private function initApprovedConnections():void
		{

		}

		private function drawHcpSearch():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var horizontalAlign:Number = 32 * this.dpiScale;

			this._appIDLabel = new Label();
			this._appIDLabel.text = "AppID";
			this.addChild(this._appIDLabel);

			this._searchInput = new TextInput();
			addChild(this._searchInput);

			this._searchButton = new Button();
			this._searchButton.label = "Connect";
			this._searchButton.addEventListener(Event.TRIGGERED, doSearchHcp);
			addChild(this._searchButton);

			this._resultInfo = new Label();
			addChild(this._resultInfo);

			this._appIDLabel.validate();
			this._searchInput.validate();
			this._searchButton.validate();
			this._resultInfo.validate();

			this._appIDLabel.y = this._header.y + this._header.height + scaledPadding;
			this._appIDLabel.x = horizontalAlign;

			this._searchInput.y =this._appIDLabel.y + this._appIDLabel.height + + scaledPadding;
			this._searchInput.x = horizontalAlign;
			this._searchInput.width = this.actualWidth - this._searchButton.width - (scaledPadding * 2) - horizontalAlign;

			this._searchButton.y = this._searchInput.y + (this._searchInput.height * 0.5) - (this._searchButton.height * 0.5);
			this._searchButton.x = this._searchInput.x + this._searchInput.width + scaledPadding;

			this._resultInfo.y = this._searchInput.y + this._searchInput.height + (scaledPadding * 0.5);
			this._resultInfo.x = horizontalAlign;
			this._resultInfo.width = this.actualWidth - scaledPadding - horizontalAlign;
		}

		private function doSearchHcp(e:Event):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getHCP(this._searchInput.text);
		}

		private function getHCPCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);

			trace("e.data.xmlResponse.AppId " + e.data.xmlResponse.AppId);
			trace("e.data.xmlResponse.AppGuid " + e.data.xmlResponse.AppGuid);

			var appGuid:String = e.data.xmlResponse.AppGuid;
			var appId:String = e.data.xmlResponse.AppId;



			if(e.data.xmlResponse.AppGuid != "00000000-0000-0000-0000-000000000000")
			{
				clearDownHCPList();
				var hcpList:XMLList = new XMLList
				(
						<hcp>
							<name>HCP Display name</name>
							<email>hcp@domain.com</email>
							<appid>{appId}</appid>
							<guid>{appGuid}</guid>
							<picture>dummy.png</picture>
						</hcp>
				);
				this._hcpFilteredList.push(hcpList);
				this._resultInfo.text = "Registered doctor " + this._hcpFilteredList[0].appid + " found.";
				this._resultInfo.validate();

				initResults();
			}
			else
			{
				this._resultInfo.text = "0 registered doctors found";
				this._resultInfo.validate();
			}
		}

		private function initResults():void
		{
			var resultsLength:int = this._hcpFilteredList.length;
			var currItem:XMLList;
			var hcpCell:HcpResultCell;

			for(var listCount:int = 0; listCount < resultsLength; listCount++)
			{
				currItem = XMLList(this._hcpFilteredList[listCount]);

				hcpCell = new HcpResultCell();
				hcpCell.hcpData = currItem;
				hcpCell.isResult = true;
				hcpCell.scale = this.dpiScale;
				hcpCell.addEventListener(Event.CLOSE, deleteHcpRecord);
				hcpCell.addEventListener(Event.REMOVED_FROM_STAGE, deleteHcpCell);
				this._hcpCellContainer.addChild(hcpCell);
				this._hcpCellRadioGroup.addItem(hcpCell._hcpSelect);
			}


			this._requestConnectionButton = new Button();
			this._requestConnectionButton.label = "Request Connection";
			this._requestConnectionButton.addEventListener(Event.TRIGGERED, onRequestConnection);
			addChild(this._requestConnectionButton);

			this._requestConnectionButton.validate();
			this._requestConnectionButton.x = (this.actualWidth / 2) - (this._requestConnectionButton.width / 2);
			this._requestConnectionButton.y = this.actualHeight - this._requestConnectionButton.height - (PADDING * this.dpiScale);

			drawResults();
		}

		private function  clearDownHCPList():void
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
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var yStartPosition:Number;
			var maxHeight:Number;
			var hcpCell:HcpResultCell;

			yStartPosition = (this._hcpConnected ? this._header.y + this._header.height : this._resultInfo.y + this._resultInfo.height) + scaledPadding;
			maxHeight = this.actualHeight - yStartPosition;

			if(!this._hcpConnected)
			{
				maxHeight -= (this.actualHeight - this._requestConnectionButton.y) + scaledPadding;
			}

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

		private function onRequestConnection(e:Event):void
		{
			var selectedHcpInd:int = this._hcpCellRadioGroup.selectedIndex;
			var hcpCell:XMLList = XMLList(this._hcpFilteredList[selectedHcpInd]);

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE , establishConnectionHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.establishConnection(HivivaStartup.userVO.guid , hcpCell.guid);
		}

		private function establishConnectionHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE , establishConnectionHandler);

			this._requestPopupContainer = new HivivaPopUp();
			this._requestPopupContainer.scale = this.dpiScale;
			this._requestPopupContainer.confirmLabel = "Close";
			this._requestPopupContainer.addEventListener(Event.COMPLETE, closePopup);
			this._requestPopupContainer.addEventListener(Event.CLOSE, closePopup);
			this._requestPopupContainer.width = 500 * dpiScale;
			this._requestPopupContainer.validate();
			this._requestPopupContainer.message = "A request to connect has been sent.";

			PopUpManager.addPopUp(this._requestPopupContainer,true,true);
			this._requestPopupContainer.validate();
			PopUpManager.centerPopUp(this._requestPopupContainer);
			// draw close button post center so the centering works correctly
			this._requestPopupContainer.drawCloseButton();
		}

		private function closePopup(e:Event):void
		{
			PopUpManager.removePopUp(this._requestPopupContainer);
			backBtnHandler();
		}




		private function deleteHcpRecord(e:Event):void
		{
			//var hcpCell:HcpResultCell = e.target as HcpResultCell;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			//this._sqStatement.text = "DELETE FROM hcp_connection WHERE appid=" + hcpCell._appid;

			// deletes all records because we only have one connection at a time
			this._sqStatement.text = "DELETE FROM hcp_connection";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();

			backBtnHandler();
		}

		private function deleteHcpCell(e:Event):void
		{
			var hcpResultCell:HcpResultCell = e.target as HcpResultCell;
			hcpResultCell.dispose();
		}
	}
}

//			this._hcpFilteredList = [XML("<hcp><name>" + sqlRes.data[0].name + "</name><email>" + sqlRes.data[0].email + "</email><appid>" + sqlRes.data[0].appid + "</appid><picture>" + sqlRes.data[0].picture + "</picture></hcp>")];

