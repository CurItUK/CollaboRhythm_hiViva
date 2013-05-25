package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.layout.VerticalLayout;

	import flash.text.TextFormat;
	import starling.display.DisplayObject;
	import starling.events.Event;


	public class HivivaHCPConnectToPatientScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _addConnectionButton:Button;
		private var _backButton:Button;
		private var _applicationController:HivivaApplicationController;
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

			// reduce font size for large title
			this._header._titleHolder1.textRendererProperties.textFormat = new TextFormat("ExoBold", Math.round(36 * this.dpiScale), 0x293d54);
			this._header._titleHolder2.textRendererProperties.textFormat = new TextFormat("ExoLight", Math.round(36 * this.dpiScale), 0x293d54);
			this._header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			this._header.validate();

			this._addConnectionButton.validate();
			this._addConnectionButton.x = (this.actualWidth / 2) - (this._addConnectionButton.width / 2);
			this._addConnectionButton.y = this.actualHeight - this._addConnectionButton.height - (PADDING * this.dpiScale);

			this._backButton.validate();

			getHcpConnections();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Connected patients";
			addChild(this._header);

			this._addConnectionButton = new Button();
			this._addConnectionButton.label = "Add a connection";
			this._addConnectionButton.addEventListener(Event.TRIGGERED, onAddConnection);
			addChild(this._addConnectionButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._patientCellContainer = new ScrollContainer();
		}

		private function getHcpConnections():void
		{
			applicationController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE , getHcpListCompleteHandler)
			applicationController.hivivaLocalStoreController.getHCPConnections();
		}

		private function getHcpListCompleteHandler(e:LocalDataStoreEvent):void
		{
			applicationController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE , getHcpListCompleteHandler)
			trace(e.data.connections);
			if(e.data.connections != null)
			{
				trace("connectionsLength " + e.data.connections.length);
				var connectionsLength:uint = e.data.connections.length;

				clearDownPatientCells();

				this._patientCellRadioGroup = new ToggleGroup();
				addChild(this._patientCellContainer);


				for (var listCount:int = 0; listCount < connectionsLength; listCount++)
				{
					var patientCell:PatientResultCell = new PatientResultCell();
					patientCell.patientData = generateXMLNode(e.data.connections[listCount]);
					patientCell.isResult = false;
					patientCell.scale = this.dpiScale;
					patientCell.addEventListener(Event.CLOSE, deleteHcpRecord);
					//patientCell.addEventListener(Event.REMOVED_FROM_STAGE, deleteHcpCell);
					this._patientCellContainer.addChild(patientCell);
					this._patientCellRadioGroup.addItem(patientCell._patientSelect);
				}
				drawResults();
			}
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var yStartPosition:Number;
			var maxHeight:Number;
			var patientCell:PatientResultCell;

			yStartPosition = this._header.height;
			maxHeight = this.actualHeight - yStartPosition - this._addConnectionButton.height - (PADDING * this.dpiScale);

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

		private function generateXMLNode(record:Object):XML
		{
			var xmlRecord:XML = XML("<patient><name>" + record.name + "</name><email>"
					+  record.email + "</email><appid>"
					+  record.appid + "</appid><picture>"
					+ record.picture + "</picture></patient>");

			return xmlRecord;
		}

		private function deleteHcpRecord(e:Event):void
		{
			trace("deleteHcpRecord confirmation");
			selectedPatientCellForDelete = e.target as PatientResultCell;


			this._deletePopupContainer = new HivivaPopUp();
			this._deletePopupContainer.scale = this.dpiScale;
			this._deletePopupContainer.confirmLabel = "Delete";
			this._deletePopupContainer.addEventListener(Event.COMPLETE, deleteHcpCell);
			this._deletePopupContainer.addEventListener(Event.CLOSE, closePopup);
			this._deletePopupContainer.width = 500 * dpiScale;
			this._deletePopupContainer.validate();

			this._deletePopupContainer.message = "This will delete your connection with " + selectedPatientCellForDelete.patientData.name;

			showRequestPopup();
		}

		private function showRequestPopup():void
		{
			PopUpManager.addPopUp(this._deletePopupContainer, true, true);
			this._deletePopupContainer.validate();
			PopUpManager.centerPopUp(this._deletePopupContainer);
			this._deletePopupContainer.drawCloseButton();
		}

		private function deleteHcpCell(e:Event):void
		{
			applicationController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.HCP_CONNECTION_DELETE_COMPLETE , deleteHCPConnectionCompleteHandler);
			applicationController.hivivaLocalStoreController.deleteHCPConnection(selectedPatientCellForDelete.patientData.appid);
		}

		private function deleteHCPConnectionCompleteHandler(e:LocalDataStoreEvent):void
		{
			applicationController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_CONNECTION_DELETE_COMPLETE , deleteHCPConnectionCompleteHandler);
			clearDownPatientCells();
			clearDownPopup();
			getHcpConnections();
		}

		private function clearDownPopup():void
		{
			PopUpManager.removePopUp(this._deletePopupContainer);
			this._deletePopupContainer.removeEventListener(Event.COMPLETE, deleteHcpCell);
			this._deletePopupContainer.removeEventListener(Event.CLOSE, closePopup);
			this._deletePopupContainer.dispose();
			this._deletePopupContainer = null;
		}

		private function closePopup(e:Event):void
		{
			PopUpManager.removePopUp(this._deletePopupContainer);
		}

		private function backBtnHandler(e:Event = null):void
		{
			clearDownPatientCells();
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function onAddConnection(e:Event):void
		{
			clearDownPatientCells();
			this.owner.showScreen(HivivaScreens.HCP_ADD_PATIENT);
		}

		private function clearDownPatientCells():void
		{
			if (contains(this._patientCellContainer))
			{
				this._patientCellRadioGroup.removeAllItems();
				this._patientCellContainer.removeChildren();
			}
		}

		public function get selectedPatientCellForDelete():PatientResultCell
		{
			return this._selectedPatientCellForDelete;
		}

		public function set selectedPatientCellForDelete(cell:PatientResultCell):void
		{
			this._selectedPatientCellForDelete = cell;
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}

	}
}
