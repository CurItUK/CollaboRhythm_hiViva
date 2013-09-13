package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;

	import flash.events.EventDispatcher;

	import spark.effects.interpolation.MultiValueInterpolator;

	public class HivivaLocalStoreController extends EventDispatcher
	{
		private var _hivivaLocalStoreService:HivivaLocalStoreService;

		public function HivivaLocalStoreController()
		{
			trace("HivivaLocalStoreController construct");
		}

		public function setTypeAppIdGuid(appId:String , guid:String , type:String):void
		{
			service.addEventListener(LocalDataStoreEvent.APP_ID_SAVE_COMPLETE, setTypeAppIdGuidHandler);
			service.setTypeAppIdGuidId(appId , guid , type);
		}

		private function setTypeAppIdGuidHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.APP_ID_SAVE_COMPLETE, setTypeAppIdGuidHandler);
			this.dispatchEvent(new LocalDataStoreEvent(LocalDataStoreEvent.APP_ID_SAVE_COMPLETE));
		}

		public function getAppId():void
		{
			service.addEventListener(LocalDataStoreEvent.APP_ID_LOAD_COMPLETE, getAppIdHandler);
			service.getAppId();
		}

		private function getAppIdHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.APP_ID_LOAD_COMPLETE, getAppIdHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.APP_ID_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function getGalleryImages():void
		{
			service.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			service.getGalleryImages()
		}

		public function deleteGalleryImages():void
				{
					service.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
					service.getGalleryImages()
				}




		private function getGalleryImagesHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setGalleryImages(imageUrls:Array):void
		{
			service.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_SAVE_COMPLETE,setGalleryImagesHandler);
			service.setGalleryImages(imageUrls);
		}

		private function setGalleryImagesHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_SAVE_COMPLETE,setGalleryImagesHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_IMAGES_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function initStoreService():void
		{
			_hivivaLocalStoreService = new HivivaLocalStoreService();
			_hivivaLocalStoreService.initDataLoad();
		}

		public function resetApplication():void
		{
			service.addEventListener(LocalDataStoreEvent.APPLICATION_RESET_COMPLETE, applicationResetCompleteHandler);
			service.resetApplication()
		}

		public function applicationResetCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.APPLICATION_RESET_COMPLETE, applicationResetCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.APPLICATION_RESET_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getGalleryTimeStamp():void
		{
			service.addEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE,getGalleryTimeStampHandler);
			service.getGalleryTimeStamp();
		}

		private function getGalleryTimeStampHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE,getGalleryTimeStampHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setGalleryTimeStamp(date:String):void
		{
			service.addEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_SAVE_COMPLETE,setGalleryTimeStampHandler);
			service.setGalleryTimeStamp(date);
		}

		private function setGalleryTimeStampHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_SAVE_COMPLETE,setGalleryTimeStampHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_TIMESTAMP_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getViewedSettingsAnimation():void
		{
			service.addEventListener(LocalDataStoreEvent.VIEWED_SETTINGS_ANIMATION_LOAD_COMPLETE,getViewedSettingsAnimationHandler);
			service.getViewedSettingsAnimation();
		}

		private function getViewedSettingsAnimationHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.VIEWED_SETTINGS_ANIMATION_LOAD_COMPLETE,getViewedSettingsAnimationHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.VIEWED_SETTINGS_ANIMATION_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setViewedSettingsAnimation():void
		{
			service.addEventListener(LocalDataStoreEvent.VIEWED_SETTINGS_ANIMATION_SAVE_COMPLETE,setViewedSettingsAnimationHandler);
			service.setViewedSettingsAnimation();
		}

		private function setViewedSettingsAnimationHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.VIEWED_SETTINGS_ANIMATION_SAVE_COMPLETE,setViewedSettingsAnimationHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.VIEWED_SETTINGS_ANIMATION_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getMedicationList():void
		{
			service.addEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE,medicationsLoadCompleteHandler);
			service.getMedicationList();
		}

		private function medicationsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE,medicationsLoadCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setMedicationList(medicationSchedule:Array , medicationName:String):void
		{
			service.addEventListener(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE , medicationSaveCompleteHandler);
			service.setMedicationList(medicationSchedule , medicationName);
		}

		private function medicationSaveCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE , medicationSaveCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getMedicationsSchedule():void
		{
			service.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE,medicationScheduleLoadCompleteHandler);
			service.getMedicationsSchedule();
		}

		private function medicationScheduleLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE,medicationScheduleLoadCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function deleteMedication(medicationId:int):void
		{
			service.addEventListener(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE, deleteMedicationCompleteHandler);
			service.deleteMedication(medicationId);
		}

		private function deleteMedicationCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE , deleteMedicationCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getTestResults():void
		{
			service.addEventListener(LocalDataStoreEvent.TEST_RESULTS_LOAD_COMPLETE , testResultsLoadCompleteHandler);
			service.getTestResults();
		}

		private function testResultsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.TEST_RESULTS_LOAD_COMPLETE , testResultsLoadCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.TEST_RESULTS_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setTestResults(testResults:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.TEST_RESULTS_SAVE_COMPLETE , testResultsSaveCompleteHandler);
			service.setTestResults(testResults);
		}

		private function testResultsSaveCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.TEST_RESULTS_SAVE_COMPLETE , testResultsSaveCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.TEST_RESULTS_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}


		public function getAdherence():void
		{
			service.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			service.getAdherence();
		}

		private function adherenceLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setAdherence(medicationAdherence:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE , adherenceSaveCompleteHandler);
			service.setAdherence(medicationAdherence);
		}

		private function adherenceSaveCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE , adherenceSaveCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getPatientProfile():void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);
			service.getPatientProfile();
		}

		private function getPatientProfileHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setPatientProfile(patientProfile:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE, setPatientProfileHandler);
			service.setPatientProfile(patientProfile);
		}

		private function setPatientProfileHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE, setPatientProfileHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getHcpProfile():void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);
			service.getHcpProfile()
		}

		private function getHcpProfileHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setHcpProfile(hcpProfile:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE, setHcpProfileHandler);
			service.setHcpProfile(hcpProfile);
		}

		private function setHcpProfileHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE, setHcpProfileHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getHcpDisplaySettings():void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_LOAD_COMPLETE, getHcpDisplaySettingsHandler);
			service.getHcpDisplaySettings()
		}

		private function getHcpDisplaySettingsHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_LOAD_COMPLETE, getHcpDisplaySettingsHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setHcpDisplaySettings(displaySettings:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_SAVE_COMPLETE, setHcpDisplaySettingsHandler);
			service.setHcpDisplaySettings(displaySettings);
		}

		private function setHcpDisplaySettingsHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_SAVE_COMPLETE, setHcpDisplaySettingsHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getHcpAlertSettings():void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_LOAD_COMPLETE, getHcpAlertSettingsHandler);
			service.getHcpAlertSettings()
		}

		private function getHcpAlertSettingsHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_LOAD_COMPLETE, getHcpAlertSettingsHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_ALERT_SETTINGS_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setHcpAlertSettings(alertSettings:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_SAVE_COMPLETE, setHcpAlertSettingsHandler);
			service.setHcpAlertSettings(alertSettings);
		}

		private function setHcpAlertSettingsHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_SAVE_COMPLETE, setHcpAlertSettingsHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_ALERT_SETTINGS_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getHCPConnections():void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, hcpConnectionsLoadedHandler);
			service.getHCPConnections();
		}

		private function hcpConnectionsLoadedHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, hcpConnectionsLoadedHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE);
			evt.data  = e.data;
			this.dispatchEvent(evt);
		}

		public function deleteHCPConnection(appid:String):void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_CONNECTION_DELETE_COMPLETE, hcpConnectionDeleteHandler);
			service.deleteHCPConnection(appid);
		}

		private function hcpConnectionDeleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_CONNECTION_DELETE_COMPLETE, hcpConnectionDeleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_CONNECTION_DELETE_COMPLETE);
			this.dispatchEvent(evt);
		}


		public function addHCPConnection(patient:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.HCP_CONNECTION_SAVE_COMPLETE, addHCPConnectionHandler);
			service.addHCPConnection(patient);
		}

		private function addHCPConnectionHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.HCP_CONNECTION_SAVE_COMPLETE, addHCPConnectionHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_CONNECTION_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}


		public function getPatientConnections():void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_CONNECTIONS_LOAD_COMPLETE, patientConnectionsLoadedHandler);
			service.getPatientConnections();
		}

		private function patientConnectionsLoadedHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_CONNECTIONS_LOAD_COMPLETE, patientConnectionsLoadedHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_CONNECTIONS_LOAD_COMPLETE);
			evt.data  = e.data;
			this.dispatchEvent(evt);
		}

		public function deletePatientConnection(appid:String):void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_CONNECTION_DELETE_COMPLETE, patientConnectionDeleteHandler);
			service.deletePatientConnection(appid);
		}

		private function patientConnectionDeleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_CONNECTION_DELETE_COMPLETE, patientConnectionDeleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_CONNECTION_DELETE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function addPatientConnection(hcp:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_CONNECTION_SAVE_COMPLETE, addPatientConnectionHandler);
			service.addPatientConnection(hcp);
		}

		private function addPatientConnectionHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_CONNECTION_SAVE_COMPLETE, addPatientConnectionHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_CONNECTION_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function loadPatientMessagesViewed():void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_LOAD_COMPLETE, loadPatientMessagesViewedHandler);
			service.loadPatientMessagesViewed();
		}

		private function loadPatientMessagesViewedHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_LOAD_COMPLETE, loadPatientMessagesViewedHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_LOAD_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function savePatientMessagesViewed(viewedIds:Array):void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_SAVE_COMPLETE, savePatientMessagesViewedHandler);
			service.savePatientMessagesViewed(viewedIds);
		}

		private function savePatientMessagesViewedHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_SAVE_COMPLETE, savePatientMessagesViewedHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getPatientKudosData():void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_LOAD_KUDOS_COMPLETE , loadPatientKudosCompleteHandler);
			service.getPatientKudosData();
		}

		private function loadPatientKudosCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_LOAD_KUDOS_COMPLETE , loadPatientKudosCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_LOAD_KUDOS_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function savePatientKudosData(date:String , count:String):void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_SAVE_KUDOS_COMPLETE , savePatientKudosCompleteHandler);
			service.savePatientKudosData(date , count);
		}

		private function savePatientKudosCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_SAVE_KUDOS_COMPLETE , savePatientKudosCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_SAVE_KUDOS_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function updatePatientBadges(id:uint):void
		{
			service.updatePatientBadges(id);
		}

		public function getPatientBadges():void
		{
			service.addEventListener(LocalDataStoreEvent.PATIENT_LOAD_BADGES_COMPLETE , loadPatientBadgesCompleteHandler);
			service.getPatientBadges();
		}

		private function loadPatientBadgesCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PATIENT_LOAD_BADGES_COMPLETE , loadPatientBadgesCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_LOAD_BADGES_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function clearDownBadgeAlerts():void
		{
			service.clearDownBadgeAlerts();
		}

		public function enableDisablePasscode(b:Boolean):void
		{
			service.addEventListener(LocalDataStoreEvent.PASSCODE_TOGGLE_COMPLETE , passcodeToggleCompleteHandler);
			service.enableDisablePasscode(b);
		}

		private function passcodeToggleCompleteHandler(event:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.PASSCODE_TOGGLE_COMPLETE , passcodeToggleCompleteHandler);
		}



		public function get service():HivivaLocalStoreService
		{
			return _hivivaLocalStoreService;
		}


	}
}
