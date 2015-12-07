package stand;

import element.IElement;
import element.Rectangle;
import element.Dogbone;
import element.Text;
import App.Point;
import App.Coordinate;

/**
 * Mother class for the classes which generate the stand (graphical elements
 * displayed and the GCode).
 */
class Stand
{
    public static var MARGIN_CENTRAL(default, null):Float = 1/2;
    public static var HEIGHT_SUPPORT(default, null):Float = 3;

    public var width(default, null):Float;
    public var height(default, null):Float;
    private var bitWidth:Float;
    private var thickness:Float;

    private var centralPart:Rectangle;
    private var dogbone:Dogbone;
    private var supportPart:Rectangle;
    private var supportCarving:Rectangle;

    private var surface:Surface;

    /**
     * Creates an instance of the stand class.
     * @param  surface    The surface on which the elements will be drawn.
     * @param  width      The width of the stand.
     * @param  height     The height of the stand.
     * @param  bitWidth   The width of the bit which will cut the board.
     * @param  thickness  The thickness of the board which will be cut.
     */
    public function new(surface:Surface, width:Float, height:Float,
            bitWidth:Float, thickness:Float)
    {
        this.surface = surface;
        this.width = width;
        this.height = height;
        this.bitWidth = bitWidth;
        this.thickness = thickness;
    }

    /**
     * Updates the display of the size the whole operation will take on the
     * board. Needs to be called when the parameters are changed.
     */
    public function updateTotalSize():Void { }

    /**
     * Creates the basic elements that constitues the stand and adds them to
     * the surface (does not draw or place them).
     */
    public function createElements():Void
    {
        var radiusBone:Float = bitWidth * surface.inToPx / 2;
        var wElt:Float = width * surface.inToPx;
        var hElt:Float = height * surface.inToPx;
        centralPart = new Rectangle(0, 0, wElt, hElt);

        wElt = (width - 2 * MARGIN_CENTRAL) * surface.inToPx;
        hElt = (thickness + 0.0625) * surface.inToPx;
        dogbone = new Dogbone(0, 0, wElt, hElt, radiusBone);

        wElt = dogbone.width;
        hElt = HEIGHT_SUPPORT * surface.inToPx;
        supportPart = new Rectangle(0, 0, wElt, hElt);

        wElt = supportPart.width;
        hElt = thickness * surface.inToPx;
        supportCarving = new Rectangle(0, 0, wElt, hElt, 1,
                "grey", "grey");

        surface.removeAll();
        surface.add(centralPart);
        surface.add(dogbone);
        surface.add(supportPart);
        surface.add(supportCarving);
    }

    /**
     * Sets the board thickness.
     * @param  boardThickness  The board thickness.
     */
    public function setBoardThickness(boardThickness:Float):Void
    {
        thickness = Math.max(0, boardThickness);
        createElements();
    }

    /**
     * Sets the bit width.
     * @param  bitWidth  The bit width.
     */
    public function setBitWidth(bitWidth:Float):Void
    {
        this.bitWidth = Math.max(0, bitWidth);
        createElements();
    }

    //marginXinPx is the margin from the x side (if in two files, sepration...)
    /**
     * Gets the real coordinate (in inches) of the element.
     * @param  element  The element.
     * @param  marginXinPx  The margin of the element in pixel. This is useful
     *                      when the stand is separated in two files. The
     *                      element of the second file is displayed on the
     *                      right.
     * @return  The real coordinate.
     */
    private function getRealCoordinate(element:IElement, marginXinPx:Float=0):Coordinate
    {
        var x:Float = element.x;
        var y:Float = surface.canvas.width - (element.y + element.height);
        return {
            x : (x - marginXinPx) / surface.inToPx,
            y : y / surface.inToPx,
            width : element.width / surface.inToPx,
            height : element.height / surface.inToPx
        };
    }

    /**
     * Writes a G0 or G1 command, without an end line (\n) at the end.
     * @param  type  The type of the command. Can be 0 or 1 only.
     * @param  f     The feedrate. Is ignored if generating a G0 command (Will
     *               not be put in the command).
     * @param  x     The x parameter.
     * @param  y     The y parameter.
     * @param  z     The z parameter.
     * @return  The command or an empty string if the parameters are wrong.
     */
    private function g(type:Int, f:Float, ?x:Float, ?y:Float, ?z:Float):String
    {
        if(type != 0 && type != 1)
            return "";

        var code:String = "G" + type;
        if(x != null)
            code += " X" + x;
        if(y != null)
            code += " Y" + y;
        if(z != null)
            code += " Z" + z;
        if(type == 1)
            code += " F" + f;
        return code;
    }

    /**
     * Calculates the length of the vector.
     * @param  vector  The vector.
     * @return  The vector length.
     */
    private function lengthVector(vector:Point):Float
    {
        return Math.sqrt(Math.pow(vector.x, 2) + Math.pow(vector.y, 2));
    }

