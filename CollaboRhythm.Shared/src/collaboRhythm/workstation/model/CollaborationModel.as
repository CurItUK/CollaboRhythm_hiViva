package collaboRhythm.workstation.model
{
	import castle.flexbridge.kernel.IKernel;
	
	import collaboRhythm.workstation.model.services.WorkstationKernel;
	
	import flash.events.NetStatusEvent;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 
	 * @author jom
	 * 
	 * Keeps track of all of the remoteUsers actively collaborating with the localUser.  It also keeps a reference to the videoOutput, as this is part of any collaboration.
	 * Considering that only userNames are sent over the netConnection with the FMS, the retrieveCollaboratingRemoteUser function allows a collaboratingRemoteUser to be resolved from its userName.
	 * 
	 */
	[Bindable]
	public class CollaborationModel
	{
		private var _active:Boolean = false;
		private var _usersModel:UsersModel;
//		private var _localUser:User;
		private var _creatingUser:User;
		private var _subjectUser:User;
		private var _invitedUsers:Vector.<User> = new Vector.<User>;
		private var _invitingUser:User;
		private var _controllingUser:User;
		private var _roomID:String;
		private var _passWord:String;
		private var _audioVideoOutput:AudioVideoOutput;
		private var _collaborationRoomUsers:ArrayCollection;
		private var _collaborationLobbyNetConnectionService:CollaborationLobbyNetConnectionService;
		private var _collaborationRoomNetConnectionService:CollaborationRoomNetConnectionService;
		
		public function CollaborationModel(settings:Settings, usersModel:UsersModel)
		{
			_usersModel = usersModel;
			_audioVideoOutput = new AudioVideoOutput();
			_collaborationRoomUsers = new ArrayCollection();
			
			_collaborationLobbyNetConnectionService = new CollaborationLobbyNetConnectionService(usersModel.localUser.accountId, settings.rtmpBaseURI, this, usersModel);
			_collaborationRoomNetConnectionService = new CollaborationRoomNetConnectionService(usersModel.localUser.accountId, settings.rtmpBaseURI, this);
			
//			_usersModel.usersHealthRecordService.addEventListener(HealthRecordServiceEvent.COMPLETE, usersHealthRecordService_completeHandler);
			_collaborationLobbyNetConnectionService.enterCollaborationLobby();
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
		}

		public function get usersModel():UsersModel
		{
			return _usersModel;
		}

		public function get localUser():User
		{
			return usersModel.localUser;
		}

//		public function set localUser(value:User):void
//		{
//			_localUser = value;
//		}
//		
		public function get creatingUser():User
		{
			return _creatingUser;
		}
		
		public function set creatingUser(value:User):void
		{
			_creatingUser = value;
			if (value != localUser)
			{
				_collaborationRoomUsers.addItem(value);
			}
		}

		public function get subjectUser():User
		{
			return _subjectUser;
		}
		
		public function set subjectUser(value:User):void
		{
			_subjectUser = value;
			if (value != localUser)
			{
				_collaborationRoomUsers.addItem(value);
			}
		}
		
		public function get invitedUsers():Vector.<User>
		{
			return _invitedUsers;
		}
		
		public function get invitingUser():User
		{
			return _invitingUser;
		}
		
		public function set invitingUser(value:User):void
		{
			_invitingUser = value;
		}
		
		public function get controllingUser():User
		{
			return _controllingUser;
		}
		
		public function set controllingUser(value:User):void
		{
			_controllingUser = value;
		}
		
		public function get roomID():String
		{
			return _roomID;
		}
		
		public function set roomID(value:String):void
		{
			_roomID = value;
		}
		
		public function get passWord():String
		{
			return _passWord;
		}
		
		public function set passWord(value:String):void
		{
			_passWord = value;
		}
		
		public function get collaborationLobbyNetConnectionService():CollaborationLobbyNetConnectionService
		{
			return _collaborationLobbyNetConnectionService;
		}
		
		public function get collaborationRoomNetConnectionService():CollaborationRoomNetConnectionService
		{
			return _collaborationRoomNetConnectionService;
		}
		
		public function get collaborationRoomUsers():ArrayCollection
		{
			return _collaborationRoomUsers;
		}
		
		public function get audioVideoOutput():AudioVideoOutput
		{
			return _audioVideoOutput;
		}
		
		private function usersHealthRecordService_completeHandler(event:UserDatabaseEvent):void
		{
			_collaborationLobbyNetConnectionService.enterCollaborationLobby();
		}
		
		public function addInvitedUser(invitedUser:User):void
		{
			_invitedUsers.push(invitedUser);
			_collaborationRoomUsers.addItem(invitedUser);
		}
		
		public function closeCollaborationRoom():void
		{
			while (_collaborationRoomUsers.length > 0)
			{	
				var collaborationRoomUser:User = User(_collaborationRoomUsers.getItemAt(_collaborationRoomUsers.length - 1));
				_collaborationRoomNetConnectionService.remoteUserExitedCollaborationRoom(collaborationRoomUser.accountId);
				_collaborationRoomUsers.removeItemAt(_collaborationRoomUsers.length - 1);
			}
			_collaborationRoomNetConnectionService.exitCollaborationRoom();
			_creatingUser = null;
			_subjectUser = null;
			_invitedUsers = new Vector.<User>;
			_invitingUser = null;
			_controllingUser = null;
			_roomID = "";
			_passWord = "";
			localUser.collaborationColor = "0x000000";
		}
	}
}