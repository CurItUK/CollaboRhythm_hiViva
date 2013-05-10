package collaboRhythm.hiviva.global
{
    // SQL DateTime column value example: 2009-05-04T14:00:00

    public class DateTransformFactory
    {

        public function DateTransformFactory()
        {

        }

        // convert SQL DateTime string to AS3 Date object
        public static function convertSQLDateTimeToASDate(s:String):Date
        {
            // split the date from the time
            var dt:Array = s.split("T");
            // separate the date values
            var d:Array = dt[0].split("-");
            // separate the time values
            var t:Array = dt[1].split(":");

            // do if statement here
            d[0] = adjustYearForPrevMilennia(d[0]);
            var date:Date = new Date(d[0], d[1]-1, d[2], t[0], t[1], t[2]);
            return date;
        }

        // helper function to enforce 1900 series year values
        private static function adjustYearForPrevMilennia(year:int):int
        {
            if (year < 2000)
            {
                var syear:String = year.toString();
                syear = syear.substr(2, 2);
                year = parseInt(syear);
            }

            return year;
        }

        // convert AS3 date to SQL DateTime formatted string
        public static function convertASDateToSQLDateTime(date:Date):String
        {
            // month processing
            date.month++;
            var month:String = enforceLeadingZero(date.month);

            // day processing
            var day:String = enforceLeadingZero(date.day);

            // hour processing
            var hours:String = enforceLeadingZero(date.hours);

            // minutes processing
            var minutes:String = enforceLeadingZero(date.minutes);

            // seconds processing
            var seconds:String = enforceLeadingZero(date.seconds);

            return date.fullYear + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds;
        }

        // same as above using UTC
        public static function convertASDateUTCToSQLDateTime(date:Date):String
        {
            // month processing
            date.month++;
            var month:String = enforceLeadingZero(date.monthUTC);

            // day processing
            var day:String = enforceLeadingZero(date.dayUTC);

            // hour processing
            var hours:String = enforceLeadingZero(date.hoursUTC);

            // minutes processing
            var minutes:String = enforceLeadingZero(date.minutesUTC);

            // seconds processing
            var seconds:String = enforceLeadingZero(date.secondsUTC);

            return date.fullYearUTC + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds;
        }

        // leading zero helper function needed for correct fromatting of SQL ready string
        private static function enforceLeadingZero(i:int):String
        {
            if (i.toString().length < 2)
            {
                return "0" + i;
            }
            else
            {
                return i.toString();
            }
        }

    }

}