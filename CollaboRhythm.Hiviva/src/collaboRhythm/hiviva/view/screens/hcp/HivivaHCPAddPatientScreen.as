package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.HivivaScreens;
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

	import flash.filesystem.File;

	import flash.text.TextFormat;

	import mx.core.ByteArrayAsset;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPAddPatientScreen extends Screen
	{
		[Embed("/resources/dummy_patientlist.xml", mimeType="application/octet-stream")]
		private static const PatientData:Class;

		private var _header:HivivaHeader;
		private var _patientDataXml:XML;
		private var _patientCellContainer:ScrollContainer;
		private var _requestConnectionButton:Button;
		private var _requestPopupContainer:HivivaPopUp;
		private var _backButton:Button;
		private var _patientCellRadioGroup:ToggleGroup;
		private var _appIdLabel:Label;
		private var _searchInput:TextInput;
		private var _searchButton:Button;
		private var _resultInfo:Label;
		private var _patientFilteredList:Array;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;

		private const PADDING:Number = 20;

		public function HivivaHCPAddPatientScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
			// reduce font size for large title
			this._header._titleHolder1.textRendererProperties.textFormat = new TextFormat("ExoBold", Math.round(36 * this.dpiScale), 0x293d54);
			this._header._titleHolder2.textRendererProperties.textFormat = new TextFormat("ExoLight", Math.round(36 * this.dpiScale), 0x293d54);
			this._header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			this._header.validate();

			this._requestConnectionButton.validate();
			this._requestConnectionButton.x = (this.actualWidth / 2) - (this._requestConnectionButton.width / 2);
			this._requestConnectionButton.y = this.actualHeight - this._requestConnectionButton.height - (PADDING * this.dpiScale);

			drawPatientSearch();

			this._requestPopupContainer.width = 500 * dpiScale;
			this._requestPopupContainer.validate();
		}

		override protected function initialize():void
		{
			super.initialize();

			getXMLPatientData();

			this._header = new HivivaHeader();
			this._header.title = "Add a patient";
			addChild(this._header);

			this._patientCellContainer = new ScrollContainer();

			this._requestConnectionButton = new Button();
			this._requestConnectionButton.label = "Request Connection";
			addChild(this._requestConnectionButton);
			this._requestConnectionButton.addEventListener(Event.TRIGGERED, onRequestConnection);
			this._requestConnectionButton.visible = false;

			initPatientSearch();

			this._requestPopupContainer = new HivivaPopUp();
			this._requestPopupContainer.scale = this.dpiScale;
			this._requestPopupContainer.confirmLabel = "Close";
			this._requestPopupContainer.addEventListener(Event.COMPLETE, closePopup);
			this._requestPopupContainer.addEventListener(Event.CLOSE, closePopup);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function backBtnHandler(e:Event = null):void
		{
			if(contains(this._patientCellContainer))
			{
				this._patientCellRadioGroup.removeAllItems();
				this._patientCellContainer.removeChildren();
			}

			this.owner.showScreen(HivivaScreens.HCP_CONNECT_PATIENT);
		}

		private function getXMLPatientData():void
		{
			var ba:ByteArrayAsset = ByteArrayAsset(new PatientData());
			this._patientDataXml = new XML(ba.readUTFBytes(ba.length));
		}

		private function initPatientSearch():void
		{
			this._appIdLabel = new Label();
			this._appIdLabel.text = "Patient app ID";
			addChild(this._appIdLabel);

			this._searchInput = new TextInput();
			addChild(this._searchInput);

			this._searchButton = new Button();
			this._searchButton.label = "Connect";
			this._searchButton.addEventListener(Event.TRIGGERED, doSearchPatient);
			addChild(this._searchButton);

			this._resultInfo = new Label();
			addChild(this._resultInfo);
		}

		private function drawPatientSearch():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var horizontalAlign:Number = 32 * this.dpiScale;

			this._appIdLabel.validate();
			this._searchInput.validate();
			this._searchButton.validate();
			this._resultInfo.validate();

			this._appIdLabel.y = this._header.y + this._header.height + scaledPadding;

			this._searchInput.y = this._appIdLabel.y + this._appIdLabel.height;
			this._searchInput.x = horizontalAlign;
			this._searchInput.width = this.actualWidth - this._searchButton.width - (scaledPadding * 2) - horizontalAlign;

			this._searchButton.y = this._searchInput.y + (this._searchInput.height * 0.5) - (this._searchButton.height * 0.5);
			this._searchButton.x = this._searchInput.x + this._searchInput.width + scaledPadding;

			this._resultInfo.y = this._searchInput.y + this._searchInput.height + (scaledPadding * 0.5);
			this._resultInfo.x = horizontalAlign;
			this._resultInfo.width = this.actualWidth - scaledPadding - horizontalAlign;
		}

		private function doSearchPatient(e:Event):void
		{
			var patientList:XMLList = this._patientDataXml.patient,
				patientListLength:int = patientList.length(),
				searched:String = this._searchInput.text,
				currItem:String;

			if(patientListLength > 0)
			{
				this._patientFilteredList = [];
				for(var listCount:Number = 0; listCount < patientListLength; listCount++)
				{
					currItem = patientList[listCount];
					if(currItem.toLowerCase().search(searched.toLowerCase()) != -1)
					{
						this._patientFilteredList.push(currItem);
					}
				}
				initResults();
				this._requestConnectionButton.visible = true;
			}
			else
			{
				this._resultInfo.text = "0 registered patients found";
			}
		}

		private function initResults():void
		{
			var resultsLength:int = this._patientFilteredList.length,
				currItem:XMLList,
				patientCell:PatientResultCell;

			this._resultInfo.text = resultsLength + " registered patient" + (resultsLength > 1 ? "s" : "") + " found";
			this._resultInfo.validate();

			if(resultsLength > 0)
			{
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
				for(var listCount:int = 0; listCount < resultsLength; listCount++)
				{
					currItem = XMLList(this._patientFilteredList[listCount]);

					patientCell = new PatientResultCell();
					patientCell.patientData = currItem;
					patientCell.isResult = true;
					patientCell.scale = this.dpiScale;
					this._patientCellContainer.addChild(patientCell);
					this._patientCellRadioGroup.addItem(patientCell._patientSelect);
				}
				drawResults();
			}
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale,
				yStartPosition:Number,
				maxHeight:Number,
				patientCell:PatientResultCell;

			yStartPosition = (this._resultInfo.y + this._resultInfo.height) + scaledPadding;
			maxHeight = this.actualHeight - yStartPosition;

			maxHeight -= (this.actualHeight - this._requestConnectionButton.y) + scaledPadding;

			this._patientCellContainer.width = this.actualWidth;
			this._patientCellContainer.y = yStartPosition;
			this._patientCellContainer.height = maxHeight;

			for (var i:int = 0; i < this._patientCellContainer.numChildren; i++)
			{
				patientCell = this._patientCellContainer.getChildAt(i) as PatientResultCell;
				patientCell.width = this.actualWidth;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._patientCellContainer.layout = layout;

			this._patientCellContainer.validate();
		}

		private function onRequestConnection(e:Event):void
		{
			var selectedHcpInd:int = this._patientCellRadioGroup.selectedIndex,
				patientCell:XMLList = XMLList(this._patientFilteredList[selectedHcpInd]);

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();

			var name:String = "'" + patientCell.name + "'";
			var email:String = "'" + patientCell.email + "'";
			var appid:String = "'" + patientCell.appid + "'";
			var picture:String = "'" + patientCell.picture + "'";
			this._sqStatement.text = "INSERT INTO patient_connection (name, email, appid, picture) VALUES (" + name + ", " + email + ", " + appid + ", " + picture + ")";

			trace(this._sqStatement.text);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();

			this._requestPopupContainer.message = "A request to connect has been sent to " + patientCell.name;
			showRequestPopup();
		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
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
	}
}