    /**
     * Calculates the path for creating a tap. When cutting a rectangle in a
     * material, taps are used to permit the board to be stable (if no tap, it
     * is possible that the cut rectangle will be ejected from the material
     * because of the spinning of the bit).
     * Taps are situead in the middle of the path.
     * @param  start  The path start.
     * @param  end    The path end.
     * @param  size   The tap size. If the size is superior or equal to the path
     *                size, no tap is created.
     * @return  The start (0) and end (1) points of the tap.
     */
    private function calculateTap(start:Point, end:Point, size:Float):Array<Point>
    {
        var tap:Array<Point> = new Array<Point>();
        if(size <= 0)
            return tap;

        var vector:Point = { x : end.x - start.x, y : end.y - start.y, };
        var pathSize:Float = lengthVector(vector);

        if(size >= pathSize)
            return tap;

        var normalized:Point = {
            x : vector.x / pathSize,
            y : vector.y / pathSize
        };
        var cutLength = (pathSize - size) / 2;
        // Vector of the cut from the start to the end (relatively to the start
        // position):
        var vectorCut:Point = {
            x : cutLength * normalized.x,
            y : cutLength * normalized.y
        }

        var tapStart:Point = {
            x : start.x + vectorCut.x,
            y : start.y + vectorCut.y
        }
        var tapEnd:Point = {
            x : end.x - vectorCut.x,
            y : end.y - vectorCut.y
        }
        tap.push(tapStart);
        tap.push(tapEnd);

        return tap;
    }

    /**
     * Generates the GCode for the tap.
     * @param  start          The path start.
     * @param  end            The path end.
     * @param  zCurrentDepth  The current z position of the current cut.
     * @param  zDepthTopTap   The z position of the top of the tap.
     * @param  feedrate       The feedrate.
     * @return  The generated GCode.
     */
    private function gcodeTap(start:Point, end:Point, zCurrentDepth:Float,
            zDepthTopTap:Float, feedrate:Float):String
    {
        var codes:Array<String> = new Array<String>();

        codes.push(g(1, feedrate, start.x, start.y, zCurrentDepth));
        codes.push(g(1, feedrate, null, null, zDepthTopTap));
        codes.push(g(1, feedrate, end.x, end.y));
        codes.push(g(1, feedrate, null, null, zCurrentDepth));

        return codes.join("\n");
    }

    /**
     * Generates the GCode for cutting the path.
     * Inserts the bit in the first point then follows the path until reaching
     * the last point. Continues until cutting at the chosen depth then leaves.
     * Assumes the bit is above the board and not inside.
     * All number values are in inches.
     * @param  path             The path.
     * @param  depth            The depth of the cut. This value should be
     *                          negative.
     * @param  bitLength        The bit length.
     * @param  feedrate         The feedrate.
     * @param  rectangleAndTap  If true, will consider this path is a closed
     *                          rectangle and will generate taps.
     * @return  The generated GCode.
     */
    private function cutPath(path:Array<Point>, depth:Float, bitLength:Float,
            feedrate:Float, ?rectangleAndTap:Bool=false):String
    {
        if(path.length == 0 || depth == 0)
            return "";

        var codes:Array<String> = new Array<String>();
        var safeZ:Float = 2;
        var tapLength:Float = 0.25;
        var tapHeight:Float = 0.0625;
        var depthTopTap:Float = depth + tapHeight;
        var currentDepth:Float = 0;
        var iEnd:Int = path.length - 1;

        codes.push(g(0, feedrate, path[0].x, path[0].y));
        while(currentDepth > depth)
        {
            currentDepth = Math.max(currentDepth - bitLength, depth);

            codes.push(g(1, feedrate, null, null, currentDepth));
            for(i in 0...path.length)
            {
                //The tap must be 1/16 of inches height
                if(rectangleAndTap && i > 0 &&
                        Math.abs(depth - currentDepth) <= tapHeight)
                {
                    var tap:Array<Point> = calculateTap(path[i-1], path[i],
                            tapLength);
                    if(tap.length == 2)
                    {
                        codes.push(gcodeTap(tap[0], tap[1], currentDepth,
                                    depthTopTap, feedrate));
                    }
                }
                codes.push(g(1, feedrate, path[i].x, path[i].y));
            }

            //If a closed path, no need to rise the bit each time
            if(path[0].x != path[iEnd].x || path[0].y != path[iEnd].y)
                codes.push(g(1, feedrate, null, null, safeZ));
        }

        //If a closed path, it is needed to go rise the bit
        if(path[0].x == path[iEnd].x && path[0].y == path[iEnd].y)
            codes.push(g(1, feedrate, null, null, safeZ));

        return codes.join('\n');
    }

    /**
     * Gives the path for cutting the perimeter of the rectangle.
     * @param  coordinate  The coordinate.
     * @return  The path.
     */
    private function getPathArroundRectangle(coordinate:Coordinate):Array<Point>
    {
        var halfW:Float = bitWidth / 2;
        // var coordinate:Coordinate = getRealCoordinate(element);
        var xLeft:Float = coordinate.x - halfW;
        var xRight:Float = coordinate.x + coordinate.width + halfW;
        var yDown:Float = coordinate.y - halfW;
        var yUp:Float = coordinate.y + coordinate.height + halfW;

        var path:Array<Point> = new Array<Point>();
        path.push({ x : xLeft, y : yDown });
        path.push({ x : xRight, y : yDown });
        path.push({ x : xRight, y : yUp });
        path.push({ x : xLeft, y : yUp });
        path.push({ x : xLeft, y : yDown });

        return path;
    }

