package;

import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ClientRect;
import element.IElement;

class Surface
{
    public var inToPx:Int = 20;

    public var canvas:CanvasElement;
    private var elements:Array<IElement>;

    public function new(canvas:CanvasElement)
    {
        elements = new Array<IElement>();
        this.canvas = canvas;
    }

    public function add(element:IElement):Void
    {
        elements.push(element);
        draw();
    }

    public function remove(element:IElement):Void
    {
        elements.remove(element);
        draw();
    }

    public function removeAll():Void
    {
        elements.splice(0, elements.length);
        draw();
    }

    public function setInToPx(value:Int):Void
    {
        inToPx = Std.int(Math.max(1, value));
    }

    public function draw():Void
    {
        var context:CanvasRenderingContext2D = canvas.getContext2d();
        clear(context);
        for(elt in elements)
        {
            elt.draw(context);
        }
    }

    private function clear(context:CanvasRenderingContext2D ):Void
    {
        context.clearRect(0, 0, context.canvas.width, context.canvas.height);
    }

    private function getPosOnCanvas(clientX:Float, clientY:Float):App.Point
    {
        var rect:ClientRect = canvas.getBoundingClientRect();
        return { x : clientX - rect.left, y : clientY - rect.top };
    }
}
