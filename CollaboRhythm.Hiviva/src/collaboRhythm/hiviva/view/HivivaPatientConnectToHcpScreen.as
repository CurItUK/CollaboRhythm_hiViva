package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.controls.TextInput;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.core.FeathersControl;
	import feathers.core.ToggleGroup;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import mx.core.ByteArrayAsset;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	import starling.events.Event;

	public class HivivaPatientConnectToHcpScreen extends ScreenBase
	{
		[Embed("/resources/dummy_hcplist.xml", mimeType="application/octet-stream")]
		private static const HcpData:Class;

		private var _header:Header;
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
		private var _requestPopupContainer:FeathersControl;

		public function HivivaPatientConnectToHcpScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.validate();

			if(!this._hcpConnected)
			{
				drawHcpSearch();
				drawRequestPopup();

				this._requestConnectionButton.validate();
				this._requestConnectionButton.x = (this.actualWidth / 2) - (this._requestConnectionButton.width / 2);
				this._requestConnectionButton.y = this.actualHeight - this._requestConnectionButton.height - (30 * this.dpiScale);
			}
			drawResults();

			this._backButton.label = "Back";
			this._backButton.validate();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Connect to a care provider";
			addChild(this._header);

			getXMLHcpData();
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
			}
			else
			{
				trace("hcp is not connected");
				initHcpSearch();
				initRequestPopup();
			}
			initResults(!this._hcpConnected);

			this._backButton = new Button();
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

		private function getXMLHcpData():void
		{
			var ba:ByteArrayAsset = ByteArrayAsset(new HcpData());
			this._hcpDataXml = new XML(ba.readUTFBytes(ba.length));
			//trace(this._hcpDataXml.hcplist.hcp);
		}

		private function initHcpSearch():void
		{
			this._radioGroup = new ToggleGroup();

			this._emailRadio = new Radio();
			this._radioGroup.addItem(this._emailRadio);
			addChild(this._emailRadio);

			this._appIdRadio = new Radio();
			this._radioGroup.addItem(this._appIdRadio);
			addChild(this._appIdRadio);

			this._searchInput = new TextInput();
			addChild(this._searchInput);

			this._searchButton = new Button();
			this._searchButton.addEventListener(Event.TRIGGERED, doSearchHcp);
			addChild(this._searchButton);

			this._resultInfo = new Label();
			addChild(this._resultInfo);
		}

		private function drawHcpSearch():void
		{
			var gap:Number = 30 * this.dpiScale;
			this._emailRadio.label = "Provider's email address";
			this._emailRadio.validate();

			this._appIdRadio.label = "Provider's app ID";
			this._appIdRadio.validate();

			this._searchInput.validate();

			this._searchButton.label = "Connect";
			this._searchButton.validate();

			this._resultInfo.validate();

			this._emailRadio.y = this._header.height + gap;
			this._appIdRadio.y = this._emailRadio.y + this._emailRadio.height + gap;
			this._searchInput.y = this._appIdRadio.y + this._appIdRadio.height + gap;
			this._searchButton.y = this._searchInput.y;
			this._searchButton.x = this._searchInput.x + this._searchInput.width + gap;
			this._resultInfo.y = this._searchInput.y + this._searchInput.height + gap;
		}

		private function doSearchHcp(e:Event):void
		{
			var hcpList:XMLList = this._hcpDataXml.hcp,
				searchList:XMLList = hcpList[Boolean(this._radioGroup.selectedIndex) ? "appid" : "email"],
				searchListLength:int = searchList.length(),
				searched:String = this._searchInput.text,
				currItem:String;

			if(searched.length == 0) return;

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
				this._requestConnectionButton.visible = true;
			}
			else
			{
				this._resultInfo.text = "0 registered doctors found";
			}
		}

		private function initResults(isResult:Boolean):void
		{
			var resultsLength:int = this._hcpFilteredList.length,
				currItem:XMLList,
				hcpCell:HcpResultCell;

			if (isResult) this._resultInfo.text = resultsLength + " registered doctor" + (resultsLength > 1 ? "s" : "") + " found";
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
					
					hcpCell = new HcpResultCell(currItem,(500 * this.dpiScale),this.dpiScale);
					hcpCell._isResult = isResult;
					hcpCell.addEventListener(Event.CLOSE, deleteHcpRecord);
					hcpCell.addEventListener(Event.REMOVED_FROM_STAGE, deleteHcpCell);
					this._hcpCellRadioGroup.addItem(hcpCell._hcpSelect);
					this._hcpCellContainer.addChild(hcpCell);
				}
			}
		}

		private function drawResults():void
		{
			var gap:Number = 30 * this.dpiScale,
				yStartPosition:Number = this._hcpConnected ? this._header.y + this._header.height : this._resultInfo.y + this._resultInfo.height,
				maxHeight:Number = this.actualHeight - yStartPosition;

			this._hcpCellContainer.width = this.actualWidth;
			this._hcpCellContainer.y = yStartPosition + gap;
			this._hcpCellContainer.height = this._hcpConnected ? maxHeight : maxHeight - (this.actualHeight - this._requestConnectionButton.y);
			//trace(this._hcpCellContainer.height);

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = gap;
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

			setRequestPopupLabel(hcpCell.name);
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

		private function initRequestPopup():void
		{
			this._requestPopup = new VerticalCenteredPopUpContentManager();
			this._requestPopupContainer = new FeathersControl();

			var bg:Quad = new Quad(400 * this.dpiScale, 200 * this.dpiScale, 0x000000);
			bg.name = "bg";
			this._requestPopupContainer.addChild(bg);

			var label:ScrollText = new ScrollText();
			label.isHTML = true;
			label.name = "label";
			this._requestPopupContainer.addChild(label);

			var closeButton:Button = new Button();
			closeButton.name = "closeBtn";
			closeButton.label = "Close";
			closeButton.addEventListener(Event.TRIGGERED, closePopup);
			this._requestPopupContainer.addChild(closeButton);
		}

		private function setRequestPopupLabel(name:String):void
		{
			var label:ScrollText = this._requestPopupContainer.getChildByName("label") as ScrollText;
			label.text = "A request to connect has been sent to " + name;

			var dummy:Sprite = new Sprite();
			this._requestPopup.open(this._requestPopupContainer, dummy);
			this.draw();
		}

		private function closePopup(e:Event):void
		{
			this._requestPopup.close();
			backBtnHandler();
		}

		private function drawRequestPopup():void
		{
			var bg:Quad = this._requestPopupContainer.getChildByName("bg") as Quad;
			var label:ScrollText = this._requestPopupContainer.getChildByName("label") as ScrollText;
			var closeButton:Button = this._requestPopupContainer.getChildByName("closeBtn") as Button;

			label.invalidate();
			closeButton.invalidate();

			this._requestPopupContainer.width = bg.width;
			this._requestPopupContainer.height = bg.height;
			this._requestPopupContainer.invalidate();

			var items:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			items.push(label);
			items.push(closeButton);

			autoLayout(items, 50 * this.dpiScale);

			label.x = 10 * this.dpiScale;
			closeButton.x = 10 * this.dpiScale;
		}

		private function autoLayout(items:Vector.<DisplayObject>, gap:Number):void
		{
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.x = 0;
			bounds.y = this._header.height;
			bounds.maxHeight = this.actualHeight - this._header.height;
			bounds.maxWidth = this.actualWidth;

			var contentLayout:VerticalLayout = new VerticalLayout();
			contentLayout.gap = gap;
			contentLayout.layout(items,bounds);
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
