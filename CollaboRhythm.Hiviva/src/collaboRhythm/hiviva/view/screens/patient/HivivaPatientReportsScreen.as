package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.Calendar;
	import collaboRhythm.hiviva.view.components.ReportChart;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;

	import flash.display3D.Context3D;

	import flash.events.TimerEvent;
	import flash.geom.Point;

	import flash.net.URLLoader;
	import flash.system.System;
	import flash.utils.Timer;

	import mx.graphics.codec.JPEGEncoder;

	import mx.graphics.codec.PNGEncoder;

	import org.alivepdf.images.ColorSpace;
	import org.alivepdf.layout.Mode;
	import org.alivepdf.layout.Position;
	import org.alivepdf.layout.Resize;

	import starling.core.RenderSupport;

	import starling.display.DisplayObject;
	import starling.display.Stage;

//	import com.diadraw.extensions.mail.MailExtensionEvent;
//	import com.diadraw.extensions.mail.NativeMailWrapper;
	//import org.bytearray.smtp.mailer.SMTPMailer;
	//import org.bytearray.smtp.encoding.JPEGEncoder;
	//import org.bytearray.smtp.encoding.PNGEnc;
	//import org.bytearray.smtp.events.SMTPEvent;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.events.FeathersEventType;

	import flash.display.Sprite;
	import flash.events.StageOrientationEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;

	import mx.collections.ArrayCollection;
	import mx.events.ResizeEvent;

	import org.alivepdf.colors.RGBColor;

	import org.alivepdf.data.Grid;

	import org.alivepdf.data.GridColumn;
	import org.alivepdf.drawing.Joint;

	import org.alivepdf.fonts.CoreFont;

	import org.alivepdf.fonts.FontFamily;

	import org.alivepdf.fonts.IFont;
	import org.alivepdf.layout.Align;

	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;

	import starling.core.Starling;
	import starling.events.Event;

	import flash.net.URLRequest;
 	import flash.net.URLRequestMethod;
 	import flash.net.URLVariables;


	public class HivivaPatientReportsScreen extends ValidationScreen
	{

		private var _startDateInput:LabelAndInput;
		private var _startDateButton:Button;
		private var _finishDateInput:LabelAndInput;
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
		private var _stageWebView:StageWebView;
		private var _calendarActive:Boolean;
		//private var m_mailExtension : NativeMailWrapper;
		private const ATTACHMENT_FILE : String = "patient_report.pdf";

		//private var myMailer:SMTPMailer;
		private var messageAttachment:ByteArray;

		private var _pdfPopupContainer:HivivaPDFPopUp;

		private var mSubject:String;
		private var mBody:String;
		private var mAttachment:String;

		private var request:URLRequest;

		private var _reportTemplateLocation:String;
		private var pdf:File;
		private var _patientData:XML;
		private var _patientProfile:Array;
		private var _medications:Array;
		private var _reportChartTimer:Timer;
		private var _reportChart:ReportChart;
		private var _adherenceChartBd:BitmapData;
		private var _tolerabilityChartBd:BitmapData;

		public function HivivaPatientReportsScreen()
		{

		}

		override protected function draw():void
		{
			this._customHeight = this.actualHeight - Constants.FOOTER_BTNGROUP_HEIGHT;
			super.draw();
			this._content.validate();
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

			this._adherenceCheck.defaultLabelProperties.width = this._innerWidth * 0.9;
			this._feelingCheck.defaultLabelProperties.width = this._innerWidth * 0.9;
			this._cd4Check.defaultLabelProperties.width = this._innerWidth * 0.9;
			this._viralLoadCheck.defaultLabelProperties.width = this._innerWidth * 0.9;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

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

			this._reportDatesLabel = new Label();
			this._reportDatesLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
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
			this._includeLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
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
			this._calendar.addEventListener(FeathersScreenEvent.CALENDAR_BUTTON_TRIGGERED, calendarButtonHandler);

			// TODO : to be removed when we have remote data
			initPatientXMLData();

		}



		private function calendarButtonHandler(e:FeathersScreenEvent):void
		{
			PopUpManager.removePopUp(this._calendar);
			this._activeCalendarInput.text = e.evtData.date;
		}

		private function startDateCalendarHandler(e:starling.events.Event):void
		{

			this._activeCalendarInput = this._startDateInput._input;
			this._calendar.cType = "start";

			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.validate();

			if(this._calendarActive) this._calendar.resetCalendar();

			this._calendarActive = true;
			//PopUpManager.centerPopUp(this._calendar);
		}

		private function finishDateCalendarHandler(e:starling.events.Event):void
		{
			this._activeCalendarInput = this._finishDateInput._input;
			this._calendar.cType = "finish";

			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.validate();

			if(this._calendarActive) this._calendar.resetCalendar();

			this._calendarActive = true;
			//PopUpManager.centerPopUp(this._calendar);
		}

		private function previewSendHandler(e:starling.events.Event):void
		{
			// TODO : validate medications and schedule when we have data from remote database
//			localStoreController.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);
//			localStoreController.getPatientProfile();
			var formValidation:String = patientReportsCheck();
			if (formValidation.length == 0)
			{
				localStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);
				localStoreController.getAdherence();
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function initPatientXMLData():void
		{
			var patientToLoadURL:String = "/resources/patient_111222333.xml";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE , patientXMLFileLoadHandler);
			loader.load(new URLRequest(patientToLoadURL));
		}

		private function patientXMLFileLoadHandler(e:flash.events.Event):void
		{
			_patientData = XML(e.target.data);
		}

		private function getPatientProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);
			_patientProfile = e.data.patientProfile;

			if(_patientProfile == null)
			{
				showFormValidation("You must be signed up to generate a report");
			}
			else
			{
				localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE, medicationsLoadCompleteHandler);
				localStoreController.getMedicationList();
			}
		}

		private function medicationsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE, medicationsLoadCompleteHandler);
			_medications = e.data.medications;

			if(_medications == null)
			{
				showFormValidation("You must have added at least 1 medicine to generate a report");
			}
			else
			{
				var formValidation:String = patientReportsCheck();
				if (formValidation.length == 0)
				{
					localStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);
					localStoreController.getAdherence();
				}
				else
				{
					showFormValidation(formValidation);
				}
			}
		}

		private function patientReportsCheck():String
		{
			var validationArray:Array = [];

			if(this._startDateInput._input.text.length == 0) validationArray.push("Please select a start date");
			if(this._finishDateInput._input.text.length == 0) validationArray.push("Please select an end date");

			if(this._startDateInput._input.text.length != 0 && this._finishDateInput._input.text.length != 0)
			{
				var isValidDate:Boolean = validateDates();
				if(!isValidDate)validationArray.push("Invalid date selection - start and end dates");
			}

			return validationArray.join("<br/>");
		}

		private function validateDates():Boolean
		{
			var tempStart:Array = new Array();
			var tempFinish:Array = new Array();

			tempStart = this._startDateInput._input.text.split('/');
			tempFinish = this._finishDateInput._input.text.split('/');

			var startAdd:Number = tempStart[2]*1300 + tempStart[0]*100 + tempStart[1];
			var endAdd:Number = tempFinish[2]*1300 + tempFinish[0]*100 + tempFinish[1];

			if(startAdd > endAdd){
				return false;
			}
			else{
				return true;
			}
		}

		private function adherenceLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);
			if(this._cd4Check.isSelected || this._viralLoadCheck.isSelected)
			{
				getTestResults();
			}
			else
			{
	//			generatePDFReport();
				displayHtmlReport();
			}
		}

		private function getTestResults():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.TEST_RESULTS_LOAD_COMPLETE, testResultsLoadCompleteHandler);
			localStoreController.getTestResults();
		}

		private function testResultsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.TEST_RESULTS_LOAD_COMPLETE, testResultsLoadCompleteHandler);
