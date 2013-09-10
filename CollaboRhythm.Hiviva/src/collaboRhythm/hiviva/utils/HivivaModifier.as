package collaboRhythm.hiviva.utils
{
	import collaboRhythm.hiviva.view.HivivaStartup;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	import starling.display.Image;

	public class HivivaModifier
	{
		public static const WeekDays:Array = new Array("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");
		public static const Months:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");

		public function HivivaModifier()
		{
		}

		public static function getSummaryStringFromPatientData(patientData:XML):String
		{
			var summaryStr:String;

			var adherence:String = patientData.adherence;
			var tolerability:String = patientData.tolerability;

			// if patient has no medication history
			if (adherence == "-1" && tolerability == "-1")
			{
				summaryStr = "No data exists \nfor this patient";
			}

			// if patient has missed recording their schedule within the predefined history
			if (adherence > "-1" && tolerability == "-1")
			{
				summaryStr = "Adherence: " + adherence + "%\n" + "Tolerability: None";
			}

			if (adherence > "-1" && tolerability > "-1")
			{
				summaryStr = "Adherence: " + adherence + "%\n" + "Tolerability: " + tolerability + "%";
			}

			return summaryStr;
		}

		public static function getAppIdWithGuid(guid:String):String
		{
			var appId:String;
			var patientData:Array = HivivaStartup.connectionsVO.users;

			for (var i:int = 0; i < patientData.length; i++)
			{
				if(patientData[i].guid == guid)
				{
					appId = patientData[i].appid;
					break;
				}
			}

			return appId;
		}

		public static function establishToFromId(idsToCompare:XML):Object
		{
			var whoEstablishConnection:Object = [];
			if(idsToCompare.FromAppId == HivivaStartup.userVO.appId)
			{
				whoEstablishConnection.appGuid = idsToCompare.ToUserGuid;
				whoEstablishConnection.appId = idsToCompare.ToAppId;
			} else
			{
				whoEstablishConnection.appGuid = idsToCompare.FromUserGuid;
				whoEstablishConnection.appId = idsToCompare.FromAppId;
			}

			return whoEstablishConnection;
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

		public static function getCalendarStringFromIsoString(isoStr:String):String
		{
			var date:Date = getDateFromIsoString(isoStr, false);
			return getCalendarStringFromDate(date);
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

			if (img.height < img.width)
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

		public static function getDateFromIsoString(value:String, setToUTC:Boolean = true):Date
		{
			// 2013-07-13T14:25:15.9644542+01:00
			var date:Date;
			var splitAtT:Array = value.split("T");
			var dateArr:Array = String(splitAtT[0]).split("-");
			var splitAtPlus:Array = String(splitAtT[1]).split("+");
			var timeArr:Array = String(splitAtPlus[0]).split(":");
			var rawDateFromIso:Date = new Date(int(dateArr[0]),int(dateArr[1])-1,int(dateArr[2]),int(timeArr[0]),int(timeArr[1]),int(timeArr[2]),null);

			if(setToUTC)
			{
				var noUKDSTDate:Date = removeUKDSTFromDate(rawDateFromIso);
				date = convertToLocalTime(noUKDSTDate);
			}
			else
			{
				date = rawDateFromIso;
			}

			return date;
		}

		public static function removeUKDSTFromDate(dtDate:Date):Date
		{
			var lastSundayOfMarch:int = getDateOfLastSundayOfMonth(2);
			var lastSundayOfOctober:int = getDateOfLastSundayOfMonth(9);
			var startDSTDate:Date = new Date(dtDate.getFullYear(), 2, lastSundayOfMarch, 1,0,0,0);
			var endDSTDate:Date = new Date(dtDate.getFullYear(), 9, lastSundayOfOctober, 1,0,0,0);

			if(dtDate.getTime() > startDSTDate.getTime() && dtDate.getTime() < endDSTDate.getTime())
			{
				dtDate.hours -= 1;
			}

			return dtDate;
		}

		public static function addUKDSTToDate(dtDate:Date):Date
		{
			var lastSundayOfMarch:int = getDateOfLastSundayOfMonth(2);
			var lastSundayOfOctober:int = getDateOfLastSundayOfMonth(9);
			var startDSTDate:Date = new Date(dtDate.getFullYear(), 2, lastSundayOfMarch, 1,0,0,0);
			var endDSTDate:Date = new Date(dtDate.getFullYear(), 9, lastSundayOfOctober, 1,0,0,0);

			if(dtDate.getTime() > startDSTDate.getTime() && dtDate.getTime() < endDSTDate.getTime())
			{
				dtDate.hours += 1;
			}

			return dtDate;
		}

		public static function getDateOfLastSundayOfMonth(month:int):int
		{
			var temp:Date = new Date();
			// set to last day of march
			temp.setMonth(month,31);
			// round down to get the last sunday of the month
			if(temp.getDay() > 0) temp.date -= temp.getDay();

			return temp.getDate();
		}

		public static function convertToLocalTime(dtDate:Date):Date
		{
			dtDate.setTime(dtDate.getTime() - (dtDate.getTimezoneOffset() * 60000));
			// add locale DST according to device OS
			if(dtDate.toTimeString().indexOf("+") > -1) dtDate.hours += 1;
			return dtDate;
		}

		public static function convertToUTCTime(dtDate:Date):Date
		{
			dtDate.setTime(dtDate.getTime() + (dtDate.getTimezoneOffset() * 60000));
			// remove locale DST according to device OS
			if(dtDate.toTimeString().indexOf("+") > -1) dtDate.hours -= 1;
			return dtDate;
		}

		public static function getIsoStringFromDate(dtDate:Date, setToUTC:Boolean = true):String
		{
			// 2013-07-13T14:25:15
			var rawDate:Date = new Date(dtDate.getFullYear(),dtDate.getMonth(),dtDate.getDate(),dtDate.getHours(),dtDate.getMinutes(),dtDate.getSeconds(),dtDate.getMilliseconds());
			var targDate:Date;

			if(setToUTC)
			{
				var UTCDate:Date = convertToUTCTime(rawDate);
				var DSTDate:Date = addUKDSTToDate(UTCDate);
				targDate = DSTDate;
			}
			else
			{
				targDate = rawDate;
			}

			var month:Number = targDate.getMonth() + 1;
			var day:Number = targDate.getDate();
			var hours:Number = targDate.getHours();
			var mins:Number = targDate.getMinutes();
			var secs:Number = targDate.getSeconds();

			var isoStr:String =
			targDate.getFullYear() + "-" +
			addPrecedingZero(month.toString()) + "-" +
			addPrecedingZero(day.toString()) + "T" +
			addPrecedingZero(hours.toString()) + ":" +
			addPrecedingZero(mins.toString()) + ":" +
			addPrecedingZero(secs.toString());

			return isoStr;
		}

		public static function getPrettyStringFromIsoString(value:String, setToUTC:Boolean = false, getTimeForToday:Boolean = true):String
		{
			var date:Date = getDateFromIsoString(value, setToUTC);
			var prettyStr:String = getPrettyStringFromDate(date, getTimeForToday);

			return prettyStr;
		}

		public static function getPrettyStringFromDate(date:Date, getTimeForToday:Boolean = true):String
		{
			var prettyStr:String;
			var isToday:Boolean = getDaysDiff(HivivaStartup.userVO.serverDate, date) == 0;

			if(getTimeForToday && isToday)
			{
				// today, so return time in 24 hour
				var prettyHours:String = addPrecedingZero(date.getHours().toString());
				var prettyMinutes:String = addPrecedingZero(date.getMinutes().toString());
				prettyStr = prettyHours + "." + prettyMinutes;
			}
			else
			{
				prettyStr = date.getDate() + " " + String(Months[date.getMonth()]).substr(0,3)
			}

			return prettyStr;
		}

		public static function getDaysDiffence(futureDate:Date , pastDate:Date):Number
		{
			var milliSecondsToDays:Number = 24 * 60 * + 60 * 1000;
			return Math.round((futureDate.valueOf()) / milliSecondsToDays - (pastDate.valueOf()) / milliSecondsToDays);
		}

		public static function getChronologicalDictionaryFromXmlList(medicationsXml:XMLList):Dictionary
		{
			var history:Dictionary = new Dictionary();

			var medicationLength:int = medicationsXml.length();
			var medicationSchedule:XMLList;
			var medicationScheduleLength:int;
//			var referenceDate:Date;
			var referenceDate:String;
			var medicationId:String;
			for (var i:int = 0; i < medicationLength; i++)
			{
				medicationSchedule = medicationsXml[i].Schedule.DCMedicationSchedule as XMLList;
				medicationId = medicationsXml[i].MedicationID;

				medicationScheduleLength = medicationSchedule.length();
				for (var j:int = 0; j < medicationScheduleLength; j++)
				{
//					referenceDate = HivivaModifier.getDateFromIsoString(String(medicationSchedule[j].DateTaken),false);
					referenceDate = String(medicationSchedule[j].DateTaken).split('+')[0];
					if (history[referenceDate] == undefined) history[referenceDate] = [];
					history[referenceDate].push({id:medicationId,data:medicationSchedule[j]});
				}
			}

			return history;
		}

		public static function getFinalStartAndEndDatesFromXmlList(medicationsXml:XMLList):Object
		{
			var serverDate:Date = HivivaStartup.userVO.serverDate;
			var startAndEndDates:Object = {};
//			var prevStartDate:Date = new Date(0,0,0,0,0,0,0);
//			prevEndDate should start as yesterday to ensure startAndEndDates.latestSchedule gets set
//			var prevEndDate:Date = new Date(serverDate.getFullYear(),serverDate.getMonth(),serverDate.getDate() - 1,serverDate.getHours(),serverDate.getMinutes(),serverDate.getSeconds(),serverDate.getMilliseconds());
			var prevStartDate:Date;
			var prevEndDate:Date;
			var yesterday:Date = new Date(serverDate.getFullYear(),serverDate.getMonth(),serverDate.getDate() - 1,serverDate.getHours(),serverDate.getMinutes(),serverDate.getSeconds(),serverDate.getMilliseconds());
			var currStartDate:Date;
			var currEndDate:Date;
			for (var j:int = 0; j < medicationsXml.length(); j++)
			{
				currStartDate = HivivaModifier.getDateFromIsoString(medicationsXml[j].StartDate, false);
				currEndDate = (String(medicationsXml[j].Stopped)) ==
						"true" ? HivivaModifier.getDateFromIsoString(medicationsXml[j].EndDate, false) : yesterday;

				if(prevStartDate == null) prevStartDate = new Date(currStartDate.getTime());
				if(prevEndDate == null) prevEndDate = new Date(currEndDate.getTime());

				if (prevStartDate.getTime() < currStartDate.getTime())
				{
					startAndEndDates.earliestSchedule = prevStartDate.getTime();
				}
				else
				{
					startAndEndDates.earliestSchedule = currStartDate.getTime();
				}

				if (prevEndDate.getTime() > currEndDate.getTime())
				{
					startAndEndDates.latestSchedule = prevEndDate.getTime();
				}
				else
				{
					startAndEndDates.latestSchedule = currEndDate.getTime();
				}

				prevStartDate = new Date(currStartDate.getFullYear(), currStartDate.getMonth(), currStartDate.getDate(),currStartDate.getHours(),currStartDate.getMinutes(),currStartDate.getSeconds(),currStartDate.getMilliseconds());
				prevEndDate = new Date(currEndDate.getFullYear(), currEndDate.getMonth(), currEndDate.getDate(),currStartDate.getHours(),currStartDate.getMinutes(),currStartDate.getSeconds(),currStartDate.getMilliseconds());
			}

			// debug
			var earliestSchedule:Date = new Date();
			earliestSchedule.setTime(startAndEndDates.earliestSchedule);
			var latestSchedule:Date = new Date();
			latestSchedule.setTime(startAndEndDates.latestSchedule);
			trace('ultimate start date = ' + earliestSchedule.toDateString());
			trace('ultimate end date = ' + latestSchedule.toDateString());

			return startAndEndDates;
		}

	}
}
