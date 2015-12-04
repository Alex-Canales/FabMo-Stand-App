package element;

import js.html.CanvasRenderingContext2D;

/**
 * This class represents a text that would be writen on the surface.
 */
class Text implements IElement
{
    public var x:Float;
    public var y:Float;
    public var text:String;
    public var width:Float;
    public var height:Float;

    /**
     * Creates a dogbone. Every number values are in inch.
     * @param  x     The x position.
     * @param  y     The y position.
     * @param  text  The text.
     */
    public function new(x, y, text)
    {
        this.x = x;
        this.y = y;
        this.text = text;
    }

    /**
     * Draws the text in the context.
     */
    public function draw(context:CanvasRenderingContext2D):Void
    {
        context.fillText(text, x, y);
    }
}
