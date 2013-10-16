package collaboRhythm.hiviva.utils
{
	import com.distriqt.extension.message.Message;
	import com.distriqt.extension.message.MessageAttachment;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class PDFReportMailer
	{

		public function PDFReportMailer()
		{

		}

		public function createAndSavePDF(data:ByteArray):void
		{

			var outFile:File = File.applicationStorageDirectory.resolvePath("report.pdf");
			var outStream:FileStream = new FileStream();
			outStream.addEventListener(Event.CLOSE, fileSaveCompleteHandler);
			outStream.openAsync(outFile, FileMode.WRITE);
			outStream.writeBytes(data, 0, data.length);
			outStream.close();
		}

		private function fileSaveCompleteHandler(event:Event):void
		{
			trace("PDF Complete");
			//mailPDFFile(this._reportFile.nativePath);
		}

		private function mailPDFFile(filePath:String):void
		{
			if (Message.isMailSupported)
			{

				var email:String = "email address here..."; //this._emailAddress;

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
