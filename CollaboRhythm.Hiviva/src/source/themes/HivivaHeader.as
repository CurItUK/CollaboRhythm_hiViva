package source.themes
{
	import feathers.controls.Header;
	import feathers.controls.supportClasses.TextFieldViewPort;
	import feathers.core.IFeathersControl;

	import flash.geom.Point;

	import starling.display.DisplayObject;

	public class HivivaHeader extends Header
	{
		private static const HELPER_POINT:Point = new Point();
		private var _label:TextFieldViewPort = new TextFieldViewPort();

		public function HivivaHeader()
		{
			super();
		}

		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const leftContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LEFT_CONTENT);
			const rightContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_RIGHT_CONTENT);
			const textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(textRendererInvalid)
			{
				this.createTitle();
			}

			if(textRendererInvalid || dataInvalid)
			{
				this._label.text = this._title;
			}

			if(stateInvalid || stylesInvalid)
			{
				this.refreshBackground();
			}

			if(textRendererInvalid || stylesInvalid)
			{
				this.refreshLayout();
				this.refreshTitleStyles();
			}

			if(leftContentInvalid)
			{
				if(this._leftItems)
				{
					for each(var item:DisplayObject in this._leftItems)
					{
						if(item is IFeathersControl)
						{
							IFeathersControl(item).nameList.add(this.itemName);
						}
						this.addChild(item);
					}
				}
			}

			if(rightContentInvalid)
			{
				if(this._rightItems)
				{
					for each(item in this._rightItems)
					{
						if(item is IFeathersControl)
						{
							IFeathersControl(item).nameList.add(this.itemName);
						}
						this.addChild(item);
					}
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid)
			{
				this.layoutBackground();
			}

			if(sizeInvalid || leftContentInvalid || rightContentInvalid || stylesInvalid)
			{
				this.leftItemsWidth = 0;
				this.rightItemsWidth = 0;
				if(this._leftItems)
				{
					this.layoutLeftItems();
				}
				if(this._rightItems)
				{
					this.layoutRightItems();
				}
			}

			if(textRendererInvalid || sizeInvalid || stylesInvalid || dataInvalid || leftContentInvalid || rightContentInvalid)
			{
				this.layoutTitle();
			}

		}
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			var newWidth:Number = needsWidth ? (this._paddingLeft + this._paddingRight) : this.explicitWidth;
			var newHeight:Number = needsHeight ? 0 : this.explicitHeight;

			var totalItemWidth:Number = 0;
			const leftItemCount:int = this._leftItems ? this._leftItems.length : 0;
			for(var i:int = 0; i < leftItemCount; i++)
			{
				var item:DisplayObject = this._leftItems[i];
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate();
				}
				if(needsWidth && !isNaN(item.width))
				{
					totalItemWidth += item.width;
					if(i > 0)
					{
						totalItemWidth += this._gap;
					}
				}
				if(needsHeight && !isNaN(item.height))
				{
					newHeight = Math.max(newHeight, item.height);
				}
			}
			const rightItemCount:int = this._rightItems ? this._rightItems.length : 0;
			for(i = 0; i < rightItemCount; i++)
			{
				item = this._rightItems[i];
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate();
				}
				if(needsWidth && !isNaN(item.width))
				{
					totalItemWidth += item.width;
					if(i > 0)
					{
						totalItemWidth += this._gap;
					}
				}
				if(needsHeight && !isNaN(item.height))
				{
					newHeight = Math.max(newHeight, item.height);
				}
			}
			newWidth += totalItemWidth;

			if(this._title)
			{
				const calculatedTitleGap:Number = isNaN(this._titleGap) ? this._gap : this._titleGap;
				newWidth += 2 * calculatedTitleGap;
				var maxTitleWidth:Number = (needsWidth ? this._maxWidth : this.explicitWidth) - totalItemWidth;
				if(leftItemCount > 0)
				{
					maxTitleWidth -= calculatedTitleGap;
				}
				if(rightItemCount > 0)
				{
					maxTitleWidth -= calculatedTitleGap;
				}
				this._label.maxWidth = maxTitleWidth;
				this._label.measureText(HELPER_POINT);
				const measuredTitleWidth:Number = HELPER_POINT.x;
				const measuredTitleHeight:Number = HELPER_POINT.y;
				if(needsWidth && !isNaN(measuredTitleWidth))
				{
					newWidth += measuredTitleWidth;
					if(leftItemCount > 0)
					{
						newWidth += calculatedTitleGap;
					}
					if(rightItemCount > 0)
					{
						newWidth += calculatedTitleGap;
					}
				}
				if(needsHeight && !isNaN(measuredTitleHeight))
				{
					newHeight = Math.max(newHeight, measuredTitleHeight);
				}
			}
			if(needsHeight)
			{
				newHeight += this._paddingTop + this._paddingBottom;
			}
			if(needsWidth && !isNaN(this.originalBackgroundWidth))
			{
				newWidth = Math.max(newWidth, this.originalBackgroundWidth);
			}
			if(needsHeight && !isNaN(this.originalBackgroundHeight))
			{
				newHeight = Math.max(newHeight, this.originalBackgroundHeight);
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		override protected function createTitle():void
		{
			if(this._label)
			{
				this.removeChild(DisplayObject(this._label), true);
				this._label = null;
			}

			this._label = new TextFieldViewPort();
			this._label.nameList.add(this.titleName);
			this._label.touchable = false;
			this.addChild(DisplayObject(this._label));
		}
		override protected function layoutTitle():void
		{
			if(this._title.length == 0)
			{
				return;
			}
			const calculatedTitleGap:Number = isNaN(this._titleGap) ? this._gap : this._titleGap;
			//left and right offsets already include padding
			const leftOffset:Number = (this._leftItems && this._leftItems.length > 0) ? (this.leftItemsWidth + calculatedTitleGap) : 0;
			const rightOffset:Number = (this._rightItems && this._rightItems.length > 0) ? (this.rightItemsWidth + calculatedTitleGap) : 0;
			if(this._titleAlign == TITLE_ALIGN_PREFER_LEFT && (!this._leftItems || this._leftItems.length == 0))
			{
				this._label.maxWidth = this.actualWidth - this._paddingLeft - rightOffset;
				this._label.validate();
				this._label.x = this._paddingLeft;
			}
			else if(this._titleAlign == TITLE_ALIGN_PREFER_RIGHT && (!this._rightItems || this._rightItems.length == 0))
			{
				this._label.maxWidth = this.actualWidth - this._paddingRight - leftOffset;
				this._label.validate();
				this._label.x = this.actualWidth - this._paddingRight - this._label.width;
			}
			else
			{
				const actualWidthMinusPadding:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
				const actualWidthMinusOffsets:Number = this.actualWidth - leftOffset - rightOffset;
				this._label.maxWidth = actualWidthMinusOffsets;
				this._label.validate();
				const idealTitlePosition:Number = this._paddingLeft + (actualWidthMinusPadding - this._label.width) / 2;
				if(leftOffset > idealTitlePosition ||
					(idealTitlePosition + this._label.width) > (this.actualWidth - rightOffset))
				{
					this._label.x = leftOffset + (actualWidthMinusOffsets - this._label.width) / 2;
				}
				else
				{
					this._label.x = idealTitlePosition;
				}
			}
			if(this._verticalAlign == VERTICAL_ALIGN_TOP)
			{
				this._label.y = this._paddingTop;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				this._label.y = this.actualHeight - this._paddingBottom - this._label.height;
			}
			else
			{
				this._label.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this._label.height) / 2;
			}
		}
	}
}
