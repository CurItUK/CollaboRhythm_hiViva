package collaboRhythm.hiviva.utils
{
	import com.distriqt.extension.message.Message;
	import com.distriqt.extension.message.MessageAttachment;

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

	public class PDFReportMailer
	{

		private var _pdfReport:PDF;
		private var _reportFile:File;

		private var _emailAddress:String;
		private var _bodyText:String;

		public function PDFReportMailer(emailAddress:String , bodyText:String)
		{
			this._emailAddress = emailAddress;
			this._bodyText = bodyText;
			createAndSavePDF();
		}

		private function createAndSavePDF():void
		{
			this._pdfReport = new PDF( Orientation.PORTRAIT, Unit.MM, Size.A4 );
			this._pdfReport.addPage();

			this._pdfReport.writeText(12,this._bodyText);

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
