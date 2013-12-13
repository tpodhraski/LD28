package main
{
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    import starling.core.Starling;

    public class StarlingManager
    {
        private static var _starling:Starling;

        public static function start(stage:Stage):void
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            _starling = new Starling(Main, stage);

            _starling.start();
        }
    }
}
