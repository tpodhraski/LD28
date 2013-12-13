package main
{
    import flash.display.MovieClip;
    import flash.events.Event;

    public class Preloader extends MovieClip
    {
        public function Preloader()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            StarlingManager.start(this.stage);
        }
    }
}
