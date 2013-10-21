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

		private var _emailAddress:String;
		private var _outfile:File;

		public function PDFReportMailer(emailAddress:String)
		{
		  this._emailAddress = emailAddress;
		}

		public function createAndSavePDF(data:ByteArray):void
		{

			this._outfile = File.applicationStorageDirectory.resolvePath("report.pdf");
			var outStream:FileStream = new FileStream();
			outStream.addEventListener(Event.CLOSE, fileSaveCompleteHandler);
			outStream.openAsync(this._outfile, FileMode.WRITE);
			outStream.writeBytes(data, 0, data.length);
			outStream.close();
		}

		private function fileSaveCompleteHandler(event:Event):void
		{
			trace("PDF Complete " + this._outfile.nativePath);
			mailPDFFile(this._outfile.nativePath);
		}

		private function mailPDFFile(filePath:String):void
		{
			if (Message.isMailSupported)
			{

				var email:String =  this._emailAddress

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
