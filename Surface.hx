package;

import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ClientRect;
import element.IElement;

class Surface
{
    public var inToPx:Int = 10;

    public var canvas:CanvasElement;
    private var elements:Array<IElement>;

    private var mousePressing:Bool = false;
    private var elementDragged:IElement;

    public function new(canvas:CanvasElement)
    {
        elements = new Array<IElement>();
        this.canvas = canvas;
        canvas.onmousedown = mousedown;
        canvas.onmouseup = mouseup;
        canvas.onmousemove = mousemove;
        canvas.onmouseleave = mouseleave;
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

    private function mousedown(event:Dynamic):Void
    {
        mousePressing = true;
        //TODO: test dragging or firing callback
    }

    private function mouseup(event:Dynamic):Void
    {
        mousePressing = false;
        if(elementDragged != null)
            elementDragged = null;
    }

    private function mousemove(event:Dynamic):Void
    {
        if(elementDragged == null)
            return;
        var pos = getPosOnCanvas(event.clientX, event.clientY);
        trace(pos);
        //TODO: drag element, if change, draw();
    }

    private function mouseleave(event:Dynamic):Void
    {
        mousePressing = false;
        if(elementDragged != null)
            elementDragged = null;
    }
}
