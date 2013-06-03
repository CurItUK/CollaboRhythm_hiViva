package collaboRhythm.hiviva.view.components
{

	import collaboRhythm.hiviva.global.FeathersScreenEvent;

	import feathers.controls.Button;
	
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.events.Event;

	public class Calendar extends FeathersControl
	{
		private var _allDayCells:Array = [];
		private var _firstDayOfMonth:Date;
		private var _daysPerWeek:Array = new Array(6,0,1,2,3,4,5);
		private var _weekDays:Array = new Array("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");
		private var _maxDaysMonth:uint = 30;
		private var _leapYear:Number;
		private var _cellWidth:Number = 50;
		private var _cellHeight:Number = 50;
		private var _cellSpacing:Number = 70;
		private var _monthList:PickerList;
		private var _yearList:PickerList;
		private var _scale:Number;

		public function Calendar()
		{
			super();
		}

		override protected function draw():void
		{
			initCalendar()
		}

		override protected function initialize():void
		{

		}
		
		private function initCalendar():void
		{
			getCurrentDate();
			createDayHolderCells();
			createDayNameLabels();
			populateDayCellsWithData();
			createMonthChooser();
			createYearChooser();
		}
		
		private function getCurrentDate():void
		{
			var now:Date = new Date();
			this._firstDayOfMonth = new Date(now.fullYear, now.month, 1);
		}
		
		private function createDayHolderCells():void
		{
			for(var i:uint = 0 ; i < 42 ; i++)
			{
				var cell:Button = new Button();
				cell.name = "calendar-day-cell";
				cell.isEnabled = false;
				this.addChild(cell);
				cell.validate();
				
				cell.x = 10 + (cell.width * (i - (Math.floor(i/7) * 7)));
				cell.y = 150 + (cell.height * Math.floor(i/7));
				
				this._allDayCells.push(cell);
			}
		}
		
		private function createDayNameLabels():void
		{
			this._cellWidth = this._allDayCells[0].width;
			for (var i:uint = 0 ; i < 7; i++)
			{
				var days:Label = new Label();
				days.name = "calendar-days";
				days.text = this._weekDays[i];
				this.addChild(days);
				
				days.validate();
				days.width = this._cellWidth;
				
				days.x = 10 + (this._cellWidth * i);
				days.y = 100;

			}
		}
		
		private function populateDayCellsWithData():void
		{
			clearDownDayCells();
			populateFirstDayOfMonthCell();
			calculateLeapYear();
			calculateMaxDaysPerMonth();
			
			populatePresentDayCells();
			populateFutureMonthDays();
			populatePastMonthDays();
		}
		
		private function populateFirstDayOfMonthCell():void
		{
			this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]].label=1;
			this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]].isEnabled = true;
			this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]].addEventListener(starling.events.Event.TRIGGERED , daySelectedHandler);
		}
		
		private function populatePresentDayCells():void
		{
			for (var i:uint = 1; i < this._maxDaysMonth; i++)
			{
				this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].label = i+1;
				this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].isEnabled = true;
				this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].addEventListener(starling.events.Event.TRIGGERED , daySelectedHandler);
				
			}
		}
		
		private function calculateLeapYear():void
		{
			if (this._firstDayOfMonth.fullYear %4 == 0 && this._firstDayOfMonth.fullYear % 100 !=0 || this._firstDayOfMonth.fullYear %400 == 0)
			{
				this._leapYear=1;
			} 
			else
			{
				this._leapYear=0;
			}
		}
		
		private function calculateMaxDaysPerMonth():void
		{
			if (this._firstDayOfMonth.month==0||this._firstDayOfMonth.month==2||this._firstDayOfMonth.month==4||this._firstDayOfMonth.month==6||this._firstDayOfMonth.month==7||this._firstDayOfMonth.month==9||this._firstDayOfMonth.month==11)
			{
				this._maxDaysMonth = 31;
			} else if (this._firstDayOfMonth.month==3 || this._firstDayOfMonth.month==5 || this._firstDayOfMonth.month==8 || this._firstDayOfMonth.month==10)
			{
				this._maxDaysMonth = 30;
			} else if (this._firstDayOfMonth.month==1 && this._leapYear==1)
			{
				this._maxDaysMonth = 29;
			} else
			{
				this._maxDaysMonth = 28;
			}
		}
		
		private function populateFutureMonthDays():void
		{
			
			for (var i:Number = 1; i < (42 - this._maxDaysMonth - this._daysPerWeek[this._firstDayOfMonth.day] + 1); i++)
			{
				this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day] + i + this._maxDaysMonth - 1].label = i;
