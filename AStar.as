package 
{	
	public class AStar
	{
		private static var stStartNode:ASNode = null;
		private static var stEndNode:ASNode = null;
		
		private static var stOpenList:ASNode = null;
		private static var stCurrent:ASNode = null;
		private static var stLoop:ASNode = null;
		
		public static var stPath:Array = [];
		
		
		public static var HeuristicWeight:Number = 0.1;
		
		
		public static function Setup(_start:ASNode, _end:ASNode):void
		{
			stStartNode = _start;
			stEndNode = _end;
			
			stStartNode.G = 0;
			// startNode.H =  Math.sqrt( ((endNode.x - startNode.x) * (endNode.x - startNode.x)) * ((endNode.y - startNode.y) * (endNode.y - startNode.y)) );
			stStartNode.H = (Math.abs(stEndNode.x - stStartNode.x) + Math.abs(stEndNode.y - stStartNode.y)) * HeuristicWeight;
			stStartNode.F = stStartNode.G + stStartNode.H;
			stStartNode.bIsOpen = true;
			
			stOpenList = stStartNode;
		}
		
		public static function Step():Boolean
		{
			if (!stOpenList)
				return false;
			else
			{
				
				
				// Grab best node from open list
				// ****************************************** //
				stCurrent = stOpenList;
				stLoop = stCurrent.next;
				
				while (stLoop)
				{
					if (stCurrent.F > stLoop.F)
					{
						stCurrent = stLoop;
					}
					
					stLoop = stLoop.next;
				}
				
				stLoop = null;
				// ******************************************** //
				
				
				
				
				
				
				if (stCurrent == stEndNode)
				{
					// Build path and return
					
					stLoop = stCurrent;
					stPath = [];
					while (stLoop)
					{
						stPath.push(stLoop);
						stLoop = stLoop.cameFrom;
					}
					
					return true;
				}
				else
				{
					// The current node is not the end node
					// so we need to grab all it's neighbors
					// and add to the openList
					// and remove the current from the openList
					// and add it to the closedList
					
					var len:uint = stCurrent.neighbors.length;
					
					for (var i:uint = 0; i < len; i++)
					{
						if (!stCurrent.neighbors[i].bIsClosed)
						{
							var new_g:Number = stCurrent.G + 1;
							var bNewIsBetter:Boolean = false;
							
							if (!stCurrent.neighbors[i].bIsOpen)
							{
								// Add to open
								// *********************************************** //
								if (stOpenList.next)
								{
									stCurrent.neighbors[i].next = stOpenList.next;
									stOpenList.next.prev = stCurrent.neighbors[i];
								}
								
								stOpenList.next = stCurrent.neighbors[i];
								stCurrent.neighbors[i].prev = stOpenList;
								// *********************************************** //
							
								stCurrent.neighbors[i].H = (Math.abs(stEndNode.x - stCurrent.neighbors[i].x) + Math.abs(stEndNode.y - stCurrent.neighbors[i].y)) * HeuristicWeight;
								
								bNewIsBetter = true;
								stCurrent.neighbors[i].bIsOpen = true;
							}
							else if (new_g < stCurrent.neighbors[i].G)
							{
								bNewIsBetter = true;
							}
							
							// If this is true then the node is either new or this path is faster
							// either way we need to calculate or re-calculate G, F and the node it came from
							if (bNewIsBetter)
							{
								stCurrent.neighbors[i].G = new_g;
								stCurrent.neighbors[i].F = stCurrent.neighbors[i].G + stCurrent.neighbors[i].H
								stCurrent.neighbors[i].cameFrom = stCurrent;
							}
						}
					}
					
					// Remove the current node from the openList
					// ************************************************* //
					if (stCurrent.prev)
					{
						stCurrent.prev.next = stCurrent.next;
					}
					if (stCurrent.next)
					{
						stCurrent.next.prev = stCurrent.prev;
					}
					
					if (stCurrent == stOpenList)
					{
						stOpenList = stOpenList.next;
					
					}
					// ************************************************* //
					
					// Remove current from open list
					// Add current to closed
					stCurrent.bIsClosed = true;
					stCurrent.bIsOpen = false;
				}
			}
		
			return false;
		}
		
		
		public static function Search(startNode:ASNode, endNode:ASNode, outPath:Array):Boolean
		{
			startNode.G = 0;
			// startNode.H =  Math.sqrt( ((endNode.x - startNode.x) * (endNode.x - startNode.x)) * ((endNode.y - startNode.y) * (endNode.y - startNode.y)) ) * HeuristicWeight;
			startNode.H = (Math.abs(endNode.x - startNode.x) + Math.abs(endNode.y - startNode.y)) * HeuristicWeight;
			startNode.F = startNode.G + startNode.H;
			
			startNode.bIsOpen = true;
			
			var openList:ASNode = startNode;
			var current:ASNode = null;
			var loop:ASNode = null;
			
			
			if (startNode == endNode)
			{
				outPath.push(startNode);
				return true;
			}
			
			
			
			while (openList)
			{
				// Grab best node from open list
				// ******************************************** //
				current = openList;
				loop = current.next;
				
				while (loop)
				{
					if (current.F > loop.F)
					{
						current = loop;
					}
					
					loop = loop.next;
				}
				
				loop = null;
				// ******************************************** //
				
				if (current == endNode)
				{
					// Build path and return
					
					loop = current;
					while (loop)
					{
						outPath.push(loop);
						
						loop = loop.cameFrom;
					}
					
					return true;
				}
				else
				{
					// The current node is not the end node
					// so we need to grab all it's neighbors
					// and add to the openList
					// and remove the current from the openList
					// and add it to the closedList
					
					var len:uint = current.neighbors.length;
					
					for (var i:uint = 0; i < len; i++)
					{
						if (!current.neighbors[i].bIsClosed)
						{
							
							var new_g:Number = current.G + 1;
							
							var bNewIsBetter:Boolean = false;							
							
							// This node has not been added to the open list yet, so we add it
							if (!current.neighbors[i].bIsOpen)
							{
							
								// Add to open
								// ****************************************** //
								if (openList.next)
								{
									current.neighbors[i].next = openList.next;
									openList.next.prev = current.neighbors[i];
								}
								
								openList.next = current.neighbors[i];
								current.neighbors[i].prev = openList;
								// ***************************************** //
								
								current.neighbors[i].H = (Math.abs(endNode.x - current.neighbors[i].x) + Math.abs(endNode.y - current.neighbors[i].y)) * HeuristicWeight;
								// current.neighbors[i].H = Math.sqrt( ((endNode.x - current.neighbors[i].x) * (endNode.x - current.neighbors[i].x)) * ((endNode.y - current.neighbors[i].y) * (endNode.y - current.neighbors[i].y)) ) * HeuristicWeight;
								
								bNewIsBetter = true;
								
								current.neighbors[i].bIsOpen = true;
							}
							else if (new_g < current.neighbors[i].G)
							{
								bNewIsBetter = true;
							}
							
							// If this is true then the node is either new or this path is faster
							// either way we need to calculate or re-calculate G, F and the node it came from
							if (bNewIsBetter)
							{
								current.neighbors[i].G = new_g;
								current.neighbors[i].F = current.neighbors[i].G + current.neighbors[i].H
								current.neighbors[i].cameFrom = current;
							}
						}
					}
					
					// Remove the current node from the openList
					// ************************************************* //
					if (current.prev)
					{
						current.prev.next = current.next;
					}
					if (current.next)
					{
						current.next.prev = current.prev;
					}
					
					if (current == openList)
					{
						openList = openList.next;
					}
					// ************************************************* //
					
					// Add current to closed
					current.bIsClosed = true;
					current.bIsOpen = false;
				}
				
			}
			
			// No more nodes in the openList
			// Failed to find a path so return false
			return false;
		}
	}
}