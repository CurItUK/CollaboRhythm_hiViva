package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.Label;


	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.layout.VerticalLayout;

	import flash.text.SoftKeyboardType;


	import starling.display.DisplayObject;


	import starling.events.Event;


	public class HivivaPatientAddHCP extends Screen
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
		private var _requestPopup:VerticalCenteredPopUpContentManager;
		private var _requestPopupContainer:HivivaPopUp;
		private var _appIDLabel:Label;



		private const PADDING:Number = 20;

		public function HivivaPatientAddHCP()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			drawHcpSearch();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Add a care provider";
			addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._hcpCellContainer = new ScrollContainer();
		}

		private function backBtnHandler(e:starling.events.Event = null):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN);
		}

		private function drawHcpSearch():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var horizontalAlign:Number = 32 * this.dpiScale;

			this._appIDLabel = new Label();
			this._appIDLabel.text = "AppID";
			this.addChild(this._appIDLabel);

			this._searchInput = new TextInput();
			this._searchInput.textEditorProperties.softKeyboardType = SoftKeyboardType.NUMBER;
			this._searchInput.textEditorProperties.restrict = "0-9\\-";
			this._searchInput.textEditorProperties.maxChars = 11;
			//this._searchInput.addEventListener( Event.CHANGE, searchInputChangeHandler );
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

		private function searchInputChangeHandler(event:Event):void
		{

			this._searchInput.selectRange(this._searchInput.text.length);
			this._searchInput.validate();
			if(this._searchInput.text.length == 3)
			{
				trace("searchInputChangeHandler " + this._searchInput.text.length);
				this._searchInput.text += "-";
				trace("searchInputChangeHandler " + this._searchInput.text.length);
				this._searchInput.selectRange(this._searchInput.text.length);
				this._searchInput.setFocus();
			}

		}

		private function doSearchHcp(e:Event):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getHCP(this._searchInput.text);
		}

		private function getHCPCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);

			trace("e.data.xmlResponse.AppId " + e.data.xmlResponse.AppId);
			trace("e.data.xmlResponse.AppGuid " + e.data.xmlResponse.AppGuid);

			var appGuid:String = e.data.xmlResponse.AppGuid;
			var appId:String = e.data.xmlResponse.AppId;
			var fullName:String = e.data.xmlResponse.FirstName + " " + e.data.xmlResponse.LastName;

			if(e.data.xmlResponse.AppGuid != "00000000-0000-0000-0000-000000000000")
			{
				clearDownHCPList();
				var hcpList:XMLList = new XMLList
				(
						<hcp>
							<name>{fullName}</name>
							<email>{appId}</email>
							<appid>{appId}</appid>
							<guid>{appGuid}</guid>
							<picture>dummy.png</picture>
						</hcp>
				);
				this._hcpFilteredList.push(hcpList);
				this._resultInfo.text = "Registered care provider " + this._hcpFilteredList[0].appid + " found.";
				this._resultInfo.validate();

				initResults();
			}
			else
			{
				this._resultInfo.text = "0 registered care providers found";
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
				this._hcpCellContainer.addChild(hcpCell);
				//this._hcpCellRadioGroup.addItem(hcpCell._hcpSelect);
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
			//var selectedHcpInd:int = this._hcpCellRadioGroup.selectedIndex;
			var hcpCell:XMLList = XMLList(this._hcpFilteredList[0]);

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE , establishConnectionHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.establishConnection(HivivaStartup.userVO.guid , hcpCell.guid);
		}

		private function establishConnectionHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE , establishConnectionHandler);

			var msg:String = "An error occurred please try again.";
			var responseStatus:String = e.data.xmlResponse.StatusCode;

			switch (responseStatus)
			{
				case "1" :
					msg = "A request to connect has been sent.";
					break;

				case "5" :
					msg = "A request to this user has already been sent";
					break;
			}

			this._requestPopupContainer = new HivivaPopUp();
			this._requestPopupContainer.buttons = ["Close"];
			this._requestPopupContainer.addEventListener(Event.TRIGGERED, closePopup);
			this._requestPopupContainer.validate();
			this._requestPopupContainer.message = msg;

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

		override public function dispose():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE , establishConnectionHandler);
			super.dispose();
		}
	}
}
