package collaboRhythm.hiviva.model
{
	//TODO change name of class as now includes multiple collections

	import feathers.data.ListCollection;

	public class MedicationScheduleTimeList
	{

		public static function timeList():ListCollection
		{
			var listCollection:ListCollection = new ListCollection(

					[
						{text: "00.00" , time:00},
						{text: "01.00" , time:01},
						{text: "02.00" , time:02},
						{text: "03.00" , time:03},
						{text: "04.00" , time:04},
						{text: "05.00" , time:05},
						{text: "06.00" , time:06},
						{text: "07.00" , time:07},
						{text: "08.00" , time:08},
						{text: "09.00" , time:09},
						{text: "10.00" , time:10},
						{text: "11.00" , time:11},
						{text: "12.00" , time:12},
						{text: "13.00" , time:13},
						{text: "14.00" , time:14},
						{text: "15.00" , time:15},
						{text: "16.00" , time:16},
						{text: "17.00" , time:17},
						{text: "18.00" , time:18},
						{text: "19.00" , time:19},
						{text: "20.00" , time:20},
						{text: "21.00" , time:21},
						{text: "22.00" , time:22},
						{text: "23.00" , time:23}
					]);
			return listCollection;
		}

		public static function tabletList():ListCollection
		{
			var listCollection:ListCollection = new ListCollection(

					[
						{text: "1 Tablet", count: 1},
						{text: "2 Tablets", count: 2},
						{text: "3 Tablets", count: 3}
					]);
			return listCollection;
		}
	}
}
