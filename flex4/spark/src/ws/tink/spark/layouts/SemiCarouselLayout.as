package ws.tink.spark.layouts
{
	
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	import mx.core.IVisualElement;
	
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	
	import ws.tink.spark.layouts.supportClasses.PerspectiveAnimationNavigatorLayoutBase;

	/**
	 *  Flex 4 SemiCarouselLayout
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class SemiCarouselLayout extends PerspectiveAnimationNavigatorLayoutBase
	{
			
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function SemiCarouselLayout()
		{
			super( INDIRECT );
			_transformCalculator = new TransformValues( this );
		}

		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _transformCalculator				: TransformValues;
		
		/**
		 *  @private
		 */
//		private var _indicesInViewChanged				: Boolean;
		
		/**
		 *  @private
		 */
		private var _horizontalCenterMultiplier			: Number;
		
		/**
		 *  @private
		 */
		private var _verticalCenterMultiplier			: Number;
		
		/**
		 *  @private
		 */
		private var _elementHorizontalCenterMultiplier	: Number;
		
		/**
		 *  @private
		 */
		private var _elementVerticalCenterMultiplier	: Number;
		
		/**
		 *  @private
		 */
		private var _displayedElements					: Vector.<IVisualElement>	
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  depthColor
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for depthColor.
		 */
		private var _depthColor		: int = -1;
		
		[Inspectable(category="General", defaultValue="-1")]
		/**
		 *	The color tint to apply to elements as their are moved back on the z axis.
		 * 
		 *	<p>If a valid color is added to elements are tinted as they are moved
		 *	back on the z axis taking into account the <code>depthColorAlpha</code>
		 *	specified. If a value of -1 is set for the color no tinting is applied.</p>
		 * 
		 *  @default -1
		 * 
		 * 	@see #depthColorAlpha
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get depthColor():int
		{
			return _depthColor;
		}
		/**
		 *  @private
		 */
		public function set depthColor( value:int ) : void
		{
			if( _depthColor == value ) return;
			
			_depthColor = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  depthColorAlpha
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for depthColorAlpha.
		 */
		private var _depthColorAlpha		: Number = 1;
		
		[Inspectable(category="General", defaultValue="1")]
		
		/**
		 *	The alpha to be used for the color tint that is applied to elements
		 *	as their are moved back on the z axis.
		 * 
		 *  @default 1
		 * 
		 * 	@see #depthColor
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get depthColorAlpha():Number
		{
			return _depthColorAlpha;
		}
		/**
		 *  @private
		 */
		public function set depthColorAlpha( value:Number ) : void
		{
			if( _depthColorAlpha == value ) return;
			
			_depthColorAlpha = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  numUnselectedElements
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for numUnselectedElements.
		 */
		private var _numUnselectedElements	: int = 2;
		
		[Inspectable(category="General", defaultValue="2")]
		/**
		 *	The number of items to show either side of the selected item
		 *	are positioned around this element.
		 * 
		 *	<p>Valid values are <code>HorizontalAlign.LEFT</code>, <code>HorizontalAlign.CENTER</code>
		 *	and <code>HorizontalAlign.RIGHT</code>.</p>
		 * 
		 *  @default 2
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		
		public function get numUnselectedElements():int
		{
			return _numUnselectedElements;
		}
		/**
		 *  @private
		 */
		public function set numUnselectedElements( value:int ) : void
		{
			if( _numUnselectedElements == value ) return;
			
			_numUnselectedElements = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalAlign
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for horizontalAlign.
		 */
		private var _horizontalAlign:String = HorizontalAlign.CENTER;
		
		/**
		 *  @private
		 *  Flag to indicate the horizontalAlign property has changed.
		 */
		private var _horizontalAlignChange:Boolean = true;
		
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		/**
		 *	The horizontal position of the selected element in the viewport. All other elements
		 *	are positioned around this element.
		 * 
		 *	<p>Valid values are <code>HorizontalAlign.LEFT</code>, <code>HorizontalAlign.CENTER</code>
		 *	and <code>HorizontalAlign.RIGHT</code>.</p>
		 * 
		 *  @default "center"
		 * 
		 * 	@see #horizontalAlignOffset
		 * 	@see #horizontalAlignOffsetPercent
		 * 	@see spark.layouts.HorizontalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if( value == _horizontalAlign ) return;
			
			_horizontalAlign = value;
			_horizontalAlignChange = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  verticalAlign
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for verticalAlign.
		 */
		private var _verticalAlign:String = VerticalAlign.MIDDLE;
		
		/**
		 *  @private
		 *  Flag to indicate the verticalAlign property has changed.
		 */
		private var _verticalAlignChange:Boolean = true;
		
		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
		/**
		 *	The vertical position of the selected element in the viewport. All other elements
		 *	are positioned around this element.
		 * 
		 *	<p>Valid values are <code>VerticalAlign.TOP</code>, <code>VerticalAlign.MIDDLE</code>
		 *	and <code>VerticalAlign.BOTTOM</code>.</p>
		 * 
		 *  @default "middle"
		 * 
		 * 	@see #verticalAlignOffset
		 * 	@see #verticalAlignOffsetPercent
		 * 	@see spark.layouts.VerticalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		/**
		 *  @private
		 */
		public function set verticalAlign(value:String):void
		{
			if( value == _verticalAlign ) return;
			
			_verticalAlign = value;
			_verticalAlignChange = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalAlignOffset
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for horizontalAlignOffset.
		 */
		private var _horizontalAlignOffset:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *	The offset in pixels to be used in conjunction with <code>horizontalAlign</code>
		 *	to set the horizontal position of the selected element in the viewport. All other elements
		 *	are positioned around this element.
		 * 
		 *	<p>If <code>horizontalAlignOffsetPercent</code> is set after this property,
		 *	this property is set automatically depending on the value of <code>horizontalAlignOffsetPercent</code>.</p>
		 * 
		 *  @default 0
		 * 
		 * 	@see #horizontalAlign
		 * 	@see #horizontalAlignOffsetPercent
		 * 	@see spark.layouts.HorizontalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalAlignOffset():Number
		{
			return _horizontalAlignOffset;
		}
		/**
		 *  @private
		 */
		public function set horizontalAlignOffset(value:Number):void
		{
			if( _horizontalAlignOffset == value ) return;
			
			_horizontalAlignOffset = value;
			_horizontalAlignOffsetPercent = NaN;
//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}    
		
		
		//----------------------------------
		//  verticalAlignOffset
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for verticalAlignOffset.
		 */
		private var _verticalAlignOffset:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *	The offset in pixels to be used in conjunction with <code>verticalAlign</code>
		 *	to set the vertical position of the selected element in the viewport. All other elements
		 *	are positioned around this element.
		 * 
		 *	<p>If <code>verticalAlignOffsetPercent</code> is set after this property,
		 *	this property is set automatically depending on the value of <code>verticalAlignOffsetPercent</code>.</p>
		 * 
		 *  @default 0
		 * 
		 * 	@see #verticalAlign
		 * 	@see #verticalAlignOffsetPercent
		 * 	@see spark.layouts.VerticalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalAlignOffset():Number
		{
			return _verticalAlignOffset;
		}
		/**
		 *  @private
		 */
		public function set verticalAlignOffset(value:Number):void
		{
			if( _verticalAlignOffset == value ) return;
			
			_verticalAlignOffset = value;
			_verticalAlignOffsetPercent = NaN;
//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalAlignOffsetPercent
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for horizontalAlignOffsetPercent.
		 */
		private var _horizontalAlignOffsetPercent:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *	The offset as a percentage of the unscaled width of the viewport
		 *  to be used in conjunction with <code>horizontalAlign</code> to set the horizontal
		 *	position of the selected element in the viewport. All other elements are
		 * 	positioned around this element.
		 * 
		 *	<p>Setting this property overrides any value set on <code>horizontalAlignOffset</code>.</p>
		 * 
		 *  @default 0
		 * 
		 * 	@see #horizontalAlign
		 * 	@see #horizontalAlignOffset
		 * 	@see spark.layouts.HorizontalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalAlignOffsetPercent():Number
		{
			return _horizontalAlignOffsetPercent;
		}
		/**
		 *  @private
		 */
		public function set horizontalAlignOffsetPercent(value:Number):void
		{
			if( _horizontalAlignOffsetPercent == value ) return;
			
			_horizontalAlignOffsetPercent = value;
			if( !isNaN( _horizontalAlignOffsetPercent ) ) _horizontalAlignOffset = unscaledHeight * ( _horizontalAlignOffsetPercent / 100 );
//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}    
		
		
		//----------------------------------
		//  verticalAlignOffsetPercent
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for verticalAlignOffsetPercent.
		 */
		private var _verticalAlignOffsetPercent:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *	The offset as a percentage of the unscaled height of the viewport
		 *  to be used in conjunction with <code>verticalAlign</code> to set the vertical
		 *	position of the selected element in the viewport. All other elements are
		 * 	positioned around this element.
		 * 
		 *	<p>Setting this property overrides any value set on <code>verticalAlignOffset</code>.</p>
		 * 
		 *  @default 0
		 * 
		 * 	@see #verticalAlign
		 * 	@see #verticalAlignOffset
		 * 	@see spark.layouts.VerticalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalAlignOffsetPercent():Number
		{
			return _verticalAlignOffsetPercent;
		}
		/**
		 *  @private
		 */
		public function set verticalAlignOffsetPercent(value:Number):void
		{
			if( _verticalAlignOffsetPercent == value ) return;
			
			_verticalAlignOffsetPercent = value;
			if( !isNaN( _verticalAlignOffsetPercent ) ) _verticalAlignOffset = unscaledHeight * ( _verticalAlignOffsetPercent / 100 );
//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  elementHorizontalAlign
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for elementHorizontalAlign.
		 */
		private var _elementHorizontalAlign:String = HorizontalAlign.CENTER;
		
		/**
		 *  @private
		 *  Flag to indicate the elementHorizontalAlign property has changed.
		 */
		private var _elementHorizontalAlignChange		: Boolean = true;
		
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		/**
		 *	The horizontal transform point of elements.
		 * 
		 *	<p>Valid values are <code>HorizontalAlign.LEFT</code>, <code>HorizontalAlign.CENTER</code>
		 *	and <code>HorizontalAlign.RIGHT</code>.</p>
		 * 
		 *  @default "center"
		 * 
		 * 	@see spark.layouts.HorizontalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get elementHorizontalAlign():String
		{
			return _elementHorizontalAlign;
		}
		/**
		 *  @private
		 */
		public function set elementHorizontalAlign(value:String):void
		{
			if( value == _elementHorizontalAlign ) return;
			
			_elementHorizontalAlign = value;
			_elementHorizontalAlignChange = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  elementVerticalAlign
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for elementVerticalAlign.
		 */
		private var _elementVerticalAlign:String = VerticalAlign.MIDDLE;
		
		/**
		 *  @private
		 *  Flag to indicate the elementVerticalAlign property has changed.
		 */
		private var _elementVerticalAlignChange			: Boolean = true;
		
		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
		/**
		 *	The vertical transform point of elements.
		 * 
		 *	<p>Valid values are <code>VerticalAlign.TOP</code>, <code>VerticalAlign.MIDDLE</code>
		 *	and <code>VerticalAlign.BOTTOM</code>.</p>
		 * 
		 *  @default "middle"
		 * 
		 * 	@see spark.layouts.VerticalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get elementVerticalAlign():String
		{
			return _elementVerticalAlign;
		}
		/**
		 *  @private
		 */
		public function set elementVerticalAlign(value:String):void
		{
			if( value == _elementVerticalAlign ) return;
			
			_elementVerticalAlign = value;
			_elementVerticalAlignChange = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  radiusX
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for radiusX.
		 */
		private var _radiusX	: Number = 100;
		
		[Inspectable(category="General", type="Number", defaultValue="100")]
		/**
		 *	The radius to be used on the x axis for the SemiCarouselLayout.
		 * 
		 *  @default 100
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get radiusX():Number
		{
			return _radiusX;
		}
		/**
		 *  @private
		 */
		public function set radiusX( value:Number ):void
		{
			if( value == _radiusX ) return;
			
			_radiusX = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  radiusY
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for radiusY.
		 */
		private var _radiusY	: Number = 0;
		
		[Inspectable(category="General", type="Number", defaultValue="0")]
		/**
		 *	The radius to be used on the y axis for the SemiCarouselLayout.
		 * 
		 *  @default 0
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get radiusY():Number
		{
			return _radiusY;
		}
		/**
		 *  @private
		 */
		public function set radiusY( value:Number ):void
		{
			if( value == _radiusY ) return;
			
			_radiusY = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  radiusZ
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for radiusZ.
		 */
		private var _radiusZ	: Number;
		
		[Inspectable(category="General", type="Number", defaultValue="NaN")]
		/**
		 *	The radius to be used on the z axis for the SemiCarouselLayout.
		 * 
		 * 	<p>If a value of NaN is passed the largest of <code>radiusX</code>
		 *	or <code>radiusY</code> is used.</p>
		 * 
		 *  @default NaN
		 * 
		 * 	@see #radiusX
		 *	@see #radiusY
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get radiusZ():Number
		{
			return _radiusZ;
		}
		/**
		 *  @private
		 */
		public function set radiusZ( value:Number ):void
		{
			if( value == _radiusZ ) return;
			
			_radiusZ = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  layoutType
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for layoutType.
		 */
		private var _layoutType	: String = "circular";
		
		[Inspectable(category="General", enumeration="circular,linear", defaultValue="circular")]
		/**
		 *	The layout type to be used for the SemiCarouselLayout.
		 * 
		 *  @default "circular"
		 * 
		 * 	@see ws.tink.layouts.supportClasses.SemiCarouselLayoutType
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get layoutType():String
		{
			return _layoutType;
		}
		/**
		 *  @private
		 */
		public function set layoutType( value:String ):void
		{
			if( value == _layoutType ) return;
			
			_layoutType = value;
			invalidateTargetDisplayList();
		}
		
		
//		//----------------------------------
//		//  direction
//		//----------------------------------  
//		
//		/**
//		 *  @private
//		 *  Storage property for layoutType.
//		 */
//		private var _direction	: String = "convex";
//		
//		[Inspectable(category="General", enumeration="convex,concave", defaultValue="convex")]
//		/**
//		 *	The layout type to be used for the SemiCarouselLayout.
//		 * 
//		 *  @default "convex"
//		 * 
//		 * 	@see ws.tink.layouts.supportClasses.SemiCarouselDirection
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get direction():String
//		{
//			return _direction;
//		}
//		/**
//		 *  @private
//		 */
//		public function set direction( value:String ):void
//		{
//			if( value == _direction ) return;
//			
//			_direction = value;
//			invalidateTargetDisplayList();
//		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	@private
		 * 
		 *	Positions, transforms and sets the size of an element
		 *  that will be visible in the layout.
		 */
		protected function updateVisibleElementAt( element:IVisualElement, index:int, afterSelected:Boolean ):void
		{
			_displayedElements.push( element );
			_transformCalculator.updateForIndex( index );
			setElementLayoutBoundsSize( element, false );
			elementTransformAround( element, afterSelected );
			applyColorTransformToElement( element, _transformCalculator.colorTransform );
			element.visible = true;
		}
		
		
		/**
		 *	@private
		 * 
		 *	Sets the depth of elements inlcuded in the layout at depths
		 *	to display correctly for the z position set with transformAround.
		 * 
		 *	Also sets the depth of elements that are not included in the layout.
		 *	The depth of these is dependent on whether their element index is before
		 *	or after the index of the selected element.
		 * 
		 *	- If their element index is before the selected elements index
		 *   they appear beneath all items included in the layout.
		 * 
		 *	- If their element index is after the selected elements index
		 *   they appear above all items included in the layout
		 */
		private function updateDepths( depths:Vector.<int> ):void
		{
			if( !depths || !depths.length ) return;
			
			var animationIndex:int = Math.max( 0, Math.min( Math.round( animationValue ), numElementsInLayout - 1 ) );
			
			var element:IVisualElement;
			var index:int;
			var i:int
			var numBeforeMinDepth:int = 0;
			var minDepth:int = depths[ 0 ] - 1;
			var maxDepth:int = depths[ depths.length - 1 ] + 1;
			
			for( i = firstIndexInView; i <= lastIndexInView; i++ )
			{
				index = indicesInLayout[ i ];
				element = target.getElementAt( index );
				if( !element ) continue;
				if( index <  indicesInLayout[ animationIndex ] )
				{
					element.depth = _transformCalculator.radiusZ > -1 ? depths.shift() : depths.pop();
				}
//				else if ( index > indicesInLayout[ animationIndex ] )
//				{
//					element.depth = _direction == SemiCarouselLayoutDirection.CONVEX ? depths.pop() : depths.shift();
//				}
				else
				{
					element.depth = _transformCalculator.radiusZ > -1 ? depths.pop() : depths.shift();
				}
			}
			
			//TODO Old method
			//			for( i = 0; i < numElementsNotInLayout; i++ )
			//			{
			//				element = target.getElementAt( indicesNotInLayout[ i ] );
			//				element.depth = indicesNotInLayout[ i ];
			//			}
			
			var numElementsNotInLayout:int = indicesNotInLayout.length;
			for( i = 0; i < numElementsNotInLayout; i++ )
			{
				if( indicesNotInLayout[ i ] > indicesInLayout[ animationIndex ] )
				{
					break;
				}
				else
				{
					numBeforeMinDepth++;
				}
			}
			
			minDepth -= numBeforeMinDepth - 1;
			for( i = 0; i < numElementsNotInLayout; i++ )
			{
				element = target.getElementAt( indicesNotInLayout[ i ] );
				if( !element ) continue;
				if( indicesNotInLayout[ i ] > indicesInLayout[ animationIndex ] )
				{
					element.depth = maxDepth;
					maxDepth++;
				}
				else
				{
					element.depth = minDepth;
					minDepth++;
				}
			}
			
			target.validateNow();
		}
		
		/**
		 *	@private
		 * 
		 *	A convenience method used to transform an element by applying
		 *  the current values if the TransforCalulator instance.
		 */
		private function elementTransformAround( element:IVisualElement, afterSelected:Boolean ):void
		{
			var halfWidth:Number = element.width / 2;
			var halfHeight:Number = element.height / 2;
			var offsetX:Number = halfWidth * ( _elementHorizontalCenterMultiplier - 0.5 ) * 2;
			var offsetY:Number = halfHeight * ( _elementVerticalCenterMultiplier - 0.5 ) * 2;
			
//			_horizontalCenterMultiplier
//			
//			var x:Number = ( _transformCalculator.x - unscaledWidth * _ / _transformCalculator.radiusZ ) * 90;
//			if( _transformCalculator.radiusZ < 0 ) x = -x;
//			
//			var y:Number = ( _transformCalculator.z / _transformCalculator.radiusZ ) * 90;
//			if( _transformCalculator.radiusZ < 0 ) y = -y;
//			
//			trace( y, radiusY, _transformCalculator.y );
			element.transformAround( new Vector3D( element.width / 2, element.height / 2, 0 ),
				null,
				null,
				new Vector3D( _transformCalculator.x - offsetX, _transformCalculator.y - offsetY, _transformCalculator.z ),
				null,
				null,
//				new Vector3D( y, afterSelected ? -x : x, 0 ),
				new Vector3D( _transformCalculator.x - offsetX, _transformCalculator.y - offsetY, _transformCalculator.z ),
				false );
			
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number):void
		{
//			if( this.unscaledWidth != unscaledWidth || this.unscaledHeight != unscaledHeight ) _sizeChanged = true;
			
			if( _horizontalAlignChange )
			{
				_horizontalAlignChange = false;
//				_indicesInViewChanged = true;
				
				switch( _horizontalAlign )
				{
					case HorizontalAlign.LEFT :
					{
						_horizontalCenterMultiplier = 0;
						break;
					}
					case HorizontalAlign.RIGHT :
					{
						_horizontalCenterMultiplier = 1;
						break;
					}
					default :
					{
						_horizontalCenterMultiplier = 0.5;
					}
				}
			}
			
			if( _verticalAlignChange )
			{
				_verticalAlignChange = false;
//				_indicesInViewChanged = true;
				
				switch( _verticalAlign )
				{
					case VerticalAlign.TOP :
					{
						_verticalCenterMultiplier = 0;
						break;
					}
					case VerticalAlign.BOTTOM :
					{
						_verticalCenterMultiplier = 1;
						break;
					}
					default :
					{
						_verticalCenterMultiplier = 0.5;
					}
				}
			}
			
			if( _elementHorizontalAlignChange )
			{
				_elementHorizontalAlignChange = false;
//				_indicesInViewChanged = true;
				
				switch( _elementHorizontalAlign )
				{
					case HorizontalAlign.LEFT :
					{
						_elementHorizontalCenterMultiplier = 0;
						break;
					}
					case HorizontalAlign.RIGHT :
					{
						_elementHorizontalCenterMultiplier = 1;
						break;
					}
					default :
					{
						_elementHorizontalCenterMultiplier = 0.5;
					}
				}
			}
			
			if( _elementVerticalAlignChange )
			{
				_elementVerticalAlignChange = false;
//				_indicesInViewChanged = true;
				
				switch( _elementVerticalAlign )
				{
					case VerticalAlign.TOP :
					{
						_elementVerticalCenterMultiplier = 0;
						break;
					}
					case VerticalAlign.BOTTOM :
					{
						_elementVerticalCenterMultiplier = 1;
						break;
					}
					default :
					{
						_elementVerticalCenterMultiplier = 0.5;
					}
				}
			}
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListBetween():void
		{
			super.updateDisplayListBetween();
			
			if( sizeChangedInLayoutPass )
			{
//				_indicesInViewChanged = true;
				if( !isNaN( _horizontalAlignOffsetPercent ) ) _horizontalAlignOffset = unscaledHeight * ( _horizontalAlignOffsetPercent / 100 );
				if( !isNaN( _verticalAlignOffsetPercent ) ) _verticalAlignOffset = unscaledHeight * ( _verticalAlignOffsetPercent / 100 );
			}
			
			_transformCalculator.updateForLayoutPass( _horizontalCenterMultiplier, _verticalCenterMultiplier );
			
			//TODO Done in animation class
//			if( _indicesInViewChanged )
//			{
//				_indicesInViewChanged = false;
//				//				selectedIndexChange();
//				updateIndicesInView();
//			}
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();
			
			
			var element:IVisualElement;
			var depths:Vector.<int> = new Vector.<int>();
			
			for each( element in _displayedElements )
			{
				element.visible = false;
			}
			
			_displayedElements = new Vector.<IVisualElement>();
			
			var animationIndex:int = Math.round( animationValue );
			
			for( var i:int = firstIndexInView; i <= lastIndexInView; i++ )
			{
				element = target.getVirtualElementAt( indicesInLayout[ i ] );
				depths.push( indicesInLayout[ i ] );
				updateVisibleElementAt( element, i, i > animationIndex );
			}
			
			updateDepths( depths );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListReal():void
		{
			super.updateDisplayListReal();
			
			var element:IVisualElement;
			var depths:Vector.<int> = new Vector.<int>();
			
			_displayedElements = new Vector.<IVisualElement>();
			
			var animationIndex:int = Math.round( animationValue );
			
			for( var i:int = 0; i < numElementsInLayout; i++ )
			{
				element = target.getElementAt( indicesInLayout[ i ] );
				if( i >= firstIndexInView && i <= lastIndexInView )
				{
					depths.push( indicesInLayout[ i ] );
					updateVisibleElementAt( element, i, i > animationIndex );
				}
				else
				{
					element.visible = false;
				}
			}
			
			updateDepths( depths );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function restoreElement( element:IVisualElement ):void
		{
			super.restoreElement( element );
			
			var vector:Vector3D = new Vector3D( 0, 0, 0 );
			element.visible = true;
			element.depth = 0;
			element.transformAround( vector, null, null, vector, null, null, vector, false );
			applyColorTransformToElement( element, new ColorTransform() );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateIndicesInView():void
		{
			super.updateIndicesInView();
			
			const animationIndex:int = Math.round( animationValue );
			const firstIndexInView:int = Math.max( animationIndex - _numUnselectedElements, 0 );
			
			
			var numIndicesInView:int = ( _numUnselectedElements * 2 ) + 1; 
			if( animationIndex < _numUnselectedElements )
			{
				numIndicesInView -= _numUnselectedElements - animationIndex;
			}
			if( animationIndex + _numUnselectedElements >= numElementsInLayout )
			{
				numIndicesInView -= _numUnselectedElements - ( ( numElementsInLayout - 1 ) - animationIndex );
			}
			
//			const numIndicesInView:int = Math.min( numElementsInLayout, animationIndex + _numUnselectedElements );// - firstIndexInView;
			
			indicesInView( firstIndexInView, numIndicesInView );
		}
		
		
	}
}



import flash.geom.ColorTransform;

import mx.core.IVisualElement;

import ws.tink.spark.layouts.SemiCarouselLayout;
import ws.tink.spark.layouts.supportClasses.SemiCarouselLayoutType;


internal class TransformValues
{
	
	
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function TransformValues( layout:SemiCarouselLayout )
	{
		_layout = layout;
		_colorTransform = new ColorTransform();
	}
	
	
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var _layout			: SemiCarouselLayout;
	
	private var _index			: int;
	private var _indexOffset	: Number;
	
	// Center
	private var _cx				: Number;
	private var _cy				: Number;
	
	
	// Rotation
	private var _ho				: Number;
	private var _vo				: Number;
	
	private var _layoutFunction				: Function;
	
	private var _rx				: Number;
	private var _ry				: Number;
	private var _rz				: Number;
	
	// Number of items
	private var _ni				: Number;
	private var _an				: Number;
	
	private var _c				: int;
	private var _ca				: Number;
	
	
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  x
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for x.
	 */
	private var _x:Number;
	
	/**
	 *	x
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get x():Number
	{
		return _x;
	}
	
	
	//----------------------------------
	//  y
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for y.
	 */
	private var _y:Number;
	
	/**
	 *	y
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get y():Number
	{
		return _y;
	}
	
	
	//----------------------------------
	//  z
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for z.
	 */
	private var _z:Number;
	
	/**
	 *	z
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get z():Number
	{
		return _z;
	}
	
	
	public function get radiusZ():Number
	{
		return _rz;
	}
	
	
	//----------------------------------
	//  colorTransform
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for colorTransform.
	 */
	private var _colorTransform:ColorTransform;
	
	/**
	 *	colorTransform
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get colorTransform():ColorTransform
	{
		return _colorTransform;
	}
	
	
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	updateForLayoutPass
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function updateForLayoutPass( centerMultiplierX:Number, centerMultiplierY:Number ):void
	{
//		_index = _layout.selectedIndex;
//		_indexOffset = 0;//TODO _layout.selectedIndexOffset;
		
		_index = Math.floor( _layout.animationValue );
		_indexOffset = _layout.animationValue - _index;
		
		
		_cx = _layout.unscaledWidth * centerMultiplierX;
		_cy = _layout.unscaledHeight * centerMultiplierY;
		
		_ho = _layout.horizontalAlignOffset;
		_vo = _layout.verticalAlignOffset;
		
		_c = _layout.depthColor;
		_ca = _layout.depthColorAlpha;
		
		if( _c < 0 )
		{
			_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1;
			_colorTransform.redOffset = _colorTransform.greenOffset = _colorTransform.blueOffset = _colorTransform.alphaOffset = 0;
		}
		
		_rx = _layout.radiusX;
		_ry = _layout.radiusY;
		_rz = _layout.radiusZ;
		
		if( isNaN( _rz ) ) _rz = Math.abs( ( Math.abs( _rx ) > Math.abs( _ry ) ) ? _rx : _ry );
		
		_ni = _layout.numUnselectedElements;
		
		switch( _layout.layoutType )
		{
			case SemiCarouselLayoutType.CIRCULAR :
			{
				_an = 90 / _layout.numUnselectedElements;
				_layoutFunction = circular;
				break;
			}
			case SemiCarouselLayoutType.LINEAR :
			{
				_layoutFunction = linear;
				break;
			}
		}
	}
	
	/**
	 *	circular
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	private function circular( i:int ):void
	{
		const index:Number = ( i - _index ) - _indexOffset;
		const degree:Number = _an * index;
		const radian:Number = ( degree / 180 ) * Math.PI;

		_x = _cx + Math.sin( radian ) * _rx;
		_y = _cy + Math.sin( radian ) * _ry;
		_z = _rz - ( Math.cos( radian ) * _rz );
		
		_x += _ho;
		_y += _vo;
	}
	
	/**
	 *	linear
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	private function linear( i:int ):void
	{
		const index:Number = ( i - _index ) - _indexOffset;
		const indexx:Number = ( Math.abs( index ) > _ni ) ? ( i - _index ) + _indexOffset : index;
		
		_x = _cx + ( ( _rx / _ni ) * indexx );
		_y = _cy + ( ( _ry / _ni ) * indexx );
		_z = ( _rz / _ni ) * Math.abs( index );
		
		_x += _ho;
		_y += _vo;
	}
	
	/**
	 *	updateForIndex
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function updateForIndex( i:int ):void
	{
		_layoutFunction( i );
		
		if( _c > -1 )
		{
			// TODO There has got to be a more efficient and understandable
			// way to write this.
			const v:Number = _rz < 0 ? Math.abs( 1 - ( 1 - ( ( _z / Math.abs( _rz ) ) * _ca ) ) ) : ( _z / _rz ) * _ca;//( _z / _rz ) * _ca;
			
			_colorTransform.color = _c;
			_colorTransform.redOffset *= v;
			_colorTransform.greenOffset *= v;
			_colorTransform.blueOffset *= v;
			_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1 - v;
		}
	}
}