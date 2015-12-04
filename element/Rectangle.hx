package element;

import js.html.CanvasRenderingContext2D;

/**
 * This class represents a rectangle that would be drawn on the surface.
 */
class Rectangle implements IElement
{
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;
    public var lineWidth:Int;
    public var lineColor:Dynamic;
    public var fillColor:Dynamic;

    /**
     * Creates a rectangle. Every number values are in inch.
     * @param  x          The x position.
     * @param  y          The y position.
     * @param  width      The width.
     * @param  height     The height.
     * @param  lineWidth  The line width.
     * @param  lineColor  The line color.
     * @param  fillColor  The fill color.
     */
    public function new(x:Float, y:Float, width:Float, height:Float,
            lineWidth:Int=1, lineColor:Dynamic="black", ?fillColor:Dynamic)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.fillColor = fillColor;
        this.lineWidth = lineWidth;
        this.lineColor = lineColor;
    }

    /**
     * Draws the rectangle in the context.
     */
    public function draw(context:CanvasRenderingContext2D):Void
    {
        context.beginPath();
        context.rect(x, y, width, height);
        if(fillColor !=  null)
        {
            context.fillStyle = fillColor;
            context.fill();
        }
        context.lineWidth = lineWidth;
        context.strokeStyle = lineColor;
        context.stroke();
    }
}
