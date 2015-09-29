package;

import element.IElement;
import element.Rectangle;
import element.Dogbone;
import App.Point;

typedef Coordinate = { x : Float, y : Float, width : Float, height : Float };

/* Generate the stand (graphical elements and the GCode) */
class Stand
{
    public static var MARGIN_CENTRAL(default, null):Float = 1/2;
    public static var HEIGHT_SUPPORT(default, null):Float = 3;
    public static var CARVING_DEPTH(default, null):Float = 1/32;

    private var width:Float;
    private var height:Float;
    private var bitWidth:Float;
    private var thickness:Float;

    private var centralPart:Rectangle;
    private var dogbone:Dogbone;
    private var supportPart:Rectangle;
    private var supportCarving:Rectangle;

    private var surface:Surface;

    public function new(surface:Surface, width:Float, height:Float,
            bitWidth:Float, thickness:Float)
    {
        this.surface = surface;
        this.width = width;
        this.height = height;
        this.bitWidth = bitWidth;
        this.thickness = thickness;
        createElements();
    }

    public function createElements():Void
    {
        var radiusBone:Float = bitWidth * surface.inToPx / 2;
        var wElt:Float = width * surface.inToPx;
        var hElt:Float = height * surface.inToPx;
        centralPart = new Rectangle(0, 0, false, null, wElt, hElt);

        wElt = (width - 2 * MARGIN_CENTRAL) * surface.inToPx;
        hElt = thickness * surface.inToPx;
        dogbone = new Dogbone(0, 0, false, null, wElt, hElt, radiusBone);

        wElt = dogbone.width;
        hElt = HEIGHT_SUPPORT * surface.inToPx;
        supportPart = new Rectangle(0, 0, false, null, wElt, hElt);

        wElt = supportPart.width;
        hElt = thickness * surface.inToPx;
        supportCarving = new Rectangle(0, 0, false, null, wElt, hElt, 1,
                "grey", "grey");

        surface.removeAll();
        surface.add(centralPart);
        surface.add(dogbone);
        surface.add(supportPart);
        surface.add(supportCarving);

        placeElements();
    }

    // Set and put the elements in the surface and draw the surface
    private function placeElements():Void
    {
        var inToPx:Float = surface.inToPx;
        var cHeight:Float = surface.canvas.height;
        var margin:Float = bitWidth * 2 * inToPx;
        var xLeft:Float = margin;
        centralPart.x = xLeft;
        centralPart.y = cHeight - margin - centralPart.height;

        dogbone.x = centralPart.x + MARGIN_CENTRAL * inToPx;
        dogbone.y = centralPart.y + centralPart.height - 7 / 8 * inToPx -
            dogbone.height;

        supportPart.x = xLeft;
        supportPart.y = centralPart.y - margin - supportPart.height;

        supportCarving.x = xLeft;
        supportCarving.y = supportPart.y + supportPart.height - 0.5 * inToPx -
            supportCarving.height;

        surface.draw();
    }

    public function setBoardThickness(boardThickness:Float):Void
    {
        thickness = Math.max(0, boardThickness);
        createElements();
    }

    public function setBitWidth(bitWidth:Float):Void
    {
        this.bitWidth = Math.max(0, bitWidth);
        createElements();
    }

    private function getRealCoordinate(element:IElement):Coordinate
    {
        var x:Float = element.x;
        var y:Float = surface.canvas.width - (element.y + element.height);
        return {
            x : x / surface.inToPx,
            y : y / surface.inToPx,
            width : element.width / surface.inToPx,
            height : element.height / surface.inToPx
        };
    }