//			generatePDFReport();
			displayHtmlReport();
		}

		private function displayHtmlReport():void
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
			/*pdf = File.applicationStorageDirectory.resolvePath("patient_report.pdf");

			var htmlString:String = "<!DOCTYPE HTML>" +
			            "<html>" +
						"<body>" +
			            "<p>HTML TEST</p>" +
			            "</body></html>";

			//this._stageWebView.loadURL(pdf.nativePath);
			this._stageWebView.loadString(htmlString);*/

			drawAndSaveReportCharts();
		}

		private function drawAndSaveReportCharts():void
		{
			this._reportChart = new ReportChart();
			this._reportChart.dataCategory = "adherence";
			this._reportChart.startDate = HivivaModifier.getDateFromString(this._startDateInput._input.text);
			this._reportChart.endDate = HivivaModifier.getDateFromString(this._finishDateInput._input.text);
			this._reportChart.patientData = _patientData;
			// must be added to stage or snapshot will be blank
			addChild(this._reportChart);
			this._reportChart.width = this._reportChart.height = this.actualWidth;
			this._reportChart.x = this._reportChart.y = -this.actualWidth;
			this._reportChart.validate();
			this._reportChart.drawChart();

			// timer needed as labels inside the chart don't get drawn in time
			this._reportChartTimer = new Timer(10);
//			this._reportChartTimer.addEventListener(TimerEvent.TIMER, reportChartTimerHandler);
			this._reportChartTimer.addEventListener(TimerEvent.TIMER, drawAndSaveAdherenceChart);
			this._reportChartTimer.start();
		}

		private function drawAndSaveAdherenceChart(e:TimerEvent):void
		{
			this._reportChartTimer.removeEventListener(TimerEvent.TIMER, drawAndSaveAdherenceChart);
			this._reportChartTimer.stop();

			this._adherenceChartBd = copyToBitmap(this._reportChart, this.dpiScale);
			var pngenc:PNGEncoder = new PNGEncoder();
			var byteArray:ByteArray = pngenc.encode(this._adherenceChartBd);

			var reportDir:File = File.applicationStorageDirectory.resolvePath("report_template/adherence-chart.png");
			var fs:FileStream = new FileStream();
			fs.addEventListener(flash.events.Event.CLOSE, initTolerabilityChart);

			try
			{
				//open file in write mode
				fs.openAsync(reportDir,FileMode.WRITE);
				//write bytes from the byte array
				fs.writeBytes(byteArray);
				//close the file
				fs.close();
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}

		private function initTolerabilityChart(e:flash.events.Event):void
		{
			var fs:FileStream = e.target as FileStream;
			fs.removeEventListener(flash.events.Event.CLOSE, initTolerabilityChart);
			fs = null;

			removeChild(this._reportChart);
			this._reportChart.dispose();

			this._reportChart = new ReportChart();
			this._reportChart.dataCategory = "tolerability";
			this._reportChart.startDate = HivivaModifier.getDateFromString(this._startDateInput._input.text);
			this._reportChart.endDate = HivivaModifier.getDateFromString(this._finishDateInput._input.text);
			this._reportChart.patientData = _patientData;
			// must be added to stage or snapshot will be blank
			addChild(this._reportChart);
			this._reportChart.width = this._reportChart.height = this.actualWidth;
			this._reportChart.x = this._reportChart.y = -this.actualWidth;
			this._reportChart.validate();
			this._reportChart.drawChart();

			this._reportChartTimer.addEventListener(TimerEvent.TIMER, drawAndSaveTolerabilityChart);
			this._reportChartTimer.start();
		}

		private function drawAndSaveTolerabilityChart(e:TimerEvent):void
		{
			this._reportChartTimer.removeEventListener(TimerEvent.TIMER, drawAndSaveTolerabilityChart);
			this._reportChartTimer.stop();

			this._tolerabilityChartBd = copyToBitmap(this._reportChart, this.dpiScale);

			var pngenc:PNGEncoder = new PNGEncoder();
			var byteArray:ByteArray = pngenc.encode(this._tolerabilityChartBd);

			var reportDir:File = File.applicationStorageDirectory.resolvePath("report_template/tolerability-chart.png");

			var fs:FileStream = new FileStream();
			fs.addEventListener(flash.events.Event.CLOSE, cleanUpStream);

			try
			{
				//open file in write mode
				fs.openAsync(reportDir,FileMode.WRITE);
				//write bytes from the byte array
				fs.writeBytes(byteArray);
				//close the file
				fs.close();
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}

		private function cleanUpStream(e:flash.events.Event):void
		{
			var fs:FileStream = e.target as FileStream;
			fs.removeEventListener(flash.events.Event.CLOSE, cleanUpStream);
			fs = null;

			removeChild(this._reportChart);
			this._reportChart.dispose();
			this._reportChart = null;

			this._reportChartTimer = null;

			System.gc();

			this._reportTemplateLocation = "file://" + File.applicationStorageDirectory.resolvePath("report_template/index.html").nativePath;
			this._stageWebView.addEventListener(flash.events.Event.COMPLETE, stageWebCompleteHandler);
			this._stageWebView.loadURL(this._reportTemplateLocation);
		}

		private function __copyToBitmap(disp:DisplayObject, scl:Number=1.0):BitmapData
		{
			var rc:Rectangle = new Rectangle();
			disp.getBounds(disp, rc);
//			rc.x = disp.x;
//			rc.y = disp.y;
//			rc.width = disp.width;
//			rc.height = disp.height;

			var stage:Stage = Starling.current.stage;
			var rs:RenderSupport = new RenderSupport();

			rs.clear(stage.color , 1.0);
			rs.applyBlendMode(true);
			rs.scaleMatrix(scl, scl);
			rs.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
			rs.translateMatrix(-rc.x, -rc.y); // move to 0,0
			//rs.transformMatrix(this.root);
		//	rs.translateMatrix( -resultRect.x, -resultRect.y);

			disp.render(rs, 1.0);
			rs.finishQuadBatch();
			var __nw : Number = rc.width*scl ;
			var __nh : Number = rc.height*scl ;
			var outBmp:BitmapData = new BitmapData(__nw, __nh , false);
			Starling.context.drawToBitmapData(outBmp);

			return outBmp;
			/*
			if (sprite == null) return null;
			var resultRect:Rectangle = new Rectangle();
			sprite.getBounds(sprite, resultRect);
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			support.transformMatrix(sprite.root);
			support.translateMatrix( -resultRect.x, -resultRect.y);
			var result:BitmapData = new BitmapData(resultRect.width, resultRect.height, true, 0x00000000);
			support.pushMatrix();
			support.transformMatrix(sprite);
			sprite.render(support, 1.0);
			support.popMatrix();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
			*/
		}

		public static function copyToBitmap( displayObject : DisplayObject,transparentBackground : Boolean = false, backgroundColor : uint = 0xcccccc ) : BitmapData
		{
		    var resultRect : Rectangle = new Rectangle();
		    displayObject.getBounds( displayObject, resultRect );

		    var result : BitmapData = new BitmapData( Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, transparentBackground, backgroundColor );
		    var context : Context3D = Starling.context;

		    var support : RenderSupport = new RenderSupport();
		//			RenderSupport.clear();
		    var stage:Stage= Starling.current.stage;
		    RenderSupport.clear(stage.color,0.0);
			support.clear();
		    support.setOrthographicProjection(0,0, Starling.current.stage.stageWidth  , Starling.current.stage.stageHeight    );

		    support.applyBlendMode( true );

			support.scaleMatrix(1.0,1.0);
		    support.translateMatrix( -resultRect.x, -resultRect.y );
		    support.pushMatrix();
	   	    support.blendMode = displayObject.blendMode;

		    displayObject.render(support, 1.0 );

		    support.popMatrix();

		    support.finishQuadBatch();
		    context.drawToBitmapData( result );

		    var croppedRes:BitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0x00000000 );
		       //croppedRes.copyPixels(result, resultRect, new Point(0,0));
              //  croppedRes.threshold(result, new Rectangle(0,0,displayObject.width, displayObject.height), new Point(0,0), "==", stage.color, 0x0000ff00, 0x0000ff, true);
			croppedRes.threshold(result, new Rectangle(0,0,displayObject.width, displayObject.height), new Point(0,0), "==", stage.color, 0x0000ff00, 0x0000ff, true);

		    return croppedRes;
		}

		private function stageWebCompleteHandler(e:flash.events.Event):void
		{
			this._stageWebView.removeEventListener(flash.events.Event.COMPLETE, stageWebCompleteHandler);
			var startDate:String = this._startDateInput._input.text;
			var endDate:String = this._finishDateInput._input.text;
			/*
			var hashStr:String = "#";

			hashStr += "patient-name=" + _patientData.name;
			hashStr += "&" + "result-date-range=" + startDate + " - " + endDate;

			this._stageWebView.loadURL(this._stageWebView.location + hashStr);
			*/

			var medications:XMLList = _patientData.medications.medication;
			var medicationHistory:XMLList = _patientData.medicationHistory.history;
			var hashStr:String = "#";
			for (var i:int = 0; i < medications.length(); i++)
			{
				hashStr += "<strong>" + medications[i].brandname + "</strong><br />" + medications[i].genericname + "=" +
						HivivaModifier.getPatientAdherenceByMedication(medicationHistory,int(medications[i].id),HivivaModifier.getDateFromString(startDate),HivivaModifier.getDateFromString(endDate));
				if(i < medications.length() - 1) hashStr += "&";
			}
			trace(hashStr);
			this._stageWebView.loadURL(this._reportTemplateLocation + hashStr);
			generatePDFReport();
		}

		private function generatePDFReport():void
		{
			var size:Size = Size.A4;
			var pdf:PDF = new PDF(Orientation.PORTRAIT, Unit.MM, Size.A4);
			var helveticaNomal:IFont = new CoreFont ( FontFamily.HELVETICA );
			var helveticaBold:IFont = new CoreFont ( FontFamily.HELVETICA_BOLD );

//			var date:Date = new Date();

			pdf.addPage();

			//Title
			pdf.setFont(helveticaBold , 14);
			pdf.writeText(12, "Patient Report\n");

			pdf.addImage(new Bitmap(this._adherenceChartBd), new Resize ( Mode.FIT_TO_PAGE, Position.LEFT ),0,12);
			this._adherenceChartBd.dispose();
			this._adherenceChartBd = null;
//			pdf.setFont(helveticaNomal , 12);
//			pdf.writeText(12, "Patient Name / AppID\n");

/*

			//Date
			pdf.setFont(helveticaBold , 14);
			pdf.writeText(12, "Date: ");
			pdf.setFont(helveticaNomal , 12);
			pdf.writeText(12, date.getMonth() + "/" + date.getDay() + "/" + date.getFullYear() + "\n");

			//Subject
			pdf.setFont(helveticaBold , 14);
			pdf.writeText(12, "Subject: ");
			pdf.setFont(helveticaNomal , 12);
			pdf.writeText(12, "Please find below details of ... record of their HIV tracking via the HiVIVA application. This covers the time period between: "
					+ this._startDateInput._input.text + " - "
					+ this._finishDateInput._input.text + "\n");
*/


			//Test Results
/*
			var dp:ArrayCollection = new ArrayCollection ();
			dp.addItem( { date : "15/06/2013", cd4 : "350", viralLoad : "<50,000" } );



			var gridColumnDate:GridColumn = new GridColumn("Date", "date", 20, Align.LEFT, Align.LEFT);
			var gridColumnCd4:GridColumn = new GridColumn("CD4 count (cells/mm3)", "cd4", 20, Align.LEFT, Align.LEFT);
			var gridColumnViralLoad:GridColumn = new GridColumn("Viral Load (copies/ml)", "viralLoad", 20, Align.LEFT, Align.LEFT);


			var columns:Array = new Array ( gridColumnDate , gridColumnCd4 , gridColumnViralLoad);

			//data:Array,width:Number,height:Number,headerColor:org.alivepdf.colors.IColor,cellColor:org.alivepdf.colors.IColor,
			var grid:Grid = new Grid ( dp.toArray(), 200, 100, new RGBColor (0x00CCFF), new RGBColor (0xFFFFFF), new RGBColor ( 0x0 ) , new RGBColor ( 0x0 ) , 1);

			grid.columns = columns;

			pdf.setFont(helveticaNomal , 12);
			pdf.textStyle(new RGBColor ( 0x0 ),1);

			pdf.addGrid(grid);
			*/
			var startDate:String = this._startDateInput._input.text;
			var endDate:String = this._finishDateInput._input.text;
			var medications:XMLList = _patientData.medications.medication;
			var medicationHistory:XMLList = _patientData.medicationHistory.history;
			var adherenceValue:Number;
			var adherenceTotal:Number = 0;
			var adherenceCollection:ArrayCollection = new ArrayCollection();
			for (var i:int = 0; i < medications.length(); i++)
			{
				adherenceValue =  HivivaModifier.getPatientAdherenceByMedication(medicationHistory,int(medications[i].id),HivivaModifier.getDateFromString(startDate),HivivaModifier.getDateFromString(endDate));
				adherenceTotal += adherenceValue;
				adherenceCollection.addItem({adherenceName : medications[i].brandname + "\n" + medications[i].genericname,
											adherenceValue : adherenceValue});
			}
			adherenceCollection.addItem({adherenceName : "Average", adherenceValue : Math.round(adherenceTotal /= medications.length())});

			var gridColumnNames:GridColumn = new GridColumn("", "adherenceName", 95, Align.LEFT, Align.LEFT);
			var gridColumnValues:GridColumn = new GridColumn("Adherence for this period (%)", "adherenceValue", 95, Align.LEFT, Align.LEFT);
			var columns:Array = new Array ( gridColumnNames , gridColumnValues);

			//data:Array,width:Number,height:Number,headerColor:org.alivepdf.colors.IColor,cellColor:org.alivepdf.colors.IColor,
			var grid:Grid = new Grid ( adherenceCollection.toArray(), 190, 100, new RGBColor (0xFFFFFF), new RGBColor (0xFFFFFF), false , new RGBColor ( 0x0 ) , 1);
//			grid.y = 100;
			grid.columns = columns;

			pdf.setFont(helveticaNomal , 12);
			pdf.textStyle(new RGBColor ( 0x0 ),1);

			pdf.addGrid(grid,0,200);

			pdf.addPage();

			pdf.addImage(new Bitmap(this._tolerabilityChartBd), new Resize ( Mode.FIT_TO_PAGE, Position.LEFT ));
			this._tolerabilityChartBd.dispose();
			this._tolerabilityChartBd = null;

			var fileStream:FileStream = new FileStream();

			this._pdfFile = File.applicationStorageDirectory.resolvePath("patient_report.pdf");

			fileStream.open(this._pdfFile, FileMode.WRITE);
			var bytes:ByteArray = pdf.save(Method.LOCAL);
			messageAttachment = bytes;
			fileStream.writeBytes(bytes);
			fileStream.close();
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
			mSubject = "Test";
			mBody= "Test body";
			mAttachment = pdf.nativePath;

			var url:String = "mailto:youllforget@googlemail.com?subject="+ mSubject + "Configurador&body="+ mBody + "&attachment="+ mAttachment;

			request = new URLRequest(url);

			navigateToURL(request, '_self');


		//	myMailer.sendAttachedMail ( "This is a test message", "youllforget@googlemail.com", "Test subject", "Test body", messageAttachment, "image.jpg");

		//	getURL("mailto:you@yourdomain.com?subject=Whatever&body=First Name: %0D%0A Last Name: %0D%0A Telephone: %0D%0A Email Address: %0D%0A Questions or Comments:");
		}


	/*
		private function mailBtnHandler(e:starling.events.Event):void
		{

			closePopup(e);
			//TODO add mail native extentions for IOS and Android
			//http://diadraw.com/projects/adobe-air-native-e-mail-extension/

			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;

			if(iOS)
			{
				ensureExtension();
				if ( m_mailExtension.isMailComposerAvailable() )
				{
					var pathToFile : String = getPathToAttachment();
					sendEmail( pathToFile, ATTACHMENT_FILE, "image/png" );
				}
				else // Try and launch the default mail client on the device outside our app - maybe e-mail hasn't been configured yet
				{
					var request : URLRequest = new URLRequest( "mailto:" );
					navigateToURL( request );
				}
			}

		}
	*/
		private function sendEmail( _attachmentPath : String, _fileName : String, _mimeType : String ) : void
		{
			//stage.removeEventListener( StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged );
			//stage.addEventListener( StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged );

			//stage.removeEventListener( StageOrientationEvent.ORIENTATION_CHANGING, orientationChangingCapture, true );
			//stage.addEventListener( StageOrientationEvent.ORIENTATION_CHANGING, orientationChangingCapture, true, 99 );

			//this.removeEventListener( ResizeEvent.RESIZE, onViewResize );
			//this.addEventListener( ResizeEvent.RESIZE, onViewResize );
/*
			var subject : String = "Hey, there is a workaround for the orientation issue!";
			var body : String = "Details in this blog post: <a href=http://blog.diadraw.com/native-extensions-for-mobile-air-apps-getting-round-the-orientation-issue>http://blog.diadraw.com/native-extensions-for-mobile-air-apps-getting-round-the-orientation-issue</a>";

			var attachmentStr : String = _attachmentPath + "|" + _mimeType + "|" + _fileName;

			m_mailExtension.sendMail
					(
							subject,
							body,
							"",
							"",
							"",
							[attachmentStr],
							true );
*/
		}

		private function ensureExtension():void
		{
			/*
			m_mailExtension = new NativeMailWrapper();

			m_mailExtension.removeEventListener( MailExtensionEvent.MAIL_COMPOSER_EVENT, handleMailComposerEvent );
			m_mailExtension.addEventListener( MailExtensionEvent.MAIL_COMPOSER_EVENT, handleMailComposerEvent );
			*/
		}
/*
		private function handleMailComposerEvent( _event : MailExtensionEvent ) : void
		{
			if ( -1 != _event.composeResult.indexOf( MailExtensionEvent.MAIL_COMPOSER_DISMISSED ) )
			{

				//stage.removeEventListener( StageOrientationEvent.ORIENTATION_CHANGING, orientationChangingCapture, true );
				//stage.removeEventListener( StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged );
			}
		}
*/
		private function handleMailComposerEvent( _event :* ) : void
		{

		}

		private function orientationChanged( _event : StageOrientationEvent ) : void
		{
			trace("orientationChanged");
		}

		private function orientationChangingCapture( _event : StageOrientationEvent ) : void
		{
			_event.stopImmediatePropagation();
			_event.stopPropagation();

			if ( _event.cancelable )
			{
				trace( "    Cancelling change" );
				_event.preventDefault();
			}
			else
			{
				trace( "    Can't cancel change" );
			}
		}

		private function onViewResize( _event : ResizeEvent ) : void
		{
			trace("onViewResize")
		}

		public override function dispose():void
		{
			trace("HivivaPatientReportsScreen dispose");
			super.dispose();
		}

		private function getPathToAttachment() : String
		{
			var sourceFile : File = File.applicationStorageDirectory;
			sourceFile = sourceFile.resolvePath("patient_report.pdf");

			if ( !sourceFile.exists )
			{
				trace( "Couldn't find attachment file: " + sourceFile.nativePath );
				return "";
			}
			return sourceFile.nativePath;
		}
	}
}
