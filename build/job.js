/**
 * This object is created to permit Haxe to use fabmoDashboard.
 * See the description of the class Job in Job.hx.
 */
var Job = {};
Job.submitJob = function(data, config, callback) {
    fabmoDashboard.submitJob(data, config, callback);
};
