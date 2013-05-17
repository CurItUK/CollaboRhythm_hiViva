package collaboRhythm.hiviva.utils
{
	// TODO: change class name
	public class MedicationNameModifier
	{
		public function MedicationNameModifier()
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
	}
}
