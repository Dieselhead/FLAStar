package 
{	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class Node extends MovieClip
	{
		public var asn:ASNode = null;
		
		public var bConnected:Boolean = true;
		
		public var indexX:uint = 0;
		public var indexY:uint = 0;
		
		public var bOpen:Boolean = false;
		
		
		public function Node()
		{
			
		}
		
		public function showNeighbors():void
		{
			if (asn)
			{
				asn.userData.gotoAndStop(2);
				for (var i:uint = 0; i < asn.neighbors.length; i++)
				{
					asn.neighbors[i].userData.gotoAndStop(3);
				}
			}
		}
		
		public function hideNeighbors():void
		{
			if (asn)
			{
				asn.userData.gotoAndStop(1);
				for (var i:uint = 0; i < asn.neighbors.length; i++)
				{
					asn.neighbors[i].userData.gotoAndStop(1);
				}
			}
		}
	}
}