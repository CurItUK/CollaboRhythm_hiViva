package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.global.HivivaScreens;

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
		private var _radioGroup:ToggleGroup;
		private var _emailRadio:Radio;
		private var _appIdRadio:Radio;
		private var _searchInput:TextInput;
		private var _searchButton:Button;
		private var _resultInfo:Label;
		private var _backButton:Button;
		private var _hcpCellContainer:ScrollContainer;
		private var _hcpCellRadioGroup:ToggleGroup;
		private var _requestConnectionButton:Button;
		private var _hcpFilteredList:Array;
		private var _hcpConnected:Boolean;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;
		private var _requestPopup:VerticalCenteredPopUpContentManager;
		private var _requestPopupContainer:HivivaPopUp;

		private const PADDING:Number = 20;

		public function HivivaPatientConnectToHcpScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
			// reduce font size for large title
			/*this._header._titleHolder1.textRendererProperties.textFormat = new TextFormat("ExoBold", Math.round(36 * this.dpiScale), 0x293d54);
			this._header._titleHolder2.textRendererProperties.textFormat = new TextFormat("ExoLight", Math.round(36 * this.dpiScale), 0x293d54);
			this._header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			this._header.validate();*/

			this._requestConnectionButton.validate();
			this._requestConnectionButton.x = (this.actualWidth / 2) - (this._requestConnectionButton.width / 2);
			this._requestConnectionButton.y = this.actualHeight - this._requestConnectionButton.height - (PADDING * this.dpiScale);

			if(this._hcpConnected)
			{
				drawResults();
			}
			else
			{
				drawHcpSearch();

				this._requestPopupContainer.width = 500 * dpiScale;
				this._requestPopupContainer.validate();
			}

			this._backButton.validate();
		}

		override protected function initialize():void
		{
			super.initialize();



			this._header = new HivivaHeader();
			this._header.title = "Connect to a care provider";
			addChild(this._header);

			this._hcpCellContainer = new ScrollContainer();

			this._requestConnectionButton = new Button();
			this._requestConnectionButton.label = "Request Connection";
			addChild(this._requestConnectionButton);
			this._requestConnectionButton.addEventListener(Event.TRIGGERED, onRequestConnection);
			this._requestConnectionButton.visible = false;

			this._hcpConnected = hcpConnectionCheck();
			if(this._hcpConnected)
			{
				trace("hcp is connected");
				initResults(false);
			}
			else
			{
				trace("hcp is not connected");
				initHcpSearch();

				this._requestPopupContainer = new HivivaPopUp();
				this._requestPopupContainer.scale = this.dpiScale;
				this._requestPopupContainer.confirmLabel = "Close";
				this._requestPopupContainer.addEventListener(Event.COMPLETE, closePopup);
				this._requestPopupContainer.addEventListener(Event.CLOSE, closePopup);
			}


			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
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



		private function initHcpSearch():void
		{

			//TODO Remove EMAIL radio option
			this._radioGroup = new ToggleGroup();

			this._emailRadio = new Radio();
			this._emailRadio.label = "Provider's email address";
			this._radioGroup.addItem(this._emailRadio);
			addChild(this._emailRadio);

			this._appIdRadio = new Radio();
			this._appIdRadio.label = "Provider's app ID";
			this._radioGroup.addItem(this._appIdRadio);
			addChild(this._appIdRadio);

			this._searchInput = new TextInput();
			addChild(this._searchInput);

			this._searchButton = new Button();
			this._searchButton.label = "Connect";
			this._searchButton.addEventListener(Event.TRIGGERED, doSearchHcp);
			addChild(this._searchButton);

			this._resultInfo = new Label();
			addChild(this._resultInfo);
		}

		private function drawHcpSearch():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var horizontalAlign:Number = 32 * this.dpiScale;

			this._emailRadio.validate();
			this._appIdRadio.validate();
			this._searchInput.validate();
			this._searchButton.validate();
			this._resultInfo.validate();

			this._emailRadio.y = this._header.y + this._header.height + scaledPadding;

			this._appIdRadio.y = this._emailRadio.y + this._emailRadio.height;

			this._searchInput.y = this._appIdRadio.y + this._appIdRadio.height;
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

			/*





			var hcpList:XMLList = this._hcpDataXml.hcp,
				searchList:XMLList = hcpList[Boolean(this._radioGroup.selectedIndex) ? "appid" : "email"],
				searchListLength:int = searchList.length(),
				searched:String = this._searchInput.text,
				currItem:String;

			if(searchListLength > 0)
			{
				this._hcpFilteredList = [];
				for(var listCount:Number = 0; listCount < searchListLength; listCount++)
				{
					currItem = searchList[listCount];
					if(currItem.toLowerCase().search(searched.toLowerCase()) != -1)
					{
						this._hcpFilteredList.push(hcpList[listCount]);
					}
				}
				initResults(true);
			}
			else
			{
				this._resultInfo.text = "0 registered doctors found";
			}

			*/
		}

		private function getHCPCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);
			trace("getHCPCompleteHandler " + e.data.AppId);
			//TODO web service to provide null value back if no HCP's Found.


			var hcpList:XMLList = new XMLList
			(
					<hcp>
						<name>HCP Display name</name>
						<email>hcp@domain.com</email>
						<appid>e.data.xmlResponse.AppId</appid>
						<picture>dummy.png</picture>
					</hcp>
			);
			this._hcpFilteredList.push(hcpList);
			initResults(true);
		}

		private function initResults(isResult:Boolean):void
		{
			var resultsLength:int = this._hcpFilteredList.length,
				currItem:XMLList,
				hcpCell:HcpResultCell;

			if (isResult)
			{
				this._resultInfo.text = "Registered doctor " + this._hcpFilteredList[0].@appid + " found.";
				this._resultInfo.validate();
			}
			if(resultsLength > 0)
			{
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
				for(var listCount:int = 0; listCount < resultsLength; listCount++)
				{
					currItem = XMLList(this._hcpFilteredList[listCount]);
					
					hcpCell = new HcpResultCell();
					hcpCell.hcpData = currItem;
					hcpCell.isResult = isResult;
					hcpCell.scale = this.dpiScale;
					hcpCell.addEventListener(Event.CLOSE, deleteHcpRecord);
					hcpCell.addEventListener(Event.REMOVED_FROM_STAGE, deleteHcpCell);
					this._hcpCellContainer.addChild(hcpCell);
					this._hcpCellRadioGroup.addItem(hcpCell._hcpSelect);
				}
				if (isResult) drawResults();

				this._requestConnectionButton.visible = true;
			}
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale,
				yStartPosition:Number,
				maxHeight:Number,
				hcpCell:HcpResultCell;

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
			var selectedHcpInd:int = this._hcpCellRadioGroup.selectedIndex,
				hcpCell:XMLList = XMLList(this._hcpFilteredList[selectedHcpInd]);

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();

			var name:String = "'" + hcpCell.name + "'";
			var email:String = "'" + hcpCell.email + "'";
			var appid:String = "'" + hcpCell.appid + "'";
			var picture:String = "'" + hcpCell.picture + "'";
			if(this._hcpConnected)
			{
				this._sqStatement.text = "UPDATE hcp_connection SET name=" + name + ", email=" + email + ", appid=" + appid + ", picture=" + picture;
			}
			else
			{
				this._sqStatement.text = "INSERT INTO hcp_connection (name, email, appid, picture) VALUES (" + name + ", " + email + ", " + appid + ", " + picture + ")";
			}
			trace(this._sqStatement.text);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();

			this._requestPopupContainer.message = "A request to connect has been sent to " + hcpCell.name;
			showRequestPopup();
		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
		}

		private function hcpConnectionCheck():Boolean
		{
			var returnBool:Boolean;
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM hcp_connection";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();

			var sqlRes:SQLResult = this._sqStatement.getResult();
			//trace(sqlRes.data[0].name);
			returnBool = true;
			try
			{
				this._hcpFilteredList = [XML("<hcp><name>" + sqlRes.data[0].name + "</name><email>" + sqlRes.data[0].email + "</email><appid>" + sqlRes.data[0].appid + "</appid><picture>" + sqlRes.data[0].picture + "</picture></hcp>")];
			}
			catch(e:Error)
			{
				//trace("fail");
				this._hcpFilteredList = [];
				returnBool = false;
			}
			return returnBool;
		}

		private function showRequestPopup():void
		{
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
