package collaboRhythm.hiviva.utils
{
	import collaboRhythm.hiviva.view.HivivaStartup;

	import com.distriqt.extension.message.Message;
	import com.distriqt.extension.message.MessageAttachment;

	import feathers.core.FeathersControl;

	import flash.display.Bitmap;

	import flash.display.BitmapData;

	import flash.events.Event;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;


	public class PDFReportMailer
	{

		private var _pdfReport:PDF;
		private var _reportFile:File;

		private var _emailAddress:String;
		private var _bodyText:String;

		private var _reportObjects:Array;

		public function PDFReportMailer(emailAddress:String , bodyText:String , reportObjects:Array)
		{
			this._emailAddress = emailAddress;
			this._bodyText = bodyText;
			this._reportObjects = reportObjects;

			createAndSavePDF();
		}

		private function createAndSavePDF():void
		{
			this._pdfReport = new PDF( Orientation.PORTRAIT, Unit.MM, Size.A4 );
			this._pdfReport.addPage();

			trace("createAndSavePDF " +   HivivaStartup.hivivaStartup.starFW.stage.height , HivivaStartup.hivivaStartup.starFW.stage.width)


			 var loop:uint = this._reportObjects.length;
			for(var i:uint = 0 ; i < loop ; i++)
			{
				this._pdfReport.addImage(new Bitmap(copyDisplayObjectToBitmap(this._reportObjects[i] , 0.8) , "auto" , true));
			}



			//this._pdfReport.addImage(new Bitmap(copyDisplayObjectToBitmap(this._displayObject , 0.8) , "auto" , true));





			//this._pdfReport.addCell( 200, 20,this._bodyText)
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


		private function copyDisplayObjectToBitmap(disp:DisplayObject , scl:Number = 1.0):BitmapData
		{
			var rc:Rectangle = new Rectangle();
			disp.getBounds(disp, rc);

			var stage:Stage = Starling.current.stage;
			var rs:RenderSupport = new RenderSupport();

			rs.clear(0x226db7 , 1.0);
			rs.scaleMatrix(scl, scl);
			rs.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
			rs.translateMatrix(-rc.x, -rc.y); // move to 0,0
			disp.render(rs, 1.0);
			rs.finishQuadBatch();

			var outBmp:BitmapData = new BitmapData(rc.width*scl, rc.height*scl, true);
			Starling.context.drawToBitmapData(outBmp);

			return outBmp;
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
