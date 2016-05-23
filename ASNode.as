package
{	
	public class ASNode
	{
		// Value relative to neighbor nodes, cost to travel to this node from node N
		// or a static value that can be used to calculate the cost, like position
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		
		// Simple modifier to allow for different types of terrain
		public var weight:Number = 1.0;

		// Can be used to tie this node to a game object
		public var userData:*;
		
		
		public var G:Number = 0.0;
		public var H:Number = 0.0;
		public var F:Number = 0.0;
		
		// Used by the search when an object is put in the open list
		public var next:ASNode = null;
		public var prev:ASNode = null;
		public var bIsOpen:Boolean = false;
		public var bIsClosed:Boolean = false;
		
		public var neighbors:Vector.<ASNode>;
		
		// If a path is found cameFrom is used to travel back through the chain to find all the steps in the final path
		public var cameFrom:ASNode = null;
		
		
		public function ASNode(_x:Number = 0.0, _y:Number = 0.0)
		{
			x = _x;
			y = _y;
			neighbors = new Vector.<ASNode>();
		}
		
		public function addNeighbor(node:ASNode):void
		{
			if (neighbors.indexOf(node) < 0 && node != this)
			{
				neighbors.push(node);
			}
		}
	}
}