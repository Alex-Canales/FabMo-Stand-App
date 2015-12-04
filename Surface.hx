package;

import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ClientRect;
import element.IElement;

/**
 * Defines a surface. The surface can store elements (as rectangles or text)
 * and draw them.
 */
class Surface
{
    public var inToPx(default, set):Int = 20;

    public var canvas:CanvasElement;
    private var elements:Array<IElement>;

    /**
     * Creates the surface.
     * @param  canvas  The canvas on which the surface will draw elements.
     */
    public function new(canvas:CanvasElement)
    {
        elements = new Array<IElement>();
        this.canvas = canvas;
    }

    /**
     * Adds an element to the surface.
     * @param  element  The element to add.
     */
    public function add(element:IElement):Void
    {
        elements.push(element);
        draw();
    }

    /**
     * Removes an element from the surface.
     * @param  element  The element to remove.
     */
    public function remove(element:IElement):Void
    {
        elements.remove(element);
        draw();
    }

    /**
     * Removes all elements from the surface.
     */
    public function removeAll():Void
    {
        elements.splice(0, elements.length);
        draw();
    }

    /**
     * Sets how much a inch is in pixel.
     * @param  value  The number of pixel an inch will take.
     */
    public function set_inToPx(value:Int):Int
    {
        inToPx = Std.int(Math.max(1, value));
        return inToPx;
    }

    /**
     * Draws the surface.
     */
    public function draw():Void
    {
        var context:CanvasRenderingContext2D = canvas.getContext2d();
        clear(context);
        for(elt in elements)
        {
            elt.draw(context);
        }
    }

    /**
     * Clears the surface (erases everything).
     * @param  context  The context of the canvas.
     */
    private function clear(context:CanvasRenderingContext2D ):Void
    {
        context.clearRect(0, 0, context.canvas.width, context.canvas.height);
    }
}
