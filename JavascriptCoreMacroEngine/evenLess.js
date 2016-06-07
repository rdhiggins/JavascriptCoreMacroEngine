function() {
    var currentInner = getInnerProgress();
    var currentMiddle = getMiddleProgress();
    var currentOuter = getOuterProgress();
    
    setInnerProgress(currentInner - Math.random());
    setMiddleProgress(currentMiddle - Math.random());
    setOuterProgress(currentOuter - Math.random());
}
