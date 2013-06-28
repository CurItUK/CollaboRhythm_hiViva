package collaboRhythm.hiviva.utils
{
	import flash.geom.Point;

	import starling.display.Image;

	public class HivivaModifier
	{
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
			var endMidnight:Date = endDate;
			var startMidnight:Date = startDate;

			endMidnight.setHours(0,0,0,0);
			startMidnight.setHours(0,0,0,0);

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
			var medicationHistory:XMLList = patientMedicationHistory.medication as XMLList;
			var medicationHistoryLength:int = medicationHistory.length();
			var adheredCount:int = 0;
			for (var i:int = 0; i < medicationHistoryLength; i++)
			{
				if(medicationHistory[i].adhered == "yes")
				{
					adheredCount++;
				}
			}
			adherencePercent = (adheredCount / medicationHistoryLength) * 100;

			return adherencePercent;
		}

		public static function getPatientAdherenceByDate(patientMedicationHistory:XML, compareDate:Date):Number
		{
			var adherencePercent:Number;
			var dateCompareStr:String = getStringFromDate(compareDate);
//			trace(patientMedicationHistory.date + " == " + dateCompareStr);
			adherencePercent = patientMedicationHistory.date == dateCompareStr ? getAllMedicationAdherence(patientMedicationHistory) : 0;
			return adherencePercent;
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
					historicalDate = getDateFromString(history[i].date);
					// start from end date as the xml data is structured from latest first
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

		public static function getDateFromString(dateStr:String):Date
		{
			var dateData:Array = dateStr.split('/');
			return new Date(int(dateData[2]),int(dateData[0]) - 1,int(dateData[1]),0,0,0,0);
		}

		public static function getStringFromDate(date:Date):String
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
				date.date -= (dayOfWeek + 1);
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
	}
}
