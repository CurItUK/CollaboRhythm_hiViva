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
			date.setMonth(sqDateArray[1]);
			date.setFullYear(sqDateArray[2]);

			return date;
		}

		public static function getSQLStringFromDate(value:Date):String
		{
			var sqDate:String = value.getDate() + "-" + value.getMonth() + "-" + value.getFullYear();

			return sqDate;
		}

		public static function getDaysDiff(endDate:Date, startDate:Date):Number
		{
			var dayDiff:Number;
			if (endDate > startDate)
			{
				dayDiff = Math.floor((endDate.time - startDate.time) / 86400000);
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

			return Math.round(avgAdherence);
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
