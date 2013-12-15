package prototype
{
    import Core.Geometry;

    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;

    import flash.geom.Point;

    import flash.geom.Rectangle;

    import main.Build;

    import prototype.entities.Player;
    import prototype.entities.PlayerEvent;

    import starling.display.Quad;

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
            _fogOfWar.reveal(_worldRepresentation.first.x / Build.CELL_WIDTH, _worldRepresentation.first.y / Build.CELL_HEIGHT, 4);
            _fogOfWar.reveal(_worldRepresentation.second.x / Build.CELL_WIDTH, _worldRepresentation.second.y / Build.CELL_HEIGHT, 4);


            offsetX2 = -Math.max(0, _player.x / Build.CELL_WIDTH - 6) * Build.CELL_WIDTH;
            offsetY2 = -Math.max(0, _player.y / Build.CELL_HEIGHT - 4) * Build.CELL_HEIGHT;


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
            visibility.inflate(64, 64)
            var distance:Number = Point.distance(new Point(-offsetX, -offsetY), new Point(_fogOfWar.visibleViewport.x, _fogOfWar.visibleViewport.y));
            if (distance > 60)
            {
                _fogOfWar.visibleViewport = visibility;
                _worldRepresentation.visibleViewport = visibility;
            }


            _fogOfWar.x = Math.round(offsetX);
            _fogOfWar.y = Math.round(offsetY);

            _worldRepresentation.x = Math.round(offsetX);
            _worldRepresentation.y = Math.round(offsetY);
        }
    }
}
