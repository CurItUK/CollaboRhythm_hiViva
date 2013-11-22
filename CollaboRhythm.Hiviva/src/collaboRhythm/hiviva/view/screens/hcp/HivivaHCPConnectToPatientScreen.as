package collaboRhythm.hiviva.view.screens.hcp
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCPConnectToPatientScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _addConnectionButton:Button;
		private var _backButton:Button;
		private var _patientFilteredList:Array = [];

		private var _patientCellContainer:ScrollContainer;
		private var _userPictureCount:int;

		private const PADDING:Number = 20;

		public function HivivaHCPConnectToPatientScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._addConnectionButton.validate();
			this._addConnectionButton.x = (Constants.STAGE_WIDTH / 2) - (this._addConnectionButton.width / 2);
			this._addConnectionButton.y = Constants.STAGE_HEIGHT - this._addConnectionButton.height - Constants.PADDING_BOTTOM;

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
			this._addConnectionButton.addEventListener(Event.TRIGGERED, onAddConnection);
			addChild(this._addConnectionButton);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._patientCellContainer = new ScrollContainer();
		}

		private function backBtnHandler(e:Event = null):void
		{
			clearDownHCPList();
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function onAddConnection(e:Event):void
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
					var establishedUser:Object = HivivaModifier.establishToFromId(approvedHCPList[i]);
					var appGuid:String = establishedUser.appGuid;
					var appId:String = establishedUser.appId;
					var fullName:String = establishedUser.fullName;
					var userEstablishedConnection:Boolean = didCurrentUserEstablishConnection(approvedHCPList[i]);

					var hcpList:XMLList = new XMLList
					(
							<hcp>
								<name>{fullName}</name>
								<email>{appId}</email>
								<appid>{appId}</appid>
								<guid>{appGuid}</guid>
								<picture>media/hcps/dummy.png</picture>
								<establishedConnection>{userEstablishedConnection}</establishedConnection>
							</hcp>
					);
					this._patientFilteredList.push(hcpList);
				}
				_userPictureCount = 0;

				getUserPicture();
			}
			else
			{
				trace("No Approved Connections");
			}
		}

		private function getUserPicture():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_USER_PICTURE_COMPLETE, getUserPictureCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserPicture(_patientFilteredList[_userPictureCount].guid);
		}

		private function getUserPictureCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_USER_PICTURE_COMPLETE, getUserPictureCompleteHandler);
			var user:XMLList;
			var pictureName:String;
			var userGuid:String;
			var pictureStream:String;
			var getUserDataXml:XML = e.data.xmlResponse as XML;
			if(getUserDataXml.children().length() > 0)
			{
				pictureStream = getUserDataXml.PictureStream;
				if(pictureStream.length > 0)
				{
					pictureName = getUserDataXml.PictureName;
					userGuid = pictureName.substring(0,pictureName.indexOf(".jpg"));

					for (var i:int = 0; i < _patientFilteredList.length; i++)
					{
						if(_patientFilteredList[i].guid == userGuid)
						{
							user = _patientFilteredList[i];
							break;
						}
					}

					user.picture = HivivaModifier.getProfilePictureUrlFromXml(getUserDataXml);
				}
			}

			_userPictureCount++;
			if(_userPictureCount < _patientFilteredList.length)
			{
				getUserPicture();
			}
			else
			{
				initResults();
			}
		}

		private function didCurrentUserEstablishConnection(idsToCompare:XML):Boolean
		{
			return idsToCompare.FromAppId == HivivaStartup.userVO.appId;
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
				hcpCell.isResult = false;
//				hcpCell.scale = this.dpiScale;
				this._patientCellContainer.addChild(hcpCell);
				//this._patientCellRadioGroup.addItem(hcpCell._hcpSelect);
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
			maxHeight = Constants.STAGE_HEIGHT - yStartPosition;
			maxHeight -= (Constants.STAGE_HEIGHT - this._addConnectionButton.y) + scaledPadding;

			this._patientCellContainer.width = Constants.STAGE_WIDTH;
			this._patientCellContainer.y = yStartPosition;
			this._patientCellContainer.height = maxHeight;

			for (var i:int = 0; i < this._patientCellContainer.numChildren; i++)
			{
				hcpCell = this._patientCellContainer.getChildAt(i) as HcpResultCell;
				hcpCell.width = Constants.STAGE_WIDTH;
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
//				this._patientCellRadioGroup = new ToggleGroup();
				addChild(this._patientCellContainer);
			}
			else
			{
//				this._patientCellRadioGroup.removeAllItems();
				this._patientCellContainer.removeChildren();
			}
		}

		override public function dispose():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE, getApprovedConnectionsCompleteHandler);
			super.dispose();
		}
	}
}