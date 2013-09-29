package collaboRhythm.hiviva.utils
{
	import com.distriqt.extension.message.Message;
	import com.distriqt.extension.message.MessageAttachment;

	import feathers.core.FeathersControl;

	import flash.display.Bitmap;

	import flash.display.BitmapData;

	import flash.events.Event;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;

	import starling.core.RenderSupport;
	import starling.core.Starling;


	public class PDFReportMailer
	{

		private var _pdfReport:PDF;
		private var _reportFile:File;

		private var _emailAddress:String;
		private var _bodyText:String;
		private var _displayObject:FeathersControl;

		public function PDFReportMailer(emailAddress:String , bodyText:String , displayReport:FeathersControl)
		{
			this._emailAddress = emailAddress;
			this._bodyText = bodyText;
			this._displayObject = displayReport;
			createAndSavePDF();
		}

		private function createAndSavePDF():void
		{
			this._pdfReport = new PDF( Orientation.PORTRAIT, Unit.MM, Size.A4 );
			this._pdfReport.addPage();

			trace("createAndSavePDF " +  Starling.current.nativeStage.width , Starling.current.nativeStage.width)

			var bmd:BitmapData = new BitmapData(500 , 500 , true , 0x00000000);

			Starling.context.clear();

			Starling.context.drawToBitmapData(bmd) ;

			var bp:Bitmap = new Bitmap(bmd);

			this._pdfReport.addImage(bp);


			this._pdfReport.addCell( 200, 20,this._bodyText)
			//this._pdfReport.writeText(12,this._bodyText);

			var fileStream:FileStream = new FileStream();
			this._reportFile = File.applicationStorageDirectory.resolvePath("report.pdf");
			fileStream.addEventListener(Event.CLOSE, fileSaveCompleteHandler);
			fileStream.openAsync( this._reportFile, FileMode.WRITE);
			var bytes:ByteArray = this._pdfReport.save( Method.LOCAL );
			fileStream.writeBytes(bytes);
			fileStream.close();
		}

		private function fileSaveCompleteHandler(event:Event):void
		{
			mailPDFFile(this._reportFile.nativePath);
		}

		private function mailPDFFile(filePath:String):void
		{
			if (Message.isMailSupported)
			{

				var email:String = this._emailAddress;

				Message.service.sendMailWithOptions(
						"Patient Report",
						"Patient Report",
						String(email),
						"",
						"",
						[
							new MessageAttachment( filePath,  "application/pdf" )
						],
						false
				);
			}
		}


	}
}
