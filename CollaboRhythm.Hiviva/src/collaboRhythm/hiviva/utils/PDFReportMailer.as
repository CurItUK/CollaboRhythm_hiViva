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

		public function PDFReportMailer()
		{
			createAndSavePDF();
		}

		private function createAndSavePDF():void
		{
			this._pdfReport = new PDF( Orientation.PORTRAIT, Unit.MM, Size.A4 );
			this._pdfReport.addPage();

			var msg:String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas lobortis elit ";
			this._pdfReport.writeText(12,msg);

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

				var email:String = "barry@pharmiweb.com";

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
