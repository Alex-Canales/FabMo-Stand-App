package stand;

import element.IElement;
import element.Rectangle;
import element.Dogbone;
import element.Text;
import App.Point;
import App.Coordinate;

class StandHorizontal extends Stand
{
    private var rectangleSize:Rectangle;
    private var horizontalSize:Text;
    private var verticalSize:Text;

    public function new(surface:Surface, width:Float,
            height:Float, bitWidth:Float, thickness:Float)
    {
        super(surface, width, height, bitWidth, thickness);
    }

    override public function updateTotalSize():Void
    {
        var cSupport:Coordinate = getRealCoordinate(supportPart);
        var cCentral:Coordinate = getRealCoordinate(centralPart);
        var margin = bitWidth * 2;
        var realWidth:Float = cCentral.width + 2 * margin + cSupport.width + bitWidth;
        var realHeight:Float = Math.max(cCentral.height, cSupport.height);
        realHeight += bitWidth + margin;
        var pixelWidth = realWidth * surface.inToPx;
        var pixelHeight = realHeight * surface.inToPx;

        rectangleSize.x = 0;
        rectangleSize.y = surface.canvas.height - pixelHeight;
        rectangleSize.width = pixelWidth;
        rectangleSize.height = pixelHeight;

        horizontalSize.x = rectangleSize.x + rectangleSize.width / 2 - 5;
        horizontalSize.y = rectangleSize.y - 5;
        horizontalSize.text = Std.string(realWidth);

        verticalSize.x = rectangleSize.x + rectangleSize.width + 5;
        verticalSize.y = rectangleSize.y + rectangleSize.height / 2 - 5;
        verticalSize.text = Std.string(realHeight);
    }

    // Create elements and add them to the surface (and draw and place them)
    override public function createElements():Void
    {
        super.createElements();

        rectangleSize = new Rectangle(0, 0, 1, 1, "red");
        horizontalSize = new Text(0, 0, "0");
        verticalSize = new Text(0, 0, "0");
        surface.add(rectangleSize);
        surface.add(horizontalSize);
        surface.add(verticalSize);

        placeElements();
    }

    // Set the elements position in the surface and draw the surface
    private function placeElements():Void
    {
        var inToPx:Float = surface.inToPx;
        var cHeight:Float = surface.canvas.height;
        var margin:Float = bitWidth * 2 * inToPx;
        var xLeft:Float = margin;
        centralPart.x = xLeft;
        centralPart.y = cHeight - margin - centralPart.height;

        dogbone.x = centralPart.x + Stand.MARGIN_CENTRAL * inToPx;
        dogbone.y = centralPart.y + centralPart.height - 7 / 8 * inToPx -
            dogbone.height;

        supportPart.x = xLeft + margin + centralPart.width;
        supportPart.y = centralPart.y + centralPart.height - supportPart.height;

        supportCarving.x = supportPart.x;
        supportCarving.y = supportPart.y + supportPart.height - 0.5 * inToPx -
            supportCarving.height;

        updateTotalSize();

        surface.draw();
    }

    // Returns array of GCode (each cell is one file)
    override public function getGCode(bitLength:Float, feedrate:Float):Array<String>
    {
        var carvDepth:Float = thickness / 5;
        var pathDogbone:Array<Point> = getPathDogbone();
        var pathCentral:Array<Point> = getPathCentral();
        var pathSupportPart:Array<Point> = getPathSupportPart();
        var pathSupportCarving:Array<Point> = getPathSupportCarving();
        var code:String = getBeginningGCode();

        //It is better to do carving and simple cuts before cutting parts
        // (for the stability)
        code += g(0, feedrate, null, null, 2) + "\n";
        code += cutPath(pathDogbone, -thickness, bitLength, feedrate) + "\n";
        code += cutPath(pathSupportCarving, -carvDepth, bitLength, feedrate);
        code +=  "\n";
        code += cutPath(pathCentral, -thickness, bitLength, feedrate, true);
        code += "\n";
        code += cutPath(pathSupportPart, -thickness, bitLength, feedrate, true);
        code += "\n";

        code += getEndingGCode();
        return [code];
    }
}