    // Write a G0 or G1 command, without \n at the end
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
        code += " F" + f;
        return code;
    }

    // Returns the GCode for cutting this part
    // The bit will insert in the first point then follow the path until
    // the last point and leave. Continue until cut at the chosen depth.
    // Assumes the bit is above the board and not inside
    //  depth is negative (cutting into 3 inches => depth = -3)
    private function cutPath(path:Array<Point>, depth:Float, bitLength:Float,
            feedrate:Float):String
    {
        if(path.length == 0 || depth == 0)
            return "";

        var codes:Array<String> = new Array<String>();
        var currentDepth:Float = 0;
        var iEnd:Int = path.length - 1;

        codes.push(g(0, feedrate, path[0].x, path[0].y));
        while(currentDepth > depth)
        {
            currentDepth = Math.max(currentDepth - bitLength, depth);

            codes.push(g(1, feedrate, null, null, currentDepth));
            for(i in 0...path.length)
            {
                codes.push(g(1, feedrate, path[i].x, path[i].y));
            }

            //If a closed path, no need to rise the bit each time
            if(path[0].x != path[iEnd].x || path[0].y != path[iEnd].y)
                codes.push(g(1, feedrate, null, null, 2));
        }

        //If a closed path, it is needed to go rise the bit
        if(path[0].x == path[iEnd].x && path[0].y == path[iEnd].y)
            codes.push(g(1, feedrate, null, null, 2));

        return codes.join('\n');
    }

    private function getPathArroundRectangle(element:IElement):Array<Point>
    {
        var halfW:Float = bitWidth / 2;
        var coordinate:Coordinate = getRealCoordinate(element);
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

    private function getPathInsideRectangle(x:Float, y:Float, width:Float,
            height:Float, bitWidth:Float):Array<Point>
    {
        var path:Array<Point> = new Array<Point>();
        var halfW:Float = bitWidth / 2;
        var xMin:Float = x + halfW;
        var xMax:Float = x + width - halfW;
        var currentY:Float = y + halfW;
        var keepGoing:Bool = true;

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
            if(currentY + halfW >= y + height)
            {
                currentY = y + height - halfW;
                keepGoing = false;
            }
            path.push({ x : xMin, y : currentY });
            path.push({ x : xMax, y : currentY });
            currentY += bitWidth;
        }

        return path;
    }

    private function getPathCentral():Array<Point>
    {
        return getPathArroundRectangle(centralPart);
    }

    private function getPathDogbone():Array<Point>
    {
        var halfW:Float = bitWidth / 2;
        var coordinate:Coordinate = getRealCoordinate(dogbone);
        var yTopBone:Float = coordinate.y + coordinate.height;
        var yDownBone:Float = coordinate.y;
        var xLeft:Float = coordinate.x + halfW;
        var xRight:Float = coordinate.x + coordinate.width - halfW;

        var path:Array<Point> = getPathInsideRectangle(coordinate.x, coordinate.y,
                coordinate.width, coordinate.height, bitWidth);

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

    private function getPathSupportPart():Array<Point>
    {
        return getPathArroundRectangle(supportPart);
    }

    private function getPathSupportCarving():Array<Point>
    {
        var c:Coordinate = getRealCoordinate(supportCarving);
        return getPathInsideRectangle(c.x, c.y, c.width, c.height, bitWidth);
    }

    public function getGCode(bitLength:Float, feedrate:Float):String
    {
        var carvDepth:Float = thickness / 5;
        var pathDogbone:Array<Point> = getPathDogbone();
        var pathCentral:Array<Point> = getPathCentral();
        var pathSupportPart:Array<Point> = getPathSupportPart();
        var pathSupportCarving:Array<Point> = getPathSupportCarving();
        var code:String = "G20 G90\n";
        code += g(0, feedrate, null, null, 2) + "\n";
        code += cutPath(pathDogbone, -thickness, bitLength, feedrate) + "\n";
        code += cutPath(pathCentral, -thickness, bitLength, feedrate) + "\n";
        code += cutPath(pathSupportPart, -thickness, bitLength, feedrate) + "\n";
        code += cutPath(pathSupportCarving, -carvDepth, bitLength, feedrate);
        code +=  "\n";

        code += "M30";
        return code;
    }
}