//				this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day] + i + this._maxDaysMonth - 1].alpha = 0.8;
			}
		}
		
		private function populatePastMonthDays():void
		{
			
			var prefirst:Date = new Date(this._firstDayOfMonth.fullYear,this._firstDayOfMonth.month,this._firstDayOfMonth.date - 1);
			for (var i:Number = this._daysPerWeek[this._firstDayOfMonth.day]; i > 0; i--)
			{
				this._allDayCells[this._daysPerWeek[i]].label = prefirst.date-(this._daysPerWeek[this._firstDayOfMonth.day] - i);
				
//				this._allDayCells[this._daysPerWeek[i]].alpha = 0.8;
			}
		}
		
		private function createMonthChooser():void
		{
			this._monthList = new PickerList();
			
			var monthsdata:ListCollection = new ListCollection(
				[
					{text:"January", data:0},
					{text:"February", data:1},
					{text:"March", data:2},
					{text:"April", data:3},
					{text:"May", data:4},
					{text:"June", data:5},
					{text:"July", data:6},
					{text:"August", data:7},
					{text:"September", data:8},
					{text:"October", data:9},
					{text:"November", data:10},
					{text:"December", data:11},
				]);
			
			this._monthList.dataProvider = monthsdata;
			this._monthList.listProperties.@itemRendererProperties.labelField = "text";
			this._monthList.labelField = "text";
			this._monthList.selectedIndex = this._firstDayOfMonth.month;
			this._monthList.addEventListener(starling.events.Event.CHANGE , monthChangeHandler);
			this.addChild(this._monthList);
			this._monthList.validate();
			this._monthList.x = 10;
			this._monthList.y = 10;
		}
		
		private function monthChangeHandler(e:starling.events.Event):void
		{
			
			this._firstDayOfMonth.month = this._monthList.selectedItem.data;
			populateDayCellsWithData();
		}
		
		private function createYearChooser():void
		{
			this._yearList = new PickerList();
			
			var monthsdata:ListCollection = new ListCollection(
				[
					{text:"2011", data:2011},
					{text:"2012", data:2012},
					{text:"2013", data:2013},
					{text:"2014", data:2014},
					{text:"2015", data:2015},
					{text:"2016", data:2016},
					{text:"2017", data:2017},
					{text:"2018", data:2018},
					{text:"2019", data:2019},
					{text:"2020", data:2020},
					
				]);
			
			this._yearList.dataProvider = monthsdata;
			this._yearList.listProperties.@itemRendererProperties.labelField = "text";
			this._yearList.labelField = "text";
			this._yearList.selectedIndex = -1;
			this._yearList.prompt = String(this._firstDayOfMonth.fullYear);
			this._yearList.addEventListener(starling.events.Event.CHANGE , yearChangeHandler);
			this.addChild(this._yearList);
			this._yearList.validate();
			this._yearList.y = 10;
			this._yearList.x = this.actualWidth - this._yearList.width - 20;
			
		}
		
		private function yearChangeHandler(e:starling.events.Event):void
		{
			this._firstDayOfMonth.fullYear = this._yearList.selectedItem.data;
			populateDayCellsWithData();
		}
		
		private function daySelectedHandler(e:starling.events.Event):void
		{
			var cell:Button = Button(e.currentTarget);
//			trace("Date Selected is " + fillWithZero(cell.label) + fillWithZero(String(this._firstDayOfMonth.month + 1)) + this._firstDayOfMonth.fullYear);
			var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.CALENDAR_BUTTON_TRIGGERED);
			evt.evtData.date = fillWithZero(cell.label) + fillWithZero(String(this._firstDayOfMonth.month + 1)) + String(this._firstDayOfMonth.fullYear);
			dispatchEvent(evt);
		}
		
		private function fillWithZero(value:String):String
		{
			
			if(value.length > 1)
			{
				return value;
			} else
			{
				return "0" + value;
			}
			
		}
		
		private function clearDownDayCells():void
		{
			if(this._allDayCells.length > 0)
			{
				for(var i:uint = 0 ; i < 42 ; i++)
				{
					this._allDayCells[i].label = "";
					this._allDayCells[i].alpha = 1;
					this._allDayCells[i].isEnabled = false;
					this._allDayCells[i].removeEventListener(starling.events.Event.TRIGGERED , daySelectedHandler);
				}
			}
			
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}
	}
}
