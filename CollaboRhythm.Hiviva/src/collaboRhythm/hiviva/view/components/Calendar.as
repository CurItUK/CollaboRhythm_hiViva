package collaboRhythm.hiviva.view.components
{

	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.view.media.Assets;

	import source.themes.HivivaTheme;

	import starling.utils.AssetManager;
	import feathers.controls.Button;
	
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	import starling.display.Quad;
	import starling.display.Image;
	import starling.textures.Texture;

	public class Calendar extends FeathersControl
	{
		private var _allDayCells:Array = [];
		private var _firstDayOfMonth:Date;
		private var _daysPerWeek:Array = new Array(6,0,1,2,3,4,5);
		private var _weekDays:Array = new Array("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");
		private var _months:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
		private var _maxDaysMonth:uint = 30;
		private var _leapYear:Number;
		private var _cellWidth:Number = 50;
		private var _cellHeight:Number = 50;
		private var _cellSpacing:Number = 70;
		private var _monthList:PickerList;
		private var _yearList:PickerList;
		private var _arrowLeft:Button;
		private var _arrowRight:Button;
		private var _closeBtn:Button;
		private var _scale:Number;
		private var _monthSelect:Quad;
		private var _dayValue:uint;
		private var _monthValue:uint;
		private var _yearValue:uint;
		private var _cYear:uint;
		private var _cMonth:uint;
		private var _cDay:uint;
		private var stageWidth:int;
		private var stageHeight:int;
		private var monthsList:Array;
		private var arrowGap:uint;
		private var _month:Label;
		private var currentDate:Date;
		private var _calendarType:String;

		private var now:Date;



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
			stageWidth   = Constants.STAGE_WIDTH;
		    stageHeight  = Constants.STAGE_HEIGHT;

			currentDate = new Date();
			arrowGap = 130;

		}
		
		private function initCalendar():void
		{
			getCurrentDate();
			createDayHolderCells();
			createDayNameLabels();
			populateDayCellsWithData();
		//	createMonthChooser();
		//	createYearChooser();
			createNavigationBar();
		}
		
		private function getCurrentDate():void
		{
			now = new Date();
			this._firstDayOfMonth = new Date(now.fullYear, now.month, 1);
			this._cYear = now.fullYear;
			this._yearValue = now.fullYear;
			this._cMonth = now.getMonth();
			this._monthValue = now.getMonth();
			this._cDay = now.date;


		//	trace("CYEAR " + _cYear + " CMONTH " + _cMonth + " CDAY " + _cDay)
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
				cell.y = 250 + (cell.height * Math.floor(i/7));

				this._allDayCells.push(cell);

			}
		}

		private function createNavigationBar():void
		{

			_monthSelect = new Quad(stageWidth, 100, 0x4c5f76, false);
			_monthSelect.y = 100;
			this.addChild(_monthSelect);

//			var arrowTexture:Texture = Assets.getTexture('ArrowPng');

			_arrowLeft = new Button();
			_arrowLeft.name = "calendar-arrows";
//			_arrowLeft.defaultSkin = new Image(arrowTexture);
			_arrowRight = new Button();
//			_arrowRight.defaultSkin = new Image(arrowTexture);
			_arrowRight.name = "calendar-arrows";

			this.addChild(_arrowLeft);
			this.addChild(_arrowRight);

			_arrowLeft.x = 50;
			_arrowLeft.y = arrowGap;

			this._arrowRight.x = stageWidth - 50;
			this._arrowRight.y = arrowGap;
			this._arrowRight.scaleX = -1;

			this._arrowLeft.addEventListener(Event.TRIGGERED, leftArrowPressed);
			this._arrowRight.addEventListener(Event.TRIGGERED, rightArrowPressed);

			this._closeBtn = new Button();
			this._closeBtn.name = "close_button";
			this._closeBtn.x = stageWidth - this._closeBtn.width - arrowGap;
			this._closeBtn.y = this._closeBtn.height;

			this.addChild(this._closeBtn);
			this._closeBtn.addEventListener(Event.TRIGGERED, closeBtnPressed);

			createCurrentMonthNameLabel();

		}

		private function leftArrowPressed(e:Event):void
		{
			if(_monthValue == 0)
			{
				_monthValue = 12;
				_yearValue--;
				this._firstDayOfMonth.fullYear = _yearValue;
			}
			_monthValue--;

			this._firstDayOfMonth.month = _monthValue;

			populateDayCellsWithData();
			updateMonthNameLabel();
		}

		private function rightArrowPressed(e:Event):void
		{
			_monthValue++;
			if(_monthValue > _months.length-1)
			{
				_monthValue = 0;
				_yearValue++;
				this._firstDayOfMonth.fullYear = _yearValue;
			}

			this._firstDayOfMonth.month = _monthValue;

			populateDayCellsWithData();
			updateMonthNameLabel();
		}

		private function closeBtnPressed(e:Event):void
		{
			var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.CALENDAR_BUTTON_TRIGGERED);
						//evt.evtData.date = fillWithZero(cell.label) + fillWithZero(String(this._firstDayOfMonth.month + 1)) + String(this._firstDayOfMonth.fullYear);
						evt.evtData.date = "";
						dispatchEvent(evt);
		}

		private function createCurrentMonthNameLabel():void
		{
			currentDate = new Date();
			_monthValue = currentDate.getMonth();
			_yearValue = currentDate.getFullYear();

				_month = new Label();
				_month.name = "calender-select-text"; // splash-footer-text
				_month.text = _months[_monthValue] + " " + _yearValue;
				_month.width = stageWidth - 2*arrowGap;
			 	_month.x = stageWidth/2 - _month.width/2;
				_month.y = 125;
				_month.validate();

				this.addChild(_month);
		}

		private function updateMonthNameLabel():void
		{
			_month.text = _months[_monthValue] + " " + _yearValue;
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
				days.y = 200;

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

			validityCheck(0);
		}
		
		private function populatePresentDayCells():void
		{
			for (var i:uint = 1; i < this._maxDaysMonth; i++)
			{
			//	trace("this._daysPerWeek[this._firstDayOfMonth.day]+i " + (this._daysPerWeek[this._firstDayOfMonth.day]+i))
				this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].label = i+1;
				this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].isEnabled = true;
				this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].addEventListener(starling.events.Event.TRIGGERED , daySelectedHandler);

				validityCheck(i);

			}
		}

		private function validityCheck(i:Number):void
		{
			var dateAdd:Number = i + (100*this._monthValue) + (1300*this._yearValue);
			var currentAdd:Number = _cDay + (100*this._cMonth) + (1300*this._cYear);


				if(dateAdd >= currentAdd)
				{
					this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].isEnabled = false;
				}
				else
				{
					this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].isEnabled = true;
				}

/*
			if(cType == "finish")
			{
				if(dateAdd <= currentAdd)
				{
					this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].isEnabled = false;
				}
				else
				{
					this._allDayCells[this._daysPerWeek[this._firstDayOfMonth.day]+i].isEnabled = true;
				}
			}
*/
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
					{text:"December", data:11}
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
					{text:"2020", data:2020}
					
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
			//evt.evtData.date = fillWithZero(cell.label) + fillWithZero(String(this._firstDayOfMonth.month + 1)) + String(this._firstDayOfMonth.fullYear);
			evt.evtData.date = fillWithZero(String(this._firstDayOfMonth.month + 1)) + "/" + fillWithZero(cell.label) + "/" + String(this._firstDayOfMonth.fullYear);

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

		public function resetCalendar():void
		{
			populateDayCellsWithData()
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}

		public function get cType():String
		{
			return _calendarType;
		}

		public function set cType(t:String):void
		{
			_calendarType = t;
		}
	}
}