    /**
     * Gives the path for cutting the perimeter and the inside of the rectangle.
     * @param  coordinate  The coordinate.
     * @param  bitWidth    The bit width.
     * @return  The path.
     */
    private function getPathInsideRectangle(coordinate:Coordinate,
            bitWidth:Float):Array<Point>
    {
        var x = coordinate.x;
        var y = coordinate.y;
        var width = coordinate.width;
        var height = coordinate.height;
        var path:Array<Point> = new Array<Point>();
        var halfW:Float = bitWidth / 2;
        var xMin:Float = x + halfW;
        var xMax:Float = x + width - halfW;
        var currentY:Float = y + halfW;
        var keepGoing:Bool = true;
        var goRight:Bool = true;

        //This to make sure everything is cut (tried width bitWidth only, let
        // material in the middle)
        var yStep:Float = bitWidth * 3 / 4;

        if(width <= bitWidth)
        {
            xMin = x + width / 2;
            xMax = xMin;
        }

        if(height <= bitWidth)
        {
            path.push({ x : xMin, y : y + height / 2 });
            if(xMin != xMax)
                path.push({ x : xMax, y : y + height / 2 });
            return path;
        }

        while(keepGoing)
        {
            //Checks if will not cut too much. If the case, adjust the position.
            if(currentY + halfW >= y + height)
            {
                currentY = y + height - halfW;
                keepGoing = false;
            }
            if(goRight)
            {
                path.push({ x : xMin, y : currentY });
                path.push({ x : xMax, y : currentY });
            }
            else
            {
                path.push({ x : xMax, y : currentY });
                path.push({ x : xMin, y : currentY });
            }
            goRight = !goRight;
            currentY += yStep;
        }

        return path;
    }

    /**
     * Gives the path for cutting the central part.
     * @return  The path.
     */
    private function getPathCentral():Array<Point>
    {
        return getPathArroundRectangle(getRealCoordinate(centralPart));
    }

    /**
     * Gives the path for cutting the dogbone in the central part.
     * @return  The path.
     */
    private function getPathDogbone():Array<Point>
    {
        var halfW:Float = bitWidth / 2;
        var coordinate:Coordinate = getRealCoordinate(dogbone);
        var yTopBone:Float = coordinate.y + coordinate.height;
        var yDownBone:Float = coordinate.y;
        var xLeft:Float = coordinate.x + halfW;
        var xRight:Float = coordinate.x + coordinate.width - halfW;

        var path:Array<Point> = getPathInsideRectangle(coordinate, bitWidth);

        //Push the left at the begin because a whole path cut the material
        // from each point to an other. Therefore if pushed at the end,
        // undesirable cuts will be done.
        path.insert(0, { x : xLeft, y : (yTopBone + yDownBone) / 2 });
        path.insert(0, { x : xLeft, y : yTopBone });
        path.insert(0, { x : xLeft, y : yDownBone });
        path.insert(0, { x : xLeft, y : (yTopBone + yDownBone) / 2 });
        path.push({ x : xRight, y : (yTopBone + yDownBone) / 2 });
        path.push({ x : xRight, y : yTopBone });
        path.push({ x : xRight, y : yDownBone });
        path.push({ x : xRight, y : (yTopBone + yDownBone) / 2 });
        path.push({ x : xLeft, y : (yTopBone + yDownBone) / 2 });
        //The last one is there to do a close path (the bit will not go up)

        return path;
    }

    /**
     * Gives the path for cutting the support part.
     * @return  The path.
     */
    private function getPathSupportPart():Array<Point>
    {
        return getPathArroundRectangle(getRealCoordinate(supportPart));
    }

    /**
     * Gives the path for cutting the carving in the support part.
     * @return  The path.
     */
    private function getPathSupportCarving():Array<Point>
    {
        var c:Coordinate = getRealCoordinate(supportCarving);
        return getPathInsideRectangle(c, bitWidth);
    }

    /**
     * Gives array of GCode (each cell is one file).
     * @return  The Gcode.
     */
    public function getGCode(bitLength:Float, feedrate:Float):Array<String>
    {
        return [];
    }

    /**
     * Gives the begging GCode used by all type of stand.
     * @return  The Gcode.
     */
    private function getBeginningGCode():String
    {
        var code:String = "G20\nG90\n";
        code += g(0, 0, null, null, 2) + "\n";
        code += "M4 (spindle on)\n";

        return code;
    }

    /**
     * Gives the ending GCode used by all type of stand.
     * @return  The Gcode.
     */
    private function getEndingGCode():String
    {
        var code:String = g(0, 0, null, null, 2) + "\n";
        code += g(0, 0, 0, 0) + "\n";
        code += "M5\nM2\nM30";

        return code;
    }
}
