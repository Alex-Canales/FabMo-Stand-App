package stand;

import element.IElement;
import element.Rectangle;
import element.Dogbone;
import element.Text;
import App.Point;
import App.Coordinate;

/**
 * Class which generates the stand in two different files (one for each part).
 */
class StandFiles extends Stand
{
    private var rectangleSizeSupport:Rectangle;
    private var horizontalSizeSupport:Text;
    private var verticalSizeSupport:Text;
    private var rectangleSizeCentral:Rectangle;
    private var horizontalSizeCentral:Text;
    private var verticalSizeCentral:Text;

    private var marginSeparation:Float = 50;

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
        super(surface, width, height, bitWidth, thickness);
    }

    /**
     * Updates the display of the size the whole operation will take on the
     * board. Needs to be called when the parameters are changed.
     */
    override public function updateTotalSize():Void
    {
        //Margin from the border of the board
        var margin:Float = bitWidth * 2;

        //Support part
        var cSupport:Coordinate = getRealCoordinate(supportPart);
        var realWidthSupport:Float = cSupport.width + margin + bitWidth;
        var realHeightSupport:Float = cSupport.height + margin + bitWidth;
        var pixelWidthSupport:Float = realWidthSupport * surface.inToPx;
        var pixelHeightSupport:Float = realHeightSupport * surface.inToPx;

        rectangleSizeSupport.x = supportPart.x - margin * surface.inToPx;
        rectangleSizeSupport.y = supportPart.y - bitWidth * surface.inToPx;
        rectangleSizeSupport.width = pixelWidthSupport;
        rectangleSizeSupport.height = pixelHeightSupport;

        horizontalSizeSupport.x = rectangleSizeSupport.x +
                                  rectangleSizeSupport.width / 2 - 5;
        horizontalSizeSupport.y = rectangleSizeSupport.y - 5;
        horizontalSizeSupport.text = Std.string(realWidthSupport);

        verticalSizeSupport.x = rectangleSizeSupport.x +
                                rectangleSizeSupport.width + 5;
        verticalSizeSupport.y = rectangleSizeSupport.y +
                                rectangleSizeSupport.height / 2 - 5;
        verticalSizeSupport.text = Std.string(realHeightSupport);

        //Central part
        var cCentral:Coordinate = getRealCoordinate(centralPart);
        var realWidthCentral:Float = cCentral.width + margin + bitWidth;
        var realHeightCentral:Float = cCentral.height + margin + bitWidth;
        var pixelWidthCentral:Float = realWidthCentral * surface.inToPx;
        var pixelHeightCentral:Float = realHeightCentral * surface.inToPx;

        rectangleSizeCentral.x = centralPart.x - margin * surface.inToPx;
        rectangleSizeCentral.y = centralPart.y - bitWidth * surface.inToPx;
        rectangleSizeCentral.width = pixelWidthCentral;
        rectangleSizeCentral.height = pixelHeightCentral;

        horizontalSizeCentral.x = rectangleSizeCentral.x +
                                  rectangleSizeCentral.width / 2 - 5;
        horizontalSizeCentral.y = rectangleSizeCentral.y - 5;
        horizontalSizeCentral.text = Std.string(realWidthCentral);

        verticalSizeCentral.x = rectangleSizeCentral.x +
                                rectangleSizeCentral.width + 5;
        verticalSizeCentral.y = rectangleSizeCentral.y +
                                rectangleSizeCentral.height / 2 - 5;
        verticalSizeCentral.text = Std.string(realHeightCentral);
    }

    /**
     * Creates the elements that constitues the stand and adds them to the
     * surface (draws or places them).
     */
    override public function createElements():Void
    {
        super.createElements();

        rectangleSizeSupport = new Rectangle(0, 0, 1, 1, "red");
        horizontalSizeSupport = new Text(0, 0, "0");
        verticalSizeSupport = new Text(0, 0, "0");
        rectangleSizeCentral = new Rectangle(0, 0, 1, 1, "red");
        horizontalSizeCentral = new Text(0, 0, "0");
        verticalSizeCentral = new Text(0, 0, "0");

        surface.add(rectangleSizeSupport);
        surface.add(horizontalSizeSupport);
        surface.add(verticalSizeSupport);
        surface.add(rectangleSizeCentral);
        surface.add(horizontalSizeCentral);
        surface.add(verticalSizeCentral);

        placeElements();
    }

    /**
     * Set the elements position on the surface and draws the surface
     */
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

        supportPart.x = xLeft + centralPart.width + marginSeparation;
        supportPart.y = cHeight - margin - supportPart.height;

        supportCarving.x = supportPart.x;
        supportCarving.y = supportPart.y + supportPart.height - 0.5 * inToPx -
            supportCarving.height;

        updateTotalSize();

        surface.draw();
    }

    /**
     * Gives the path for cutting the support part.
     * @return  The path.
     */
    override private function getPathSupportPart():Array<Point>
    {
        var margin:Float = supportPart.x - bitWidth * surface.inToPx * 2;
        return getPathArroundRectangle(getRealCoordinate(supportPart, margin));
    }

    /**
     * Gives the path for cutting the carving in the support part.
     * @return  The path.
     */
    override private function getPathSupportCarving():Array<Point>
    {
        var margin:Float = supportPart.x - bitWidth * surface.inToPx * 2;
        var c:Coordinate = getRealCoordinate(supportCarving, margin);
        return getPathInsideRectangle(c, bitWidth);
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

        var codeSupport:String = getBeginningGCode();
        var codeCentral:String = getBeginningGCode();

        codeCentral += cutPath(pathDogbone, -thickness, bitLength, feedrate);
        codeCentral += "\n";
        codeCentral += cutPath(pathCentral, -thickness, bitLength, feedrate, true);
        codeCentral += "\n" + getEndingGCode();

        codeSupport += cutPath(pathSupportCarving, -carvDepth, bitLength, feedrate);
        codeSupport +=  "\n";
        codeSupport += cutPath(pathSupportPart, -thickness, bitLength, feedrate, true);
        codeSupport += "\n" + getEndingGCode();

        return [codeCentral, codeSupport];
    }
}
