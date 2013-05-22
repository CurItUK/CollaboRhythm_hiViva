package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.view.*;



	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;

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


	public class HivivaPatientReportsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _startLabel:Label;
		private var _startDateInput:TextInput;
		private var _finishDateInput:TextInput;


		private var _finishLabel:Label;
		private var _reportDatesLabel:Label;
		private var _includeLabel:Label;
		private var _adherenceCheck:Check;
		private var _feelingCheck:Check;
		private var _cd4Check:Check;
		private var _viralLoadCheck:Check;
		private var _previewAndSendBtn:Button;

		private var _pdfFile:File;
		private var _stageWebView:StageWebView
		private var _alphaUnderlay:Sprite

		private var _pdfPopupContainer:HivivaPDFPopUp;

		public function HivivaPatientReportsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._reportDatesLabel.y = this._header.height + 10;
			this._reportDatesLabel.x = 10;
			this._reportDatesLabel.width = 200;
			this._reportDatesLabel.validate();

			this._startLabel.y = this._reportDatesLabel.y + this._reportDatesLabel.height + 20;
			this._startLabel.x = 50
			this._startLabel.width = 200;
			this._startLabel.validate();

			this._startDateInput.y = this._startLabel.y;
			this._startDateInput.width = this.actualWidth - this._startLabel.width - 200;
			this._startDateInput.x = this._startLabel.x + this._startLabel.width + 10;
			this._startDateInput.validate();

			this._finishLabel.y = this._startLabel.y + this._startLabel.height + 60;
			this._finishLabel.x = 50;
			this._finishLabel.width = 200;
			this._finishLabel.validate();

			this._finishDateInput.y = this._finishLabel.y;
			this._finishDateInput.width = this.actualWidth - this._finishLabel.width - 200;
			this._finishDateInput.x = this._finishLabel.x + this._finishLabel.width + 10;
			this._finishDateInput.validate();

			this._includeLabel.y = this._finishLabel.y + this._finishLabel.height + 30;
			this._includeLabel.x = 10;
			this._includeLabel.width = 200;
			this._includeLabel.validate();

			this._adherenceCheck.width = this.actualWidth;
			this._adherenceCheck.validate();
			this._adherenceCheck.y = this._includeLabel.y + this._includeLabel.height + 20;

			this._feelingCheck.width = this.actualWidth;
			this._feelingCheck.validate();
			this._feelingCheck.y = this._adherenceCheck.y + this._adherenceCheck.height;

			this._cd4Check.width = this.actualWidth;
			this._cd4Check.validate();
			this._cd4Check.y = this._feelingCheck.y + this._feelingCheck.height;

			this._viralLoadCheck.width = this.actualWidth;
			this._viralLoadCheck.validate();
			this._viralLoadCheck.y = this._cd4Check.y + this._cd4Check.height;

			this._previewAndSendBtn.validate();
			this._previewAndSendBtn.x = this.actualWidth / 2 - this._previewAndSendBtn.width / 2;
			this._previewAndSendBtn.y = this._viralLoadCheck.y + this._viralLoadCheck.height + 20;


		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Generate Reports";
			this.addChild(this._header);

			this._reportDatesLabel = new Label();
			this._reportDatesLabel.text = "<font face='ExoBold'>Report dates</font>";
			this.addChild(this._reportDatesLabel);

			this._startLabel = new Label();
			this._startLabel.text = "Start";
			this.addChild(this._startLabel);

			this._startDateInput = new TextInput();
			this.addChild(this._startDateInput);

			this._finishLabel = new Label();
			this._finishLabel.text = "Finish";
			this.addChild(this._finishLabel);

			this._finishDateInput = new TextInput();
			this.addChild(this._finishDateInput);

			this._includeLabel = new Label();
			this._includeLabel.text = "<font face='ExoBold'>Include</font>";
			this.addChild(this._includeLabel);

			this._adherenceCheck = new Check();
			this._adherenceCheck.isSelected = false;
			this._adherenceCheck.label = "Adherence";
			addChild(this._adherenceCheck);

			this._feelingCheck = new Check();
			this._feelingCheck.isSelected = false;
			this._feelingCheck.label = "How I am feeling";
			addChild(this._feelingCheck);

			this._cd4Check = new Check();
			this._cd4Check.isSelected = false;
			this._cd4Check.label = "CD4 count test results";
			addChild(this._cd4Check);

			this._viralLoadCheck = new Check();
			this._viralLoadCheck.isSelected = false;
			this._viralLoadCheck.label = "Viral load test results";
			addChild(this._viralLoadCheck);

			this._previewAndSendBtn = new Button();
			this._previewAndSendBtn.label = "Preview and send";
			this._previewAndSendBtn.addEventListener(starling.events.Event.TRIGGERED, previewSendHandler);
			addChild(this._previewAndSendBtn);
		}

		private function previewSendHandler(e:starling.events.Event):void
		{
			//TODO move PDF creating into UTILS class
			//TODO move fileStream - report PDF file creation to local service class

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
	}
}
