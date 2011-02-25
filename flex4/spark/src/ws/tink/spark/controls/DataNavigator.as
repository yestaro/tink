/*
Copyright (c) 2010 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package ws.tink.spark.controls
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.IDataRenderer;
	import mx.core.IDeferredContentOwner;
	import mx.core.IFactory;
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.utils.BitFlagUtil;
	
	import spark.components.IItemRenderer;
	import spark.components.IItemRendererOwner;
	import spark.components.supportClasses.SkinnableContainerBase;
	import spark.core.IViewport;
	import spark.events.IndexChangeEvent;
	import spark.events.RendererExistenceEvent;
	import spark.layouts.supportClasses.LayoutBase;
	
	import ws.tink.spark.controls.DataNavigator;
	import ws.tink.spark.layouts.supportClasses.EasedNavigatorLayoutBase;
	import ws.tink.spark.layouts.supportClasses.INavigatorLayout;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the ISelectableList has been updated in some way.
	 *
	 *  @eventType mx.events.CollectionEvent.COLLECTION_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="collectionChange", type="mx.events.CollectionEvent")]
	
	/**
	 *  Dispatched after the selection has changed. 
	 *  This event is dispatched when the user interacts with the control.
	 * 
	 *  <p>When you change the value of the <code>selectedIndex</code> 
	 *  or <code>selectedItem</code> properties programmatically, 
	 *  the control does not dispatch the <code>change</code> event. 
	 *  It dispatches the <code>valueCommit</code> event instead.</p>
	 *
	 *  @eventType spark.events.IndexChangeEvent.CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="change", type="spark.events.IndexChangeEvent")]
	
	/**
	 *  Dispatched when a renderer is added to the container.
	 *  The <code>event.renderer</code> property contains 
	 *  the renderer that was added.
	 *
	 *  @eventType spark.events.RendererExistenceEvent.RENDERER_ADD
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="rendererAdd", type="spark.events.RendererExistenceEvent")]
	
	/**
	 *  Dispatched when a renderer is removed from the container.
	 *  The <code>event.renderer</code> property contains 
	 *  the renderer that was removed.
	 *
	 *  @eventType spark.events.RendererExistenceEvent.RENDERER_REMOVE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="rendererRemove", type="spark.events.RendererExistenceEvent")]
	
//	include "../styles/metadata/BasicInheritingTextStyles.as"
	
	/**
	 *  The alpha of the focus ring for this component.
	 *
	 *  @default 0.55
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="focusAlpha", type="Number", inherit="no", theme="spark", minValue="0.0", maxValue="1.0")]
	
	/**
	 *  Color of focus ring when the component is in focus.
	 *
	 *  @default 0x70B2EE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */ 
	[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark")]
	
	/**
	 *  Thickness, in pixels, of the focus rectangle outline.
	 *
	 *  @default 2
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="focusThickness", type="Number", format="Length", inherit="no", minValue="0.0")]
	
	[DefaultProperty("dataProvider")]
	
	//[IconFile("SkinnableDataContainer.png")]
	
	/**
	 *  The SkinnableDataContainer class is the base container class for
	 *  data items.  The SkinnableDataContainer class converts data 
	 *  items to visual elements for display.
	 *  While this container can hold visual elements, it is often used only 
	 *  to hold data items as children.
	 *
	 *  <p>The SkinnableDataContainer class takes as children data items 
	 *  or visual elements that implement the IVisualElement interface
	 *  and are Display Objects.
	 *  Data items can be simple data items such String and Number objects, 
	 *  and more complicated data items such as Object and XMLNode objects. 
	 *  While these containers can hold visual elements, 
	 *  they are often used only to hold data items as children.</p>
	 *
	 *  <p>An item renderer defines the visual representation of the 
	 *  data item in the container. 
	 *  The item renderer converts the data item into a format that can 
	 *  be displayed by the container. 
	 *  You must pass an item renderer to a SkinnableDataContainer to 
	 *  render data items appropriately.</p>
	 *
	 *  <p>If you want a container of data items and don't need a skin, then 
	 *  it is recommended to use a DataGroup (which cannot be skinned) to 
	 *  improve performance and application size.</p>
	 *
	 *  <p>The SkinnableDataContainer container has the following default characteristics:</p>
	 *  <table class="innertable">
	 *     <tr><th>Characteristic</th><th>Description</th></tr>
	 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
	 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
	 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
	 *  </table>
	 * 
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:SkinnableDataContainer&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:SkinnableDataContainer
	 *    <strong>Properties</strong>
	 *    autoLayout="true"
	 *    dataProvider="null"
	 *    itemRenderer="null"
	 *    itemRendererFunction="null"
	 *    layout="VerticalLayout"
	 *    typicalItem="null"
	 *  
	 *    <strong>Styles</strong>
	 *    alignmentBaseline="useDominantBaseline"
	 *    baselineShift="0.0"
	 *    cffHinting="horizontal_stem"
	 *    color="0"
	 *    digitCase="default"
	 *    digitWidth="default"
	 *    direction="LTR"
	 *    dominantBaseline="auto"
	 *    focusAlpha="0.55"
	 *    focusColor=""
	 *    focusThickness="2"
	 *    fontFamily="Times New Roman"
	 *    fontLookup="device"
	 *    fontSize="12"
	 *    fontStyle="normal"
	 *    fontWeight="normal"
	 *    justificationRule="auto"
	 *    justificationStyle="auto"
	 *    kerning="auto"
	 *    ligatureLevel="common"
	 *    lineHeight="120%"
	 *    lineThrough="false"
	 *    locale="en"
	 *    renderingMode="CFF"
	 *    textAlign="start"
	 *    textAlignLast="start"
	 *    textAlpha="1"
	 *    textJustify="inter_word"
	 *    trackingLeft="0"
	 *    trackingRight="0"
	 *    typographicCase="default"
	 *  
	 *    <strong>Events</strong>
	 *    rendererAdd="<i>No default</i>"
	 *    rendererRemove="<i>No default</i>"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see SkinnableContainer
	 *  @see DataGroup
	 *  @see spark.skins.spark.SkinnableDataContainerSkin
	 *
	 *  @includeExample examples/SkinnableDataContainerExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class DataNavigator extends SkinnableContainerBase implements IItemRendererOwner, ISelectableList
	{
//			include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private static const AUTO_LAYOUT_PROPERTY_FLAG:uint = 1 << 0;
		
		/**
		 *  @private
		 */
		private static const DATA_PROVIDER_PROPERTY_FLAG:uint = 1 << 1;
		
		/**
		 *  @private
		 */
		private static const ITEM_RENDERER_PROPERTY_FLAG:uint = 1 << 2;
		
		/**
		 *  @private
		 */
		private static const ITEM_RENDERER_FUNCTION_PROPERTY_FLAG:uint = 1 << 3;
		
		/**
		 *  @private
		 */
		private static const LAYOUT_PROPERTY_FLAG:uint = 1 << 4;
		
		/**
		 *  @private
		 */
		private static const TYPICAL_ITEM_PROPERTY_FLAG:uint = 1 << 5;
		
		
		
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
		public function DataNavigator()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  An optional skin part that defines the DataGroup in the skin class 
		 *  where data items get pushed into, rendered, and laid out.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var contentGroup:DataNavigatorGroup;
		
		/**
		 *  @private
		 *  Several properties are proxied to contentGroup.  However, when contentGroup
		 *  is not around, we need to store values set on SkinnableDataContainer.  This object 
		 *  stores those values.  If contentGroup is around, the values are stored 
		 *  on the contentGroup directly.  However, we need to know what values 
		 *  have been set by the developer on the SkinnableDataContainer (versus set on 
		 *  the contentGroup or defaults of the contentGroup) as those are values 
		 *  we want to carry around if the contentGroup changes (via a new skin). 
		 *  In order to store this info effeciently, dataGroupProperties becomes 
		 *  a uint to store a series of BitFlags.  These bits represent whether a 
		 *  property has been explicitly set on this SkinnableDataContainer.  When the 
		 *  contentGroup is not around, dataGroupProperties is a typeless 
		 *  object to store these proxied properties.  When contentGroup is around,
		 *  dataGroupProperties stores booleans as to whether these properties 
		 *  have been explicitly set or not.
		 */
		private var dataGroupProperties:Object = {};
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties 
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  selectedIndex
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for selectedIndex.
		 */
		private var _selectedIndex		: int = -1;
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#selectedIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function set selectedIndex( value:int ):void
		{
			if( _selectedIndex == value ) return;
			
			_selectedIndex = value;
			
			if( layout ) INavigatorLayout( layout ).selectedIndex = _selectedIndex;
		}
		/**
		 *  @private
		 */
		public function get selectedIndex():int
		{
			return ( layout ) ? INavigatorLayout( layout ).selectedIndex : _selectedIndex;
		}
		
		
		//----------------------------------
		//  selectedItem
		//---------------------------------- 
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#selectedItem
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectedItem():Object
		{
			var index:int = selectedIndex;
			return index != -1 ? dataProvider.getItemAt( index ) : null;
		}
		/**
		 *  @private
		 */
		public function set selectedItem( value:Object ):void
		{
			if( dataProvider )
			{
				var index:int = dataProvider.getItemIndex( value );
				if( index != -1 ) selectedIndex = index;
			}
		}
		
		
		//----------------------------------
		//  length
		//---------------------------------- 
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#length
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get length():int
		{
			return dataProvider ? dataProvider.length : 0;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties proxied to contentGroup
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  autoLayout
		//----------------------------------
		
		[Inspectable(defaultValue="true")]
		
		/**
		 *  @copy spark.components.supportClasses.GroupBase#autoLayout
		 *
		 *  @default true
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get autoLayout():Boolean
		{
			if (contentGroup)
				return contentGroup.autoLayout;
			else
			{
				// want the default to be true
				var v:* = dataGroupProperties.autoLayout;
				return (v === undefined) ? true : v;
			}
		}
		
		/**
		 *  @private
		 */
		public function set autoLayout(value:Boolean):void
		{
			if (contentGroup)
			{
				contentGroup.autoLayout = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					AUTO_LAYOUT_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.autoLayout = value;
		}
		
		//----------------------------------
		//  dataProvider
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for dataProvider.
		 */
		private var _dataProvider:IList;
		
		/**
		 *  @copy spark.components.DataGroup#dataProvider
		 *
		 *  @see #itemRenderer
		 *  @see #itemRendererFunction
		 *  @see mx.collections.IList
		 *  @see mx.collections.ArrayCollection
		 *  @see mx.collections.ArrayList
		 *  @see mx.collections.XMLListCollection
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		[Bindable("dataProviderChanged")]
		[Bindable("change")]
		
		public function get dataProvider():IList
		{       
			return (contentGroup) 
			? contentGroup.dataProvider 
				: dataGroupProperties.dataProvider;
		}
		
		public function set dataProvider(value:IList):void
		{
			if( _dataProvider == value ) return;
			
			if( _dataProvider ) _dataProvider.removeEventListener( CollectionEvent.COLLECTION_CHANGE, onDataProviderCollectionChange, false );
			
			_dataProvider = value;
			
			if (contentGroup)
			{
				contentGroup.dataProvider = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					DATA_PROVIDER_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.dataProvider = value;
			
			if( _dataProvider ) _dataProvider.addEventListener( CollectionEvent.COLLECTION_CHANGE, onDataProviderCollectionChange, false, 0, true );
			
			dispatchEvent( new Event( "dataProviderChanged" ) );
			if( hasEventListener( CollectionEvent.COLLECTION_CHANGE )  ) dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET, -1, -1, toArray() ) );
		}
		
		//----------------------------------
		//  itemRenderer
		//----------------------------------
		
		/**
		 *  @copy spark.components.DataGroup#itemRenderer
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get itemRenderer():IFactory
		{
			return (contentGroup) 
			? contentGroup.itemRenderer 
				: dataGroupProperties.itemRenderer;
		}
		
		/**
		 *  @private
		 */
		public function set itemRenderer(value:IFactory):void
		{
			if( value == itemRenderer ) return;
			
			if (contentGroup)
			{
				contentGroup.itemRenderer = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					ITEM_RENDERER_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.itemRenderer = value;
		}
		
		//----------------------------------
		//  itemRendererFunction
		//----------------------------------
		
		/**
		 *  @copy spark.components.DataGroup#itemRendererFunction
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get itemRendererFunction():Function
		{
			return (contentGroup) 
			? contentGroup.itemRendererFunction 
				: dataGroupProperties.itemRendererFunction;
		}
		
		/**
		 *  @private
		 */
		public function set itemRendererFunction(value:Function):void
		{
			if (contentGroup)
			{
				contentGroup.itemRendererFunction = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					ITEM_RENDERER_FUNCTION_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.itemRendererFunction = value;
		}
		
		//----------------------------------
		//  layout
		//----------------------------------
		
		/**
		 *  @copy spark.components.supportClasses.GroupBase#layout
		 *
		 *  @default VerticalLayout
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */     
		public function get layout():LayoutBase
		{
			return (contentGroup) 
			? contentGroup.layout 
				: dataGroupProperties.layout;
		}
		/**
		 *  @private
		 */
		public function set layout(value:LayoutBase):void
		{
			var layout:LayoutBase = layout;
			
			if( layout == value ) return;
			
			removeLayoutListeners();
			
			if( value is INavigatorLayout )
			{
				if (contentGroup)
				{
					contentGroup.layout = value;
					dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
						LAYOUT_PROPERTY_FLAG, true);
				}
				else
				{
					dataGroupProperties.layout = value;
				}
				
				addLayoutListeners();
			}
			else
			{
				throw new Error( "Layout must implement INavigatorLayout" );
			}
		}
		
		//----------------------------------
		//  typicalItem
		//----------------------------------
		
		/**
		 *  @copy spark.components.DataGroup#typicalItem
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get typicalItem():Object
		{
			return (contentGroup) 
			? contentGroup.typicalItem 
				: dataGroupProperties.typicalItem;
		}
		
		/**
		 *  @private
		 */
		public function set typicalItem(value:Object):void
		{
			if (contentGroup)
			{
				contentGroup.typicalItem = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					TYPICAL_ITEM_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.typicalItem = value;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#addItem
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function addItem( item:Object ):void
		{
			addItemAt( item, length );
		}
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#addItemAt
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function addItemAt( item:Object, index:int ):void
		{
			if( !dataProvider ) dataProvider = new ArrayList();
			dataProvider.addItemAt( item, index );
		}
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#getItemAt
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function getItemAt( index:int, prefetch:int = 0 ):Object
		{
			if( length <= index ) return null;
			return  dataProvider.getItemAt( index );
		}
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#getItemIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function getItemIndex( item:Object ):int
		{
			if( !dataProvider ) return -1;
			return dataProvider.getItemIndex( item );
		}
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#itemUpdated
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function itemUpdated( item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null ):void
		{
			if( dataProvider ) dataProvider.itemUpdated( item, property, oldValue, newValue );
		}
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#removeAll
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function removeAll():void
		{
			if( !dataProvider ) return;
			dataProvider.removeAll();
		}
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#removeItemAt
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function removeItemAt( index:int ):Object
		{
			if( !dataProvider || index >= length ) return null;
			return dataProvider.removeItemAt( index );
		}
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#setItemAt
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function setItemAt(item:Object, index:int):Object
		{
			if( !dataProvider || index > length ) return null;
			return dataProvider.setItemAt( item, index );
		}
		
		/**
		 *  @copy ws.tink.spark.controls.DataNavigatorGroup#toArray
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function toArray():Array
		{
			return ( !dataProvider ) ? null : dataProvider.toArray();
		}
		
		/**
		 *  From the specified data item, return the String representation 
		 *  of the data item for an item renderer to display.
		 *  This method uses the <code>toString()</code> method of 
		 *  the data item to convert it to a String representation.
		 *  A Null data item returns an empty string.
		 *
		 *  @param item The data item.
		 *
		 *  @return The String representation of the data item.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function itemToLabel(item:Object):String
		{
			if (item !== null)
				return item.toString();
			else return " ";
		}
		
		/**
		 *  Updates an item renderer for use or reuse. 
		 *  When an item renderer is first created,
		 *  or when it is recycled because of virtualization, this 
		 *  SkinnableDataContainer instance can set the 
		 *  item renderer's <code>label</code> property and 
		 *  <code>owner</code> property. 
		 *  
		 *  @param renderer The renderer being updated 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 * 
		 */
		public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
		{
			// set the owner
			renderer.owner = this;
			
			// Set the index
			if (renderer is IItemRenderer)
				IItemRenderer(renderer).itemIndex = itemIndex;
			
			// set the label to the toString() of the data 
			if (renderer is IItemRenderer)
				IItemRenderer(renderer).label = itemToLabel(data);
			
			// always set the data last
			if ((renderer is IDataRenderer) && (renderer !== data))
				IDataRenderer(renderer).data = data;
		}
		
		/**
		 *  Adjusts the selected index to account for items being added to or 
		 *  removed from this component.
		 *
		 *  @param newIndex The new index.
		 *   
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function adjustSelection( newIndex:int ):void
		{
			var nl:INavigatorLayout = INavigatorLayout( layout );
			if( nl is EasedNavigatorLayoutBase )
			{
				var enl:EasedNavigatorLayoutBase = EasedNavigatorLayoutBase( nl );
				var stepEasing:Number = enl.stepEasing;
				enl.stepEasing = 1;
			}
			
			nl.selectedIndex = newIndex;
			
			if( enl ) enl.stepEasing = stepEasing;
		}
		
		/**
		 *  @private
		 */
		private function addLayoutListeners():void
		{
			if( !layout ) return;
			layout.addEventListener( IndexChangeEvent.CHANGE, onLayoutEvent, false, 0, true );
			layout.addEventListener( FlexEvent.VALUE_COMMIT, onLayoutEvent, false, 0, true );
		}
		
		/**
		 *  @private
		 */
		private function removeLayoutListeners():void
		{
			if( !layout ) return;
			layout.removeEventListener( IndexChangeEvent.CHANGE, onLayoutEvent, false );
			layout.removeEventListener( FlexEvent.VALUE_COMMIT, onLayoutEvent, false );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == contentGroup)
			{
				// copy proxied values from dataGroupProperties (if set) to contentGroup
				
				var newDataGroupProperties:uint = 0;
				
				if (dataGroupProperties.layout !== undefined)
				{
					contentGroup.layout = dataGroupProperties.layout;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						LAYOUT_PROPERTY_FLAG, true);;
				}
				
				if (dataGroupProperties.autoLayout !== undefined)
				{
					contentGroup.autoLayout = dataGroupProperties.autoLayout;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						AUTO_LAYOUT_PROPERTY_FLAG, true);
				}
				
				if (dataGroupProperties.dataProvider !== undefined)
				{
					contentGroup.dataProvider = dataGroupProperties.dataProvider;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						DATA_PROVIDER_PROPERTY_FLAG, true);
				}
				
				if (dataGroupProperties.itemRenderer !== undefined)
				{
					contentGroup.itemRenderer = dataGroupProperties.itemRenderer;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						ITEM_RENDERER_PROPERTY_FLAG, true);
				}
				
				if (dataGroupProperties.itemRendererFunction !== undefined)
				{
					contentGroup.itemRendererFunction = dataGroupProperties.itemRendererFunction;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						ITEM_RENDERER_FUNCTION_PROPERTY_FLAG, true);
				}
				
				if (dataGroupProperties.typicalItem !== undefined)
				{
					contentGroup.typicalItem = dataGroupProperties.typicalItem;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						TYPICAL_ITEM_PROPERTY_FLAG, true);
				}
				
				dataGroupProperties = newDataGroupProperties;
				
				// Register our instance as the contentGroup's item renderer update delegate.
				contentGroup.rendererUpdateDelegate = this;
				
				// The only reason we have these listeners is to re-dispatch events.  
				// We only add as necessary.
				
				if (hasEventListener(RendererExistenceEvent.RENDERER_ADD))
				{
					contentGroup.addEventListener(
						RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				}
				
				if (hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
				{
					contentGroup.addEventListener(
						RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				}
			}
		}
		
		/**
		 * @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == contentGroup)
			{
				contentGroup.removeEventListener(
					RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				contentGroup.removeEventListener(
					RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				
				// copy proxied values from contentGroup (if explicitly set) to dataGroupProperties
				
				var newDataGroupProperties:Object = {};
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, LAYOUT_PROPERTY_FLAG))
					newDataGroupProperties.layout = contentGroup.layout;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, AUTO_LAYOUT_PROPERTY_FLAG))
					newDataGroupProperties.autoLayout = contentGroup.autoLayout;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, DATA_PROVIDER_PROPERTY_FLAG))
					newDataGroupProperties.dataProvider = contentGroup.dataProvider;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, ITEM_RENDERER_PROPERTY_FLAG))
					newDataGroupProperties.itemRenderer = contentGroup.itemRenderer;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, ITEM_RENDERER_FUNCTION_PROPERTY_FLAG))
					newDataGroupProperties.itemRendererFunction = contentGroup.itemRendererFunction;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, TYPICAL_ITEM_PROPERTY_FLAG))
					newDataGroupProperties.typicalItem = contentGroup.typicalItem;
				
				dataGroupProperties = newDataGroupProperties;
				
				contentGroup.dataProvider = null;
				contentGroup.layout = null;
				contentGroup.rendererUpdateDelegate = null;
			}
		}
		
		/**
		 *  @private
		 * 
		 *  This method is overridden so we can figure out when someone starts listening
		 *  for property change events.  If no one's listening for them, then we don't 
		 *  listen for them on our contentGroup.
		 */
		override public function addEventListener(
			type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false) : void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			// TODO (rfrishbe): this isn't ideal as we should deal with the useCapture, 
			// priority, and useWeakReference parameters.
			
			// if it's a different type of event or the contentGroup doesn't
			// exist, don't worry about it.  When the contentGroup, 
			// gets created up, we'll check to see whether we need to add this 
			// event listener to the contentGroup.
			
			if (type == RendererExistenceEvent.RENDERER_ADD && contentGroup)
			{
				contentGroup.addEventListener(
					RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
			}
			
			if (type == RendererExistenceEvent.RENDERER_REMOVE && contentGroup)
			{
				contentGroup.addEventListener(
					RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
			}
		}
		
		/**
		 *  @private
		 * 
		 *  This method is overridden so we can figure out when someone stops listening
		 *  for property change events.  If no one's listening for them, then we don't 
		 *  listen for them on our contentGroup.
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false) : void
		{
			super.removeEventListener(type, listener, useCapture);
			
			// if no one's listening to us for this event any more, let's 
			// remove our underlying event listener from the contentGroup.
			if (type == RendererExistenceEvent.RENDERER_ADD && contentGroup)
			{
				if (!hasEventListener(RendererExistenceEvent.RENDERER_ADD))
				{
					contentGroup.removeEventListener(
						RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				}
			}
			
			if (type == RendererExistenceEvent.RENDERER_REMOVE && contentGroup)
			{
				if (!hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
				{
					contentGroup.removeEventListener(
						RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				}
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners.
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function onLayoutEvent( event:Event ):void
		{
			if( hasEventListener( event.type ) ) dispatchEvent( event );
		}
		
		/**
		 *  @private
		 */
		private function onDataProviderCollectionChange( event:CollectionEvent ):void
		{
			// If there is a contentGroup it will take care of adjusting the selection
			if( !contentGroup )
			{
				if( event is CollectionEvent )
				{
					var ce:CollectionEvent = CollectionEvent( event );
					switch( ce.kind )
					{
						case CollectionEventKind.ADD :
						{
							if( ce.location <= selectedIndex ) adjustSelection( selectedIndex + 1 );
							break;
						}
						case CollectionEventKind.REMOVE :
						{
							if( ce.location <= selectedIndex )
							{
								adjustSelection( length ? selectedIndex == 0 ? 0 : selectedIndex - 1 : -1 );
							}
							break;
						}
						case CollectionEventKind.RESET :
						{
							adjustSelection( length ? 0 : -1 );
							break;
						}
						case CollectionEventKind.MOVE :
						{
							if( ce.oldLocation == selectedIndex ) adjustSelection( ce.location );
							break;
						}
					}
				}
			}
			
			if( hasEventListener( event.type ) ) dispatchEvent( event );
		}
	}
}