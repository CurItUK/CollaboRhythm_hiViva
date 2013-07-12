package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.components.Calendar;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;

	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;

	import starling.core.Starling;
	import starling.events.Event;


	public class HivivaHCPReportsScreen extends ValidationScreen
	{
		private var _patientPickerList:PickerList;
		private var _patientLabel:Label;

		private var _startDateInput:LabelAndInput;
		private var _finishDateInput:LabelAndInput;
		private var _startDateButton:Button;
		private var _finishDateButton:Button;
		private var _reportDatesLabel:Label;
		private var _includeLabel:Label;
		private var _adherenceCheck:Check;
		private var _feelingCheck:Check;
		private var _cd4Check:Check;
		private var _viralLoadCheck:Check;
		private var _previewAndSendBtn:Button;
		private var _calendar:Calendar;
		private var _activeCalendarInput:TextInput;

		private var _pdfFile:File;
		private var _stageWebView:StageWebView

		private var _pdfPopupContainer:HivivaPDFPopUp;

		private var patients:ListCollection;

		private var _calendarActive:Boolean;

		public function HivivaHCPReportsScreen()
		{

		}

		override protected function draw():void
		{
			this._customHeight = this.actualHeight - Main.footerBtnGroupHeight;

			getHcpConnections();

			super.draw();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();
			this._reportDatesLabel.width = this._innerWidth;

			this._startDateInput._labelLeft.text = "Start";
			this._startDateInput.width = this._innerWidth * 0.75;
			this._startDateInput._input.width = this._innerWidth * 0.5;

			this._finishDateInput._labelLeft.text = "Finish";
			this._finishDateInput.width = this._innerWidth * 0.75;
			this._finishDateInput._input.width = this._innerWidth * 0.5;

			this._includeLabel.width = this._innerWidth;

			this._adherenceCheck.defaultLabelProperties.width = this._innerWidth;
			this._feelingCheck.defaultLabelProperties.width = this._innerWidth;
			this._cd4Check.defaultLabelProperties.width = this._innerWidth;
			this._viralLoadCheck.defaultLabelProperties.width = this._innerWidth;
			this._patientPickerList.width = this._innerWidth;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();
			this._patientLabel.width += this._componentGap;
			this._startDateButton.x = this._startDateInput.width + this._componentGap;
			this._startDateButton.y = this._startDateInput.y + this._startDateInput._input.y + (this._startDateInput._input.height * 0.5);
			this._startDateButton.y -= this._startDateButton.height * 0.5;

			this._finishDateInput.y = this._startDateInput.y + this._startDateInput.height + this._componentGap;

			this._finishDateButton.x = this._finishDateInput.width + this._componentGap;
			this._finishDateButton.y = this._finishDateInput.y + this._finishDateInput._input.y + (this._finishDateInput._input.height * 0.5);
			this._finishDateButton.y -= this._finishDateButton.height * 0.5;

			this._includeLabel.y = this._finishDateInput.y + this._finishDateInput.height + this._componentGap;
			this._adherenceCheck.y = this._includeLabel.y + this._includeLabel.height + this._componentGap;
			this._feelingCheck.y = this._adherenceCheck.y + this._adherenceCheck.height + this._componentGap;
			this._cd4Check.y = this._feelingCheck.y + this._feelingCheck.height + this._componentGap;
			this._viralLoadCheck.y = this._cd4Check.y + this._cd4Check.height + this._componentGap;
			this._previewAndSendBtn.y = this._viralLoadCheck.y + this._viralLoadCheck.height + this._componentGap;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._calendarActive = false;
			this._header.title = "Generate Reports";

			this._patientLabel = new Label();
			this._patientLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._patientLabel.text = "Patients";
			this._content.addChild(this._patientLabel);

			this._patientPickerList = new PickerList();
			this._patientPickerList.listProperties.@itemRendererProperties.labelField = "text";
			this._patientPickerList.labelField = "text";
			this._patientPickerList.isEnabled = false;
			this._patientPickerList.prompt = "Loading connections...";
			this._patientPickerList.selectedIndex = -1;
			this._patientPickerList.addEventListener(starling.events.Event.CHANGE, patientSelectedHandler);
			this._content.addChild(this._patientPickerList);

			this._reportDatesLabel = new Label();
			this._reportDatesLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._reportDatesLabel.text = "Report dates";
			this._content.addChild(this._reportDatesLabel);

			this._startDateInput = new LabelAndInput();
			this._startDateInput.scale = this.dpiScale;
			this._startDateInput.labelStructure = "left";
			this._content.addChild(this._startDateInput);
			this._startDateInput._input.isEnabled = false;

			this._startDateButton = new Button();
			this._startDateButton.addEventListener(starling.events.Event.TRIGGERED, startDateCalendarHandler);
			this._startDateButton.name = "calendar-button";
			this._content.addChild(this._startDateButton);

			this._finishDateInput = new LabelAndInput();
			this._finishDateInput.scale = this.dpiScale;
			this._finishDateInput.labelStructure = "left";
			this._content.addChild(this._finishDateInput);
			this._finishDateInput._input.isEnabled = false;

			this._finishDateButton = new Button();
			this._finishDateButton.addEventListener(starling.events.Event.TRIGGERED, finishDateCalendarHandler);
			this._finishDateButton.name = "calendar-button";
			this._content.addChild(this._finishDateButton);

			this._includeLabel = new Label();
			this._includeLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._includeLabel.text = "Include";
			this._content.addChild(this._includeLabel);

			this._adherenceCheck = new Check();
			this._adherenceCheck.isSelected = false;
			this._adherenceCheck.label = "Adherence";
			this._content.addChild(this._adherenceCheck);

			this._feelingCheck = new Check();
			this._feelingCheck.isSelected = false;
			this._feelingCheck.label = "How I am feeling";
			this._content.addChild(this._feelingCheck);

			this._cd4Check = new Check();
			this._cd4Check.isSelected = false;
			this._cd4Check.label = "CD4 count test results";
			this._content.addChild(this._cd4Check);

			this._viralLoadCheck = new Check();
			this._viralLoadCheck.isSelected = false;
			this._viralLoadCheck.label = "Viral load test results";
			this._content.addChild(this._viralLoadCheck);

			this._previewAndSendBtn = new Button();
			this._previewAndSendBtn.label = "Preview and send";
			this._previewAndSendBtn.addEventListener(starling.events.Event.TRIGGERED, previewSendHandler);
			this._content.addChild(this._previewAndSendBtn);

			this._calendar = new Calendar();
			this._calendar.addEventListener(FeathersScreenEvent.CALENDAR_BUTTON_TRIGGERED, calendarButtonHandler)
		}

		private function getHcpConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedConnectionsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnections();
		}

		private function getApprovedConnectionsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedConnectionsCompleteHandler);

			var approvedConnections:XML = e.data.xmlResponse;

			if(approvedConnections.children().length() > 0)
			{
				var patientsList:Array = [];
				var loop:uint = approvedConnections.children().length();
				var approvedHCPList:XMLList  = approvedConnections.DCConnection;


				for (var listCount:int = 0; listCount < loop; listCount++)
				{
					var establishedUser:Object = establishToFromId(approvedHCPList[listCount]);
					var patientObj:Object = {userAppId:establishedUser.appId , userGuid:establishedUser.appGuid};
					patientsList.push(patientObj);
				}

				var patients:ListCollection = new ListCollection( patientsList );

				this._patientPickerList.dataProvider = patients;
				this._patientPickerList.prompt = "Select patient";
				this._patientPickerList.isEnabled = true;
				this._patientPickerList.selectedIndex = -1;
				this._patientPickerList.listProperties.@itemRendererProperties.labelField = "userAppId";
				this._patientPickerList.labelField = "userAppId";
			}
			else
			{
				this._patientPickerList.prompt = "No connections...";
			}

		}

		private function establishToFromId(idsToCompare:XML):Object
		{
			var whoEstablishConnection:Object = [];
			if(idsToCompare.FromAppId == HivivaStartup.userVO.appId)
			{
				whoEstablishConnection.appGuid = (idsToCompare.ToUserGuid).toString();
				whoEstablishConnection.appId = (idsToCompare.ToAppId).toString();
			} else
			{
				whoEstablishConnection.appGuid = (idsToCompare.FromUserGuid).toString();
				whoEstablishConnection.appId = (idsToCompare.FromAppId).toString();
			}

			return whoEstablishConnection;
		}

		private function calendarButtonHandler(e:FeathersScreenEvent):void
		{
			PopUpManager.removePopUp(this._calendar);
			this._activeCalendarInput.text = e.evtData.date;
		}

		private function startDateCalendarHandler(e:starling.events.Event):void
		{
			this._activeCalendarInput = this._startDateInput._input;
			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.cType = "start";

			this._calendar.validate();

			if(this._calendarActive) this._calendar.resetCalendar();

			this._calendarActive = true;
			//PopUpManager.centerPopUp(this._calendar);
		}

		private function finishDateCalendarHandler(e:starling.events.Event):void
		{
			this._activeCalendarInput = this._finishDateInput._input;
			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.cType = "finish";

			this._calendar.validate();

			if(this._calendarActive) this._calendar.resetCalendar();

			this._calendarActive = true;
			//PopUpManager.centerPopUp(this._calendar);
		}

		private function patientSelectedHandler(e:starling.events.Event):void
		{
			//TODO change patient PDF report details
		}



		private function previewSendHandler(e:starling.events.Event):void
		{
			//TODO move PDF creating into UTILS class
			//TODO move fileStream - report PDF file creation to local service class

			var formValidation:String = patientReportsCheck();
			if(formValidation.length == 0)
			{
				displaySavedPDF();
			}
			else
			{
				showFormValidation(formValidation);
			}
		}


		private function patientReportsCheck():String
		{
			var validationArray:Array = [];
			if(this._patientPickerList.selectedIndex == -1) validationArray.push("Please select a patient");
			if(this._startDateInput._input.text.length == 0) validationArray.push("Please select a start date");
			if(this._finishDateInput._input.text.length == 0) validationArray.push("Please select an end date");

			if(!this._adherenceCheck.isSelected && !this._feelingCheck.isSelected && !this._cd4Check.isSelected && !this._viralLoadCheck.isSelected)
			{
				validationArray.push("Please select one or more reporting item");
			}

			if(this._startDateInput._input.text.length != 0 && this._finishDateInput._input.text.length != 0)
			{
				var isValidDate:Boolean = validateDates();
				if(!isValidDate)validationArray.push("Invalid date selection - start and end dates");
			}

			return validationArray.join("\n");
		}

		private function validateDates():Boolean
		{
			var tempStart:Array = this._startDateInput._input.text.split('/');
			var tempFinish:Array = this._finishDateInput._input.text.split('/');

			var startAdd:Number = tempStart[2]*1300 + tempStart[0]*100 + tempStart[1];
			var endAdd:Number = tempFinish[2]*1300 + tempFinish[0]*100 + tempFinish[1];

			return (startAdd > endAdd);
		}

		private function displaySavedPDF():void
		{
			this._pdfPopupContainer = new HivivaPDFPopUp();
			this._pdfPopupContainer.scale = this.dpiScale;
			this._pdfPopupContainer.width = this.actualWidth;
			this._pdfPopupContainer.height = this.actualHeight;
			this._pdfPopupContainer.addEventListener("sendMail", mailBtnHandler);
			this._pdfPopupContainer.addEventListener(starling.events.Event.CLOSE, closePopup);
			this._pdfPopupContainer.validate();

			PopUpManager.addPopUp(this._pdfPopupContainer, true, true);
			this._pdfPopupContainer.validate();


			var padding:Number = 150;
			this._stageWebView = new StageWebView();
			this._stageWebView.stage = Starling.current.nativeStage.stage;
			this._stageWebView.viewPort = new Rectangle(20, 20, Starling.current.nativeStage.stage.stageWidth - 30, Starling.current.nativeStage.stage.stageHeight - padding);

			var pdf:File = File.applicationStorageDirectory.resolvePath("patient_report.pdf");
			this._stageWebView.loadURL(pdf.nativePath);

		}

		private function closePopup(e:starling.events.Event):void
		{
			this._stageWebView.viewPort = null;
			this._stageWebView.dispose();
			this._stageWebView = null;

			PopUpManager.removePopUp(this._pdfPopupContainer);

		}



		private function mailBtnHandler(e:starling.events.Event):void
		{
			closePopup(e);
			//TODO add mail native extentions for IOS and Android
			//http://diadraw.com/projects/adobe-air-native-e-mail-extension/

			var mailURL:String = "mailto:?subject='My Patient Report'&body='My Patient Report'";
			var urlReq:URLRequest = new URLRequest(mailURL);
			navigateToURL(urlReq);


		}
	}
}
