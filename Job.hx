package;

/**
 * This class serves has a gate from the Haxe code to the JavaScript code.
 * Haxe can access to an existant JavaScript object by creating an external
 * class (as here) having the same name than the object. But classes in Haxe
 * have to start with a capital case.
 * dashboard.js defines an object called fabmoDashboard containing a function
 * named submitJob(). fabmoDashboard starts in minimal case so we have to
 * create in Javascript an object called Job and wrapping fabmoDashboard.
 * Therefore, this class serves as a gate to this JavaScript object serving has
 * a wrapper for the fabmoDashboard.
 */
extern class Job
{
    /**
     * Submits job to the dashboard.
     * @param data      The data (job) to send.
     * @param config    The configuration parameters.
     * @param callback  The callback function to call.
     */
    public static function submitJob(data:String, config:Dynamic,
            ?callback:Dynamic):Void;
}
