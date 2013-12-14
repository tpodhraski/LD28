package prototype
{
    import feathers.controls.ScrollContainer;

    import flash.geom.Rectangle;

    import prototype.entities.Player;

    import starling.display.Sprite;
    import starling.events.Event;

    public class Screen extends ScrollContainer
    {
        private var _player:Player;
        private var _worldRepresentation:World;
        private var _world:WorldSync;

        public function Screen(player:Player, world:World, worldSync:WorldSync)
        {
            _player = player;
            _worldRepresentation = world;
            _world = worldSync;

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);


            this.addChild(_worldRepresentation);

            this.width = this.stage.stageWidth / 2;
            this.height = this.stage.stageHeight;
            //this.clipRect = new Rectangle(0, 0, this.stage.stageWidth / 2, this.stage.stageHeight);
        }


    }
}
