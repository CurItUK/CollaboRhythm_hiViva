package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;


	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.layout.VerticalLayout;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.events.SQLEvent;

	import flash.filesystem.File;

	import flash.text.TextFormat;

	import mx.core.ByteArrayAsset;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPAddPatientScreen extends Screen
	{

		private var _header:HivivaHeader;

		private var _patientConnected:Boolean;
		private var _patientCellContainer:ScrollContainer;
		private var _requestConnectionButton:Button;
		private var _requestPopupContainer:HivivaPopUp;
		private var _backButton:Button;
		private var _patientCellRadioGroup:ToggleGroup;
		private var _hcpCellContainer:ScrollContainer;
		private var _hcpCellRadioGroup:ToggleGroup;

		private var _searchInput:TextInput;
		private var _searchButton:Button;
		private var _resultInfo:Label;
		private var _patientFilteredList:Array;


		private var _appIDLabel:Label;

		private const PADDING:Number = 20;

		public function HivivaHCPAddPatientScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();


			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			drawHcpSearch();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Add a patient";
			addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._hcpCellContainer = new ScrollContainer();
		}

		private function backBtnHandler(e:starling.events.Event = null):void
		{
			if(contains(this._patientCellContainer))
			{
				this._patientCellRadioGroup.removeAllItems();
				this._patientCellContainer.removeChildren();
			}

			this.owner.showScreen(HivivaScreens.HCP_CONNECT_PATIENT);
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
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatient(this._searchInput.text);
		}

		private function getPatientCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);

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
				this._patientFilteredList.push(hcpList);
				this._resultInfo.text = "Registered doctor " + this._patientFilteredList[0].appid + " found.";
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
			this._patientFilteredList = [];
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

			yStartPosition = (this._patientConnected ? this._header.y + this._header.height : this._resultInfo.y + this._resultInfo.height) + scaledPadding;
			maxHeight = this.actualHeight - yStartPosition;

			if(!this._patientConnected)
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
			var hcpCell:XMLList = XMLList(this._patientFilteredList[selectedHcpInd]);

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
	}
}
