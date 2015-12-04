package stand;

import element.IElement;
import element.Rectangle;
import element.Dogbone;
import element.Text;
import App.Point;
import App.Coordinate;

/**
 * Class which generates the stand in one file, each part side by side
 * horizontally.
 */
class StandVertical extends Stand
{
    private var rectangleSize:Rectangle;
    private var horizontalSize:Text;
    private var verticalSize:Text;

    /**
     * Creates an instance of the stand class.
     * @param  surface    The surface on which the elements will be drawn.
     * @param  width      The width of the stand.
     * @param  height     The height of the stand.
     * @param  bitWidth   The width of the bit which will cut the board.
     * @param  thickness  The thickness of the board which will be cut.
     */
    public function new(surface:Surface, width:Float,
            height:Float, bitWidth:Float, thickness:Float)
    {
        super(surface, width, height, bitWidth, thickness);
    }

    /**
     * Updates the display of the size the whole operation will take on the
     * board. Needs to be called when the parameters are changed.
     */
    override public function updateTotalSize():Void
    {
        var cSupport:Coordinate = getRealCoordinate(supportPart);
        var cCentral:Coordinate = getRealCoordinate(centralPart);
        var margin = bitWidth * 2;
        var realWidth:Float = cCentral.width + margin + bitWidth;
        var realHeight:Float = cCentral.height + cSupport.height + 2 * margin;
        realHeight += bitWidth;
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

    /**
     * Creates the elements that constitues the stand and adds them to the
     * surface (draws and places them).
     */
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

    /**
     * Set the elements position on the surface and draws the surface
     */
    private function placeElements():Void
    {
        var inToPx:Float = surface.inToPx;
        var cHeight:Float = surface.canvas.height;
        var marginBorder:Float = bitWidth * 2 * inToPx;
        var marginParts:Float = bitWidth * 2.5 * inToPx;
        var xLeft:Float = marginBorder;
        centralPart.x = xLeft;
        centralPart.y = cHeight - marginBorder - centralPart.height;

        dogbone.x = centralPart.x + Stand.MARGIN_CENTRAL * inToPx;
        dogbone.y = centralPart.y + centralPart.height - 7 / 8 * inToPx -
            dogbone.height;

        supportPart.x = xLeft;
        supportPart.y = centralPart.y - marginParts - supportPart.height;

        supportCarving.x = supportPart.x;
        supportCarving.y = supportPart.y + supportPart.height - 0.5 * inToPx -
            supportCarving.height;

        updateTotalSize();

        surface.draw();
    }

    /**
     * Gives array of GCode (each cell is one file).
     * @return  The Gcode.
     */
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
