function(value) {
    var currentInner = getInnerProgress();
    var currentMiddle = getMiddleProgress();
    var currentOuter = getOuterProgress();
    
    setInnerProgress(currentInner - Math.random() / 10.0);
    setMiddleProgress(currentMiddle - Math.random() / 10.0);
    setOuterProgress(currentOuter - Math.random() / 10.0);
}
