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
	import flash.data.SQLStatement;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.URLRequest;

	import mx.core.ByteArrayAsset;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;

	import starling.events.Event;
	import starling.textures.Texture;

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
		private var _resultList:Array;
		private var _hcpConnected:Boolean;
		private var _requestPopup:VerticalCenteredPopUpContentManager;

		public function HivivaPatientConnectToHcpScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.validate();

			drawHcpSearch();

			this._backButton.label = "Back";
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Connect to a care provider";
			addChild(this._header);

			getXMLHcpData();
			initHcpSearch();

			this._backButton = new Button();
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function getXMLHcpData():void
		{
			var ba:ByteArrayAsset = ByteArrayAsset(new HcpData());
			this._hcpDataXml = new XML(ba.readUTFBytes(ba.length));
			trace(this._hcpDataXml.hcplist.hcp);
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
				this._resultList = [];
				for(var listCount:Number = 0; listCount < searchListLength; listCount++)
				{
					currItem = searchList[listCount];
					if(currItem.toLowerCase().search(searched.toLowerCase()) != -1)
					{
						this._resultList.push(hcpList[listCount]);
					}
				}
				displayResults();
			}
			else
			{
				this._resultInfo.text = "0 registered doctors found";
			}
		}

		private function displayResults():void
		{
			var resultsLength:int = this._resultList.length,
				currItem:XMLList,
				hcpCell:HcpResultCell,
				gap:Number = 30 * this.dpiScale;

			this._resultInfo.text = resultsLength + " registered doctor" + (resultsLength > 1 ? "s" : "") + " found";
			if(resultsLength > 0)
			{
				if(!contains(this._hcpCellContainer))
				{
					this._hcpCellContainer = new ScrollContainer();
					addChild(this._hcpCellContainer);

					this._hcpCellContainer.width = this.actualWidth;
					this._hcpCellContainer.y = this._resultInfo.y + this._resultInfo.height + gap;
					this._hcpCellContainer.height = this.actualHeight - (this._hcpCellContainer.y);

					var layout:VerticalLayout = new VerticalLayout();
					layout.gap = gap;
					this._hcpCellContainer.layout = layout;

					this._hcpCellRadioGroup = new ToggleGroup();
				}
				else
				{
					removeAllHcpCells();
					_hcpCellRadioGroup.removeAllItems();
				}
				for(var listCount:int = 0; listCount < resultsLength; listCount++)
				{
					currItem = XMLList(this._resultList[listCount]);
					
					hcpCell = new HcpResultCell(currItem,this._hcpCellContainer.width - (100 * this.dpiScale),this.dpiScale);
					hcpCell._isResult = true;
					hcpCell.addEventListener(Event.CLOSE, deleteHcpCell);
					this._hcpCellRadioGroup.addItem(hcpCell._hcpSelect);
					this._hcpCellContainer.addChild(hcpCell);
				}
				this._hcpCellContainer.validate();
				this._requestConnectionButton = new Button();
				this._requestConnectionButton.label = "Request Connection";
				addChild(this._requestConnectionButton);
				this._requestConnectionButton.addEventListener(Event.TRIGGERED, onRequestConnection);
				this._requestConnectionButton.validate();
				this._requestConnectionButton.x = (this.actualWidth / 2) - (this._requestConnectionButton.width / 2);
				this._requestConnectionButton.y = this.actualHeight - this._requestConnectionButton.height - gap;
			}
		}

		private function onRequestConnection(e:Event):void
		{
			var selectedHcpInd:int = this._hcpCellRadioGroup.selectedIndex,
				hcpCell:XMLList = XMLList(this._resultList[selectedHcpInd]);

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			var sqConn:SQLConnection = new SQLConnection();
			sqConn.open(dbFile);

			var sqStatement:SQLStatement = new SQLStatement();

			var name:String = "'" + hcpCell.name + "'";
			var email:String = "'" + hcpCell.email + "'";
			var appid:String = "'" + hcpCell.appid + "'";
			var picture:String = "'" + hcpCell.picture + "'";
			if(this._hcpConnected)
			{
				sqStatement.text = "UPDATE hcp_connection SET name=" + name + ", email=" + email + ", appid=" + appid + ", picture=" + picture;
			}
			else
			{
				sqStatement.text = "INSERT INTO hcp_connection (name, email, appid, picture) VALUES (" + name + ", " + email + ", " + appid + ", " + picture + ")";
			}
			trace(sqStatement.text);
			sqStatement.sqlConnection = sqConn;
			sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			sqStatement.execute();

			initRequestPopup(hcpCell.name);
		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
		}

		private function initRequestPopup(name:String):void
		{
			this._requestPopup = new VerticalCenteredPopUpContentManager();
			var requestPopup:FeathersControl = new FeathersControl();

			var bg:Quad = new Quad(400 * this.dpiScale, 200 * this.dpiScale, 0x000000);
			bg.name = "bg";
			requestPopup.addChild(bg);

			var label:ScrollText = new ScrollText();
			label.isHTML = true;
			label.name = "label";
			label.text = "A request to connect has been sent to Dr " + name;
			requestPopup.addChild(label);

			var closeButton:Button = new Button();
			closeButton.name = "closeBtn";
			closeButton.label = "Close";
			closeButton.addEventListener(Event.TRIGGERED, closePopup);
			requestPopup.addChild(closeButton);

			var items:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			items.push(label);
			items.push(closeButton);

			autoLayout(items, 50 * this.dpiScale);

			label.x = 10 * this.dpiScale;
			closeButton.x = 10 * this.dpiScale;

			var dummy:Sprite = new Sprite();

			this._requestPopup.open(requestPopup, dummy);
		}

		private function closePopup(e:Event):void
		{
			this._requestPopup.close();
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

		private function deleteHcpCell(e:Event):void
		{
			var hcpCell:HcpResultCell = e.target as HcpResultCell;
			this._hcpCellContainer.removeChild(hcpCell);
			hcpCell.dispose();
		}

		private function removeAllHcpCells():void
		{
			var hcpCell:HcpResultCell,
				hcpCellLength:int = this._hcpCellContainer.numChildren - 1;
			for(var hcpCellCount:int = 0; hcpCellCount < hcpCellLength; hcpCellCount++)
			{
				hcpCell = this._hcpCellContainer.getChildAt(hcpCellCount + 1) as HcpResultCell;
				this._hcpCellContainer.removeChild(hcpCell);
				hcpCell.dispose();
			}
		}
	}
}
