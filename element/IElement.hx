package element;

import js.html.CanvasRenderingContext2D;

/**
 * This interface is a backbone for creating element that could be handle by
 * the class Surface.
 */
interface IElement
{
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    /**
     * Draws the element in the context.
     */
    public function draw(context:CanvasRenderingContext2D):Void;
}
