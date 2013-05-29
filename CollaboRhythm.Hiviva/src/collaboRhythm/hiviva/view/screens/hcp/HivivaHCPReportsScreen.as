package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;


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
	import starling.events.Event;


	public class HivivaHCPReportsScreen extends ValidationScreen
	{
		private var _footerHeight:Number;
		private var _patientPickerList:PickerList;
		private var _patientLabel:Label;

		private var _startDateInput:LabelAndInput;
		private var _finishDateInput:LabelAndInput;
		private var _reportDatesLabel:Label;
		private var _includeLabel:Label;
		private var _adherenceCheck:Check;
		private var _feelingCheck:Check;
		private var _cd4Check:Check;
		private var _viralLoadCheck:Check;
		private var _previewAndSendBtn:Button;

		private var _pdfFile:File;
		private var _stageWebView:StageWebView

		private var _pdfPopupContainer:HivivaPDFPopUp;

		public function HivivaHCPReportsScreen()
		{

		}

		override protected function draw():void
		{
			this._customHeight = this.actualHeight - this._footerHeight;
			super.draw();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();
			this._reportDatesLabel.width = this._innerWidth;

			this._startDateInput._labelLeft.text = "Start";
			this._startDateInput.width = this._innerWidth;
			this._startDateInput._input.width = this._innerWidth * 0.7;

			this._finishDateInput._labelLeft.text = "Finish";
			this._finishDateInput.width = this._innerWidth;
			this._finishDateInput._input.width = this._innerWidth * 0.7;

			this._includeLabel.width = this._innerWidth;
			this._adherenceCheck.width = this._innerWidth;
			this._feelingCheck.width = this._innerWidth;
			this._cd4Check.width = this._innerWidth;
			this._viralLoadCheck.width = this._innerWidth;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Generate Reports";

			this._patientLabel = new Label();
			this._patientLabel.text = "<font face='ExoBold'>Patients</font>";
			this._content.addChild(this._patientLabel);

			this._patientPickerList = new PickerList();
			var patients:ListCollection = new ListCollection(
					[
						{text: "Patient 1"},
						{text: "Patient 2"},
						{text: "Patient 3"},
						{text: "Patient 4"},
						{text: "Patient 5"},
						{text: "Patient 6"}
					]
			);

			this._patientPickerList.dataProvider = patients;
			this._patientPickerList.listProperties.@itemRendererProperties.labelField = "text";
			this._patientPickerList.prompt = "Select patient";
			this._patientPickerList.selectedIndex = -1;
			this._patientPickerList.labelField = "text";
			this._patientPickerList.typicalItem = "Patient 6         ";
			this._patientPickerList.addEventListener(starling.events.Event.CHANGE, patientSelectedHandler);
			this._content.addChild(this._patientPickerList);

			this._reportDatesLabel = new Label();
			this._reportDatesLabel.text = "<font face='ExoBold'>Report dates</font>";
			this._content.addChild(this._reportDatesLabel);

			this._startDateInput = new LabelAndInput();
			this._startDateInput.scale = this.dpiScale;
			this._startDateInput.labelStructure = "left";
			this._content.addChild(this._startDateInput);

			this._finishDateInput = new LabelAndInput();
			this._finishDateInput.scale = this.dpiScale;
			this._finishDateInput.labelStructure = "left";
			this._content.addChild(this._finishDateInput);

			this._includeLabel = new Label();
			this._includeLabel.text = "<font face='ExoBold'>Include</font>";
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
		}

		private function patientSelectedHandler(e:Event):void
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
				var pdf:PDF = new PDF(Orientation.PORTRAIT, Unit.MM, Size.A4);

				pdf.addPage();

				var msg:String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas lobortis elit ut urna malesuada sed porttitor odio vestibulum. Morbi egestas metus vitae urna consectetur sagittis. Aenean aliquam tincidunt velit a lacinia. Vestibulum tincidunt ante vel sem laoreet sed tempus risus ornare. Nunc ullamcorper sapien vel neque vulputate commodo. Nam faucibus neque eu libero venenatis euismod. Pellentesque ut est vitae tellus egestas consectetur. Praesent massa lacus, ultrices ut convallis vitae, tincidunt at tortor. Sed arcu risus, convallis ac fringilla at, egestas id tortor. Nam consectetur luctus mollis. Phasellus id dolor nibh, sed ultricies diam. Aliquam erat volutpat. Nulla erat lectus, vestibulum sed molestie nec, dignissim sed tellus. Sed fermentum quam id dolor porta vel tristique orci tristique. Nunc varius molestie bibendum. Curabitur in tortor eget mauris porttitor mollis. Proin a lacus mauris. Nullam dapibus nisi vitae justo eleifend ullamcorper. Maecenas dolor augue, bibendum quis mattis ut, posuere in tortor. Donec auctor dolor eget leo posuere fermentum. Curabitur tincidunt blandit venenatis. Praesent sagittis tristique ultricies. Quisque lobortis lacus non orci aliquam facilisis. Cras ut felis massa, a posuere nisi. Maecenas eget nibh ligula. Duis urna massa, dignissim non dapibus eget, mattis consequat dolor.";

				pdf.writeText(12, msg);

				var fileStream:FileStream = new FileStream();

				this._pdfFile = File.applicationStorageDirectory.resolvePath("patient_report.pdf");

				fileStream.open(this._pdfFile, FileMode.WRITE);
				var bytes:ByteArray = pdf.save(Method.LOCAL);
				fileStream.writeBytes(bytes);
				fileStream.close();
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

			if(this._startDateInput._input.text.length == 0) validationArray.push("Please select a start date");
			if(this._finishDateInput._input.text.length == 0) validationArray.push("Please select an end date");

			return validationArray.join("<br/>");
		}

		private function displaySavedPDF():void
		{
			this._pdfPopupContainer = new HivivaPDFPopUp();
			this._pdfPopupContainer.scale = this.dpiScale;
			this._pdfPopupContainer.width = this.actualWidth;
			this._pdfPopupContainer.height = this.actualHeight;
			this._pdfPopupContainer.addEventListener("sendMail", mailBtnHandler);
			this._pdfPopupContainer.addEventListener(Event.CLOSE, closePopup);
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

		private function closePopup(e:Event):void
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

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}
	}
}
