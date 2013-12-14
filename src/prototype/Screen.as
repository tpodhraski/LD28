package prototype
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;

    import flash.geom.Rectangle;

    import prototype.entities.Player;
    import prototype.entities.PlayerEvent;

    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;

    import starling.events.Event;

    public class Screen extends Sprite
    {
        private var _player:Player;
        private var _worldRepresentation:World;
        private var _world:WorldSync;
        private var _fogOfWar:FogOfWar;
        private var offsetX:Number;
        private var offsetY:Number;
        private var offsetX2:Number = 0;
        private var offsetY2:Number = 0;

        public function Screen(player:Player, world:World, fogOfWar:FogOfWar, worldSync:WorldSync)
        {
            _player = player;
            _worldRepresentation = world;
            _fogOfWar = fogOfWar;
            _world = worldSync;

            world.first.addEventListener(PlayerEvent.CHANGE_LOCATION, onChangeLocationFirst);
            world.second.addEventListener(PlayerEvent.CHANGE_LOCATION, onChangeLocationSecond);

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

        }

        private function onChangeLocationFirst(event:PlayerEvent):void
        {
            revealCharacter();
        }

        private function onChangeLocationSecond(event:PlayerEvent):void
        {
            revealCharacter();
        }

        private function revealCharacter():void
        {
            _fogOfWar.reveal(_worldRepresentation.first.x / 32, _worldRepresentation.first.y / 32, 4);
            _fogOfWar.reveal(_worldRepresentation.second.x / 32, _worldRepresentation.second.y / 32, 4);


            offsetX2 = -Math.max(0, _player.x / 32 - 6) * 32;
            offsetY2 = -Math.max(0, _player.y / 32 - 4) * 32;


        }

        private function onAddedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);


            this.addChild(_worldRepresentation);
            this.addChild(_fogOfWar);

//            this.width = this.stage.stageWidth / 2;
//            this.height = this.stage.stageHeight;
            this.clipRect = new Rectangle(0, 0, this.stage.stageWidth / 2, this.stage.stageHeight);

            revealCharacter();

        }


        private function onEnterFrame(event:EnterFrameEvent):void
        {
            if (isNaN(offsetX)) offsetX = offsetX2;
            if (isNaN(offsetY)) offsetY = offsetY2;

            offsetX = (offsetX + offsetX2) / 2;
            offsetY = (offsetY + offsetY2) / 2;

            var visibility:Rectangle = new Rectangle(-offsetX, -offsetY, this.stage.stageWidth / 2, this.stage.stageHeight);
            _fogOfWar.visibleViewport = visibility;

            _fogOfWar.x = offsetX;
            _fogOfWar.y = offsetY;

            _worldRepresentation.x = offsetX;
            _worldRepresentation.y = offsetY;
        }
    }
}
