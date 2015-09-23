package;

import element.IElement;
import element.Rectangle;
import element.Dogbone;

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


    public function getGCode(bitLength:Float, feedrate:Float):String
    {
        return "";
    }
}
