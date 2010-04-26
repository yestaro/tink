package ws.tink.spark.skins.controls
{
	import spark.components.CheckBox;
	import spark.components.IItemRenderer;
	
	public class CheckBoxItemRenderer extends CheckBox implements IItemRenderer
	{
		
		
		
		public function CheckBoxItemRenderer()
		{
			super();
		}
		
		private var _itemIndex	: int;
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		public function set itemIndex( value:int ):void
		{
			_itemIndex = value;
		}
		
		private var _dragging	: Boolean;
		public function get dragging():Boolean
		{
			return _dragging;
		}
		public function set dragging(value:Boolean):void
		{
			_dragging = value;
		}
		
		private var _showsCaret	: Boolean;
		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}
		public function set showsCaret( value:Boolean ):void
		{
			_showsCaret = value;
		}
		
		public function get data():Object
		{
			return null;
		}
		
		public function set data(value:Object):void
		{
		}
	}
}