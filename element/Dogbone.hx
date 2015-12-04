package element;

import js.html.CanvasRenderingContext2D;

/**
 * This class represents the shape of a dogbone.
 * In woodworking, a dogbone is a retangular hole with round relief in the
 * corners. It is used to allow rectangular objects to be inserted into it.
 */
class Dogbone implements IElement
{
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;
    public var radius:Float;

    /**
     * Creates a dogbone. Every values are in inch.
     * @param  x       The x position.
     * @param  y       The y position.
     * @param  width   The width.
     * @param  height  The height.
     * @param  radius  The radius of the corners.
     */
    public function new(x:Float, y:Float, width:Float, height:Float,
            radius:Float)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.radius = radius;
    }

    /**
     * Draws the dogbone in the context.
     */
    public function draw(context:CanvasRenderingContext2D):Void
    {
        var xLeftBone:Float = x + radius;
        var xRightBone:Float = x + width - radius;
        var yTopBone:Float = y;
        var yBottomBone:Float = y + height;

        context.beginPath();

        //Rectangle hole
        context.rect(x, y, width, height);
        context.fillStyle = "#000000";
        context.fill();
        context.lineWidth = 0;
        context.strokeStyle = "#000000";
        context.stroke();

        //Draw shape top left
        context.beginPath();
        context.arc(xLeftBone, yTopBone, radius, Math.PI, 2 * Math.PI, false);
        context.fillStyle = "#000000";
        context.fill();
        context.stroke();

        //Draw shape bottom left
        context.beginPath();
        context.arc(xLeftBone, yBottomBone, radius, 0, Math.PI, false);
        context.fillStyle = "#000000";
        context.fill();
        context.stroke();

        //Draw top right
        context.beginPath();
        context.arc(xRightBone, yTopBone, radius, Math.PI, 2 * Math.PI, false);
        context.fillStyle = "#000000";
        context.fill();
        context.stroke();

        //Draw bottom right
        context.beginPath();
        context.arc(xRightBone, yBottomBone, radius, 0, Math.PI, false);
        context.fillStyle = "#000000";
        context.fill();
        context.stroke();
    }
}
