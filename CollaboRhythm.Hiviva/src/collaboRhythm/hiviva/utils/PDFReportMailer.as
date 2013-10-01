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

			trace("createAndSavePDF " +   HivivaStartup.hivivaStartup.starFW.stage.height , HivivaStartup.hivivaStartup.starFW.stage.width)








			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear(0xff00ff , 1.0);
			support.setOrthographicProjection(0,0,640, 2000);
			HivivaStartup.hivivaStartup.starFW.stage.render(support, 1.0);
			support.finishQuadBatch();

			var result:BitmapData = new BitmapData(HivivaStartup.hivivaStartup.starFW.stage.width, 2000, true);
			HivivaStartup.hivivaStartup.starFW.context.drawToBitmapData(result);

			var bp:Bitmap = new Bitmap(result);




			//this._pdfReport.addImage(bp);
			this._pdfReport.addImage(new Bitmap(copyDisplayObjectToBitmap(this._displayObject)));





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

			rs.clear();
			rs.scaleMatrix(scl, scl);
			rs.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
			rs.translateMatrix(-rc.x, -rc.y); // move to 0,0
			disp.render(rs, 1.0);
			rs.finishQuadBatch();

			var outBmp:BitmapData = new BitmapData(rc.width*scl, rc.height*scl, true , 0x00000000);
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
