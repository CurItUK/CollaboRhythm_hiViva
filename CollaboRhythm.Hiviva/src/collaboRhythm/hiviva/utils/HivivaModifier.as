package collaboRhythm.hiviva.utils
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.view.HivivaStartup;

	import flash.geom.Point;

	import starling.display.Image;

	public class HivivaModifier
	{
		public static const WeekDays:Array = new Array("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");
		public static const Months:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");

		public function HivivaModifier()
		{
		}

		public static function getBrandName(value:String):String
		{
			var startIndex:uint = value.indexOf("[");
			var endIndex:uint = value.indexOf("]");
			var brandName:String = value.substring(startIndex + 1, endIndex)

			return brandName;
		}

		public static function getGenericName(value:String):String
		{
			var startIndex:uint = value.indexOf("[");
			var genericName:String = value.substring(0, startIndex);

			return genericName;
		}

		public static function getNeatTabletText(value:String):String
		{
			var tabletText:String = value + " tablet" + (int(value) > 1 ? "s" : "");

			return tabletText;
		}

		public static function getNeatTime(value:String):String
		{
			var timeText:String;
			//enforce leading zero
			if(value.length == 1)
			{
				timeText = "0" + value;
			}
			else
			{
				timeText = value;
			}
			timeText += ":00";

			return timeText;
		}

		public static function getAS3DatefromString(value:String):Date
		{
			var date:Date = new Date();
			var sqDateArray:Array = value.split("-");
			date.setDate(sqDateArray[0]);
			date.setMonth(Number(sqDateArray[1]) - 1);
			date.setFullYear(sqDateArray[2]);
			//trace(date.getDate());
			return date;
		}

		public static function getSQLStringFromDate(value:Date):String
		{
			var sqDate:String = value.getDate() + "-" + Number(value.getMonth() + 1) + "-" + value.getFullYear();

			return sqDate;
		}

		public static function getDaysDiff(endDate:Date, startDate:Date):Number
		{
			var dayDiff:Number;
			var endMidnight:Date = new Date(endDate.getFullYear(),endDate.getMonth(),endDate.getDate(),0,0,0,0);
			var startMidnight:Date = new Date(startDate.getFullYear(),startDate.getMonth(),startDate.getDate(),0,0,0,0);
/*

			endMidnight.setHours(0,0,0,0);
			startMidnight.setHours(0,0,0,0);
*/

			if (endMidnight > startMidnight)
			{
				dayDiff = (endMidnight.time - startMidnight.time) / 86400000;
			}
			else
			{
				dayDiff = 0;
			}

			return dayDiff;
		}

		public static function generateAppId():String
		{
			var appId:String = "",
				segmentLength:int = 3,
				segment:String;

			for (var i:int = 0; i < segmentLength; i++)
			{
				segment = int(Math.random() * 999).toString();
				if (segment.length == 1)
				{
					appId += "00";
				}
				else if (segment.length == 2)
				{
					appId += "0";
				}
				appId += segment;
				if(i < (segmentLength - 1))
				{
					appId += "-";
				}
			}

			return appId;
		}

		public static function degreesToRadians(deg:Number):Number
		{
			return deg * (Math.PI/180);
		}

		public static function calculateOverallTolerability(tolerabilityXMLList:XMLList):Number
		{
			var history:XMLList = tolerabilityXMLList;
			var historyCount:uint = history.length();
			var avgTolerability:Number = 0;
			if (historyCount > 0)
			{
				for (var i:uint = 0; i < historyCount; i++)
				{
					avgTolerability += parseInt(history[i].tolerability);
				}
				avgTolerability = (avgTolerability / historyCount);
			}

			return  Math.round(avgTolerability);
		}
/*

		public static function calculateOverallAdherence(adherenceXMLList:XMLList):Number
		{
			var history:XMLList = adherenceXMLList;
			var historyCount:uint = history.length();
			var avgAdherence:Number = 0;
			if (historyCount > 0)
			{
				for (var i:uint = 0; i < historyCount; i++)
				{
					avgAdherence += parseInt(history[i].adherence);
				}
				avgAdherence = (avgAdherence / historyCount);
			}

			return  Math.round(avgAdherence);
		}
*/

		public static function getAllMedicationAdherence(patientMedicationHistory:XML):Number
		{
			var adherencePercent:Number;
			var medications:XMLList = patientMedicationHistory.medication as XMLList;
			var medicationsLength:int = medications.length();
			var adheredCount:int = 0;
			for (var i:int = 0; i < medicationsLength; i++)
			{
				if(medications[i].adhered == "yes")
				{
					adheredCount++;
				}
			}
			adherencePercent = (adheredCount / medicationsLength) * 100;

			return adherencePercent;
		}

		public static function getPatientAdherenceByDate(patientData:XML, compareDate:Date):Number
		{
			var adherencePercent:Number;
			var dateCompareStr:String = getCalendarStringFromDate(compareDate);
			var history:XMLList = patientData.medicationHistory.history as XMLList;
			var historyLength:int = history.length();
			var patientMedicationHistory:XML;
			for (var k:int = 0; k < historyLength; k++)
			{
				patientMedicationHistory = history[k] as XML;
	//			trace(patientMedicationHistory.date + " == " + dateCompareStr);
				adherencePercent = patientMedicationHistory.date == dateCompareStr ? getAllMedicationAdherence(patientMedicationHistory) : 0;
				if(adherencePercent > 0) break;
			}
			return adherencePercent;
		}

		public static function getPatientTolerabilityByDate(patientData:XML, compareDate:Date):Number
		{
			var tolerability:Number;
			var dateCompareStr:String = getCalendarStringFromDate(compareDate);
			var history:XMLList = patientData.medicationHistory.history as XMLList;
			var historyLength:int = history.length();
			var patientMedicationHistory:XML;
			for (var k:int = 0; k < historyLength; k++)
			{
				patientMedicationHistory = history[k] as XML;
	//			trace(patientMedicationHistory.date + " == " + dateCompareStr);
				tolerability = patientMedicationHistory.date == dateCompareStr ? Number(patientMedicationHistory.tolerability) : 0;
				if(tolerability > 0) break;
			}
			return tolerability;
		}

		public static function getPatientAdherenceByMedication(adherenceXMLList:XMLList, medicationId:int, startDate:Date, endDate:Date):Number
		{
			var adherencePercent:Number;
			var history:XMLList = adherenceXMLList;
			var historyCount:uint = history.length();
			var historyRangeCount:uint = 0;
			var historicalDate:Date;
			var medication:XMLList;
			var adherenceCount:int = 0;
			if (historyCount > 0)
			{
				for (var i:uint = 0; i < historyCount; i++)
				{
					historicalDate = getDateFromCalendarString(history[i].date);
					if(historicalDate.getTime() > startDate.getTime() && historicalDate.getTime() < endDate.getTime())
					{
						historyRangeCount++;
						medication = history[i].medication.(@id == medicationId);
						if (medication.adhered == "yes")
						{
							adherenceCount++;
						}
					}
				}
				adherencePercent = (adherenceCount / historyRangeCount) * 100;
			}

			return Math.round(adherencePercent);
		}

		public static function calculateOverallAdherence(adherenceXMLList:XMLList):Number
		{
			var history:XMLList = adherenceXMLList;
			var historyCount:uint = history.length();
			var currAdherence:Number;
			var avgAdherence:Number = 0;
			if (historyCount > 0)
			{
				for (var i:uint = 0; i < historyCount; i++)
				{
					currAdherence = getAllMedicationAdherence(history[i] as XML);
					avgAdherence += currAdherence;
				}
				avgAdherence = (avgAdherence / historyCount);
			}

			return Math.round(avgAdherence);
		}

		public static function getDateFromCalendarString(dateStr:String):Date
		{
			var dateData:Array = dateStr.split('/');
			return new Date(int(dateData[2]),int(dateData[0]) - 1,int(dateData[1]),0,0,0,0);
		}

		public static function getCalendarStringFromDate(date:Date):String
		{
			return addPrecedingZero((date.getMonth() + 1).toString()) + "/" + addPrecedingZero(date.getDate().toString()) + "/" + date.getFullYear();
		}

		public static function addPrecedingZero(val:String):String
		{
			var zeroFilledVal:String;
			if(val.length < 2)
			{
				zeroFilledVal = "0" + val;
			}
			else
			{
				zeroFilledVal = val;
			}
			return zeroFilledVal;
		}

		public static function floorToClosestMonday(date:Date):void
		{
			var dayOfWeek:Number = date.getDay();
			if(dayOfWeek < 1)
			{
				date.date -= 6;
			}
			else if(dayOfWeek > 1)
			{
				date.date -= (dayOfWeek - 1);
			}
		}



		public static function clipImage(img:Image):void
		{
			var 	sizeDiff:Number,
					sizeRatio:Number,
					top:Number = 0,
					left:Number = 0,
					right:Number = 1,
					bottom:Number = 1;

			if(img.height > img.width)
			{
				// this is a portrait image
				sizeDiff = (img.height - img.width);
				sizeRatio = sizeDiff / img.height;
				top = (sizeRatio * 0.5);
				left = 0;
				right = 1;
				bottom = 1 - (sizeRatio * 0.5);
			}
			else if (img.height < img.width)
			{
				sizeDiff = (img.width - img.height );
				sizeRatio = sizeDiff / img.width;
				top = 0;
				left = (sizeRatio * 0.5);
				right = 1 - (sizeRatio * 0.5);
				bottom = 1;
			}

			img.setTexCoords(0, new Point(left, top));
			img.setTexCoords(1, new Point(right, top));
			img.setTexCoords(2, new Point(left, bottom));
			img.setTexCoords(3, new Point(right, bottom));
		}

		public static function toUKDateFromUS(date:String):String
		{
			var dateSplit:Array = date.split("-");
			return dateSplit[2] + "-" + dateSplit[0] + "-" + dateSplit[1];
		}

		public static function toUSDateFromUK(date:String):String
		{
			var dateSplit:Array = date.split("-");
			return dateSplit[1] + "/" + dateSplit[2] + "/" + dateSplit[0];
		}

		public static function calculateDailyAdherence(patientShedules:XMLList):Number
		{
			var scheduleList:XMLList = patientShedules ;
			var scheduleCount:uint = scheduleList.length();
			var scheduleTaken:uint = 0;
			for(var i :uint = 0 ; i < scheduleCount ; i++)
			{
				if(scheduleList[i].Taken == "true") scheduleTaken += 1;
			}
			var percentage:Number = Math.round(scheduleTaken / scheduleCount * 100);

			return percentage;
		}

		public static function isoDateToFlashDate(value:String):Date
		{
			// 2013-07-13T14:25:15.9644542+01:00
			var splitAtT:Array = value.split("T");
			var dateArr:Array = String(splitAtT[0]).split("-");
			var splitAtPlus:Array = String(splitAtT[1]).split("+");
			var timeArr:Array = String(splitAtPlus[0]).split(":");

			var date:Date = new Date(int(dateArr[0]),int(dateArr[1])-1,int(dateArr[2]),int(timeArr[0]),int(timeArr[1]),int(timeArr[2]),null);

			return date;
		}

		public static function isoDateToPrettyString(value:String):String
		{
			var prettyStr:String;
			var date:Date = isoDateToFlashDate(value);
			if(getDaysDiff(HivivaStartup.userVO.serverDate, date) > 0)
			{
				// return date and month name
				prettyStr = date.getDate() + " " + String(Months[date.getMonth()]).substr(0,3);
			}
			else
			{
				// today, so return time in 24 hour
				var prettyHours:String = date.getHours().toString();
				var prettyMinutes:String = date.getMinutes().toString();
				if(prettyHours.length == 1)
				{
					prettyHours = "0" + prettyHours;
				}
				if(prettyMinutes.length == 1)
				{
					prettyMinutes = "0" + prettyMinutes;
				}
				prettyStr = prettyHours + "." + prettyMinutes;
				// TODO : need to compare to server time for just now
//				if(prettyStr == "00.00") prettyStr = "Just now";
			}

			return prettyStr;
		}

		public static function getDaysDiffence(futureDate:Date , pastDate:Date):Number
		{
			var milliSecondsToDays:Number = 24 * 60 * + 60 * 1000;
			return Math.round((futureDate.valueOf()) / milliSecondsToDays - (pastDate.valueOf()) / milliSecondsToDays);
		}
	}
}
