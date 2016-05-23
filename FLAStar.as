package 
{	
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import fl.controls.RadioButton;
	import fl.events.SliderEvent;
	
	public class FLAStar extends MovieClip
	{
		public const ROWS:uint = 92;
		public const COLS:uint = 62;
		
		
		public var Nodes:Array = new Array(ROWS);
		
		public var overlay:Sprite;
		
		public var startNode:Node;
		public var endNode:Node;
		
		public var bMouseDown:Boolean = false;
		
		
		public function FLAStar()
		{
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		public function drawConnections():void
		{
			var n:Node;
			var nn:Node;
			
			overlay.graphics.clear();
			
			overlay.graphics.lineStyle(1, 0xff0000);
			
			for (var i:int = 0; i < ROWS; i++)
			{
				for (var j:int = 0; j < COLS; j++)
				{
					n = Nodes[i][j];
					
					if (n != startNode && n != endNode)
					{
						if (n.asn.bIsClosed)
							n.gotoAndStop(5);
						else if (n.asn.bIsOpen)
							n.gotoAndStop(4);
					}
					
					if ((i - 1) >= 0)
					{
						nn = Nodes[i-1][j];
					
						if (nn.asn.neighbors.indexOf(n.asn) >= 0)
						{
							overlay.graphics.moveTo(n.x - 2, n.y);
							overlay.graphics.lineTo(nn.x + 2, nn.y);
						}
					}
					if ((i + 1) < ROWS)
					{
						nn = Nodes[i+1][j];
					
						if (nn.asn.neighbors.indexOf(n.asn) >= 0)
						{
							overlay.graphics.moveTo(n.x + 2, n.y);
							overlay.graphics.lineTo(nn.x - 2, nn.y);
						}
					}
					if ((j - 1) >= 0)
					{
						nn = Nodes[i][j-1];
					
						if (nn.asn.neighbors.indexOf(n.asn) >= 0)
						{
							overlay.graphics.moveTo(n.x, n.y - 2);
							overlay.graphics.lineTo(nn.x, nn.y + 2);
						}
					}
					if ((j + 1) < COLS)
					{
						nn = Nodes[i][j+ 1];
					
						if (nn.asn.neighbors.indexOf(n.asn) >= 0)
						{
							overlay.graphics.moveTo(n.x, n.y + 2);
							overlay.graphics.lineTo(nn.x, nn.y - 2);
						}
					}
				
				}
			}
		}
		
		public function disconnectNode(row:uint, col:uint):void
		{
			var n:Node = Nodes[row][col];
			var asn:ASNode;
			var nv:Vector.<ASNode>;
			
			
			var counter:int = 0;
			
			for (var i:int = n.asn.neighbors.length -1; i >= 0 ; i--)
			{
				counter++;
				nv = n.asn.neighbors[i].neighbors;
				asn = n.asn.neighbors[i];
				nv.splice(nv.indexOf(n.asn), 1);
				n.asn.neighbors.splice(n.asn.neighbors.indexOf(asn), 1);
			}
			
			drawConnections();
			
		}
		
		public function connectNode(row:uint, col:uint):void
		{
			var n:Node = Nodes[row][col];
			var nn:Node;
					
			if ((row - 1) >= 0)
			{
				nn = Nodes[row-1][col];
				n.asn.neighbors.push(nn.asn);
				nn.asn.neighbors.push(n.asn);
				// overlay.graphics.moveTo(n.x, n.y);
				// overlay.graphics.lineTo(Nodes[row-1][col].x, Nodes[row-1][col].y);
			}
			if ((row + 1) < ROWS)
			{
				nn = Nodes[row + 1][col];
				n.asn.neighbors.push(nn.asn);
				nn.asn.neighbors.push(n.asn);
				// overlay.graphics.moveTo(n.x, n.y);
				// overlay.graphics.lineTo(Nodes[row+1][col].x, Nodes[row+1][col].y);
			}
			if ((col - 1) >= 0)
			{
				nn = Nodes[row][col - 1];
				n.asn.neighbors.push(nn.asn);
				nn.asn.neighbors.push(n.asn);
				// overlay.graphics.moveTo(n.x, n.y);
				// overlay.graphics.lineTo(Nodes[row][col-1].x, Nodes[row][col-1].y);
			}
			if ((col + 1) < COLS)
			{
				nn = Nodes[row][col + 1];
				n.asn.neighbors.push(nn.asn);
				nn.asn.neighbors.push(n.asn);
				// overlay.graphics.moveTo(n.x, n.y);
				// overlay.graphics.lineTo(Nodes[row][col+1].x, Nodes[row][col+1].y);
			}
			
			drawConnections();
		}
		
		public function this_addedToStage(e:Event):void
		{
			
			
			var n:Node = null;
			
			// Create nodes and put them in a two dimensional array
			for (var i:uint = 0; i < ROWS; i++)
			{
				Nodes[i] = new Array(COLS);
				for (var j:uint = 0; j < COLS; j++)
				{
					n = new Node();
					
					n.x = 50 + i * 10;
					n.y = 50 + j * 10;
					n.alpha = 1;
					n.indexX = i;
					n.indexY = j;
					this.addChild(n);
					
					
					var asn:ASNode = new ASNode(n.x, n.y);
					n.asn = asn;
					asn.userData = n;
					
					n.addEventListener(MouseEvent.ROLL_OVER, node_mRollOver);
					n.addEventListener(MouseEvent.CLICK, node_mClick);
					
					Nodes[i][j] = n;
				}
			}
			
			overlay = new Sprite();
			
			this.addChild(overlay);
			overlay.graphics.lineStyle(1, 0xff0000);
			
			// Connect the nodes with their neighbors
			for (i = 0; i < ROWS; i++)
			{
				for (j = 0; j < COLS; j++)
				{
					n = Nodes[i][j];
					
					if ((i - 1) >= 0)
					{
						n.asn.neighbors.push(Nodes[i-1][j].asn);
						overlay.graphics.moveTo(n.x - 2, n.y);
						overlay.graphics.lineTo(Nodes[i-1][j].x + 2, Nodes[i-1][j].y);
					}
					if ((i + 1) < ROWS)
					{
						n.asn.neighbors.push(Nodes[i+1][j].asn);
						overlay.graphics.moveTo(n.x + 2, n.y);
						overlay.graphics.lineTo(Nodes[i+1][j].x - 2, Nodes[i+1][j].y);
					}
					if ((j - 1) >= 0)
					{
						n.asn.neighbors.push(Nodes[i][j-1].asn);
						overlay.graphics.moveTo(n.x, n.y - 2);
						overlay.graphics.lineTo(Nodes[i][j-1].x, Nodes[i][j-1].y + 2);
					}
					if ((j + 1) < COLS)
					{
						n.asn.neighbors.push(Nodes[i][j+1].asn);
						overlay.graphics.moveTo(n.x, n.y + 2);
						overlay.graphics.lineTo(Nodes[i][j+1].x, Nodes[i][j+1].y - 2);
					}
				}
			}
			
			
			
			startNode = Nodes[49][43];
			endNode = Nodes[4][6];
			startNode.gotoAndStop(2);
			endNode.gotoAndStop(3);
			
			
			
			tools.btnSearch.addEventListener(MouseEvent.CLICK, btnSearch_mClick);
			tools.btnStep.addEventListener(MouseEvent.CLICK, btnStep_mClick);
			tools.btnSetup.addEventListener(MouseEvent.CLICK, btnSetup_mClick);
			tools.btnToggleOverlay.addEventListener(MouseEvent.CLICK, btnToggleOverlay_mClick);
			
			tools.cRed.addEventListener(MouseEvent.ROLL_OVER, cRed_mRollOver);
			tools.cGreen.addEventListener(MouseEvent.ROLL_OVER, cGreen_mRollOver);
			tools.cBlue.addEventListener(MouseEvent.ROLL_OVER, cBlue_mRollOver);
			tools.cYellow.addEventListener(MouseEvent.ROLL_OVER, cYellow_mRollOver);
			tools.cMagenta.addEventListener(MouseEvent.ROLL_OVER, cMagenta_mRollOver);
			tools.cCyan.addEventListener(MouseEvent.ROLL_OVER, cCyan_mRollOver);
			
			tools.slOverlayAlpha.addEventListener(SliderEvent.CHANGE, slOverlayAlpha_Change);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mUp);
			
			
		}
		
		public function slOverlayAlpha_Change(e:SliderEvent):void
		{			
			overlay.alpha = (tools.slOverlayAlpha.value / 1000);
		}
		
		public function cRed_mRollOver(e:MouseEvent):void
		{
			tools.txtOutput.text = "The red node is the End or target of the search.";
		}
		
		public function cGreen_mRollOver(e:MouseEvent):void
		{
			tools.txtOutput.text = "The green node is the Start of the search.";
		}
		
		public function cBlue_mRollOver(e:MouseEvent):void
		{
			tools.txtOutput.text = "Blue nodes show which nodes have been discovered but not yet searched.";
		}
		
		public function cYellow_mRollOver(e:MouseEvent):void
		{
			tools.txtOutput.text = "Yellow nodes show which nodes have been visited and closed.";
		}
		
		public function cMagenta_mRollOver(e:MouseEvent):void
		{
			
		}
		
		public function cCyan_mRollOver(e:MouseEvent):void
		{
			tools.txtOutput.text = "Cyan nodes show the final path constructed after the search has finished.";
		}
		
		public function btnToggleOverlay_mClick(e:MouseEvent):void
		{
			overlay.visible = !overlay.visible;
		}
		
		public function stage_mDown(e:MouseEvent):void
		{
			bMouseDown = true;
		}
		
		public function stage_mUp(e:MouseEvent):void
		{
			bMouseDown = false;
		}
		
		public function reset():void
		{
			var n:Node;
			
			AStar.HeuristicWeight = Number(tools.txtHWeight.text);
			
			for (var i:int = 0; i < ROWS; i++)
			{
				for (var j:int = 0; j < COLS; j++)
				{
					n = Nodes[i][j];
					if (n != startNode && n != endNode)
						n.gotoAndStop(1);
						
					n.asn.bIsClosed = false;
					n.asn.bIsOpen = false;
					n.asn.next = null;
					n.asn.prev = null;
					n.asn.cameFrom = null;
				}
			}
		}
		
		public function node_mClick(e:MouseEvent):void
		{
			if (tools.rbSetStart.selected)
			{
				startNode.gotoAndStop(1);
				startNode = (e.target as Node);
				startNode.gotoAndStop(2);
			}
			else if (tools.rbSetEnd.selected)
			{
				endNode.gotoAndStop(1);
				endNode = (e.target as Node);
				endNode.gotoAndStop(3);
			}
		}
		
		public function node_mRollOver(e:MouseEvent):void
		{
			var n:Node = (e.target as Node);
			
			if (bMouseDown)
			{
				if (tools.rbEnable.selected)
				{
					connectNode(n.indexX, n.indexY);
				}
				else if (tools.rbDisable.selected)
				{
					disconnectNode(n.indexX, n.indexY);
				}
			}
			
			tools.txtOutput.text = "G: " + n.asn.G.toString(); 
			tools.txtOutput.appendText("\nH: " + (Math.round(n.asn.H * 100) / 100).toString() + " - H with weight: " + (Math.round(n.asn.H * 100 * AStar.HeuristicWeight) / 100).toString());
			tools.txtOutput.appendText("\nF: " + (Math.round(n.asn.F * 100) / 100).toString() + " - F with weight: " + ((Math.round(n.asn.H * 100 * AStar.HeuristicWeight) / 100) + n.asn.G).toString());
			tools.txtOutput.appendText("\nOpen: " + n.asn.bIsOpen.toString() + "\nClosed: " + n.asn.bIsClosed.toString());
		}
		
		public function btnSetup_mClick(e:MouseEvent):void
		{
			reset();
			
			AStar.Setup(startNode.asn, endNode.asn);
			
			drawConnections();
		}
		
		public function btnSearch_mClick(e:MouseEvent):void
		{
			reset();
			
			var startTime:uint = 0;
			var endTime:uint = 0;
						
			var result:Boolean = false;
			var arr:Array = [];
			
			startTime = getTimer();
			result = AStar.Search(startNode.asn, endNode.asn, arr);
			endTime = getTimer();

			tools.txtOutput2.text = "Search was " + ((result) ? "successful" : "not successful") + "\nand took " + (endTime - startTime).toString() + "ms.";
			
			drawConnections();
			
			if (result)
			{
				
				for (var i:int = 0; i < arr.length; i++)
				{
					if ((arr[i].userData) != startNode && arr[i].userData != endNode)
						((arr[i] as ASNode).userData as Node).gotoAndStop(6);
				}
			}
		}
		
		public function btnStep_mClick(e:MouseEvent):void
		{
			trace(AStar.Step());
			drawConnections();
		}
	}
}